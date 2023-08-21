//
//  OrderTableViewController.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/21.
//

import UIKit

class OrderTableViewController: UITableViewController {

    @IBOutlet weak var TotalCupCountLabel: UILabel!
    @IBOutlet weak var TotalPayPriceLabel: UILabel!
    @IBOutlet var OrderTableView: UITableView!
    
    @IBOutlet weak var StillLoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StillLoadingIndicator.isHidden = false
        StillLoadingIndicator.startAnimating()
        initUI()
        fetchOrders()
    }
    
    //初始化
    func initUI(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 182/255, green: 151/255, blue: 100/255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "訂單"
        
        let BGimageView = UIImageView(image: UIImage(named: "kebuke-bg"))
        BGimageView.frame = self.tableView.frame
        BGimageView.contentMode = .scaleToFill
        BGimageView.clipsToBounds = false
        BGimageView.layer.opacity = 0.2
        OrderTableView.backgroundView = BGimageView;
        
    }

    // MARK: - TableView

    //section
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderRecords.count
    }

    //cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as? OrderTableViewCell else {
            fatalError("dequeueReusableCell LoverTableViewCellfailed")
        }
        let order = orderRecords[indexPath.row].fields
        cell.update(order)
        return cell
    }
    
    // MARK: - 刪除
    
    //確認刪除Order
    @IBAction func confirmDeleteOrder(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                print(indexPath.row)
                print(orderRecords[indexPath.row].id)
                print(orderRecords[indexPath.row].fields.customer)
                let deleteField = Field(id: orderRecords[indexPath.row].id, fields: orderRecords[indexPath.row].fields)
                confirmDelete(deleteField)
        }
    }
    
    //對話框 - 確認刪除
    func confirmDelete(_ deleteField:Field){
        let order = deleteField.fields
        var message:String = order.customer + "\n"
        message.append(order.drinkName + "\n")
        message.append(order.drinkSize + "\n")
        message.append(order.drinkTemperature + "\n")
        message.append(order.drinkSugar + "\n")
        if let addWhiteTapioca = order.addWhiteTapioca {
            message.append(addWhiteTapioca + "\n")
        }
        if let addAgarPearl = order.addAgarPearl {
            message.append(addAgarPearl + "\n")
        }
        message.append("\(order.drinkCount)杯，共\(order.totalPrice)元")
        
        let alert = UIAlertController(title: "確認刪除此筆訂單？", message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteOrder([deleteField])
          }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(alert, animated: true, completion: nil)
    }
    
    //執行刪除Order
    func deleteOrder(_ fieldArr:[Field]){
        
        let urlString = "https://api.airtable.com/v0/app5ch3HNjdIRzUUp/kebuke"
        DAO.shared.deleteOrder(url:urlString, removes:fieldArr){
            result
            in
            switch result{
            case .success(let records):
                let alert = UIAlertController(title: "執行結果", message: "刪除成功", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default){_ in
                    //重新載入訂單
                    self.fetchOrders()
                }
                alert.addAction(alertAction)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                print("成功後回傳的response：\(records)")
            case .failure(let error):
                print("失敗回傳的response:\(error)")
            }
            
        }

    }
    
    // MARK: - Data
    var orderRecords:[OrderRecord] = [OrderRecord]()
    var totalCupCount = 0
    var totalPayPrice = 0
    func fetchOrders() {
        let urlStr = "https://api.airtable.com/v0/app5ch3HNjdIRzUUp/kebuke" + "?sort%5B0%5D%5Bfield%5D=customer&sort%5B0%5D%5Bdirection%5D=asc" + "&sort%5B1%5D%5Bfield%5D=orderTime&sort%5B1%5D%5Bdirection%5D=desc"
        if let url = URL(string: urlStr) {
        
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("Bearer patb1q4Gb5wLdwaRC.00f6550bf2189fe9eef459124964a3f87c688809342132436cd5d3f151ea96e0", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let orderGet = try decoder.decode(OrderGet.self, from: data)
                        print(orderGet)
                        self.orderRecords = orderGet.records
                        DispatchQueue.main.async {
                            self.OrderTableView.reloadData()
                            self.calculateTotal()
                            self.StillLoadingIndicator.stopAnimating()
                            self.StillLoadingIndicator.isHidden = true
                        }
                        
                    } catch {
                        print(error)
                    }
                } else {
                    print(error ?? "")
                }
            }.resume()
        }
    }
    
    //設定總數
    func calculateTotal(){
        for record in orderRecords {
            totalCupCount += record.fields.drinkCount
            totalPayPrice += record.fields.totalPrice
        }
        TotalCupCountLabel.text = String(totalCupCount)
        TotalPayPriceLabel.text = String(totalPayPrice)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
