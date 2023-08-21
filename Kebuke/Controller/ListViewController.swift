//
//  ListViewController.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/18.
//

import UIKit

var menuDic = [String:[Menu]]() //["人氣精選":[Menu],"經典":[Menu]]
var menus = [Menu]()

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var indexDM = 0
    let DMArr = [
      UIImage(named:"kebuke-dm-1")!,
      UIImage(named:"kebuke-dm-2")!,
      UIImage(named:"kebuke-dm-3")!,
      UIImage(named:"kebuke-dm-4")!,
      UIImage(named:"kebuke-dm-5")!
    ]
    
    //DM
    @IBOutlet weak var DMImageView: UIImageView!
    @IBOutlet weak var DMPageControl: UIPageControl!
    
    //Category
    @IBOutlet weak var CategoryScrollView: UIScrollView!
    @IBOutlet var CategoryView: [UIView]!
    @IBOutlet var CategoryButton: [UIButton]!
    
    //Menu
    @IBOutlet weak var MenuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MenuTableView.delegate = self
        self.MenuTableView.dataSource = self
        
        fetchMenus()
        
        DMPageControl.numberOfPages = DMArr.count
        autoPlayDM()
       
        
    }
    
    // MARK: - DM
    //上一筆
    @IBAction func preDM(_ sender: Any) {
        indexDM = (indexDM - 1 + DMArr.count) % DMArr.count
        switchDM()
    }
    //下一筆
    @IBAction func nextDM(_ sender: Any) {
        indexDM = (indexDM + 1) % DMArr.count
        switchDM()
    }
    //點選page control
    @IBAction func selectDM(_ sender: Any) {
        indexDM = DMPageControl.currentPage
        switchDM()
    }
    //變更DM
    func switchDM(){
        DMImageView.image = DMArr[indexDM]
        DMPageControl.currentPage = indexDM
    }
    //自動輪播DM
    func autoPlayDM(){
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.indexDM = (self.indexDM + 1) % self.DMArr.count
            self.switchDM()
        }
    }
    
    // MARK: - Category
    @IBAction func selectCategory(_ sender: UIButton) {
        changeCategoryButtonColor(sender.tag % 60)
        let indexPath = IndexPath(row:0 , section: sender.tag % 60)
        MenuTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func changeCategoryButtonColor(_ index:Int){
        for view in CategoryView {
            if view.tag % 50 == index {
                view.backgroundColor = UIColor.systemYellow
            }else{
                view.backgroundColor = UIColor.white
            }
        }
        for button in CategoryButton {
            if button.tag % 60 == index {
                button.tintColor = SelectedColor
            }else{
                button.tintColor = UIColor.white
            }
        }
    }
    
    // MARK: - TableView
    //Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return Category.allCases.count
    }
    //Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDic[Category.allCases[section].rawValue]?.count ?? 0
    }
    //Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ListTableViewCell.self)", for: indexPath) as? ListTableViewCell else {
            fatalError("dequeueReusableCell LoverTableViewCellfailed")
        }
        let menu = getMenuByCategory(categoryIndex: indexPath.section, menuIndex: indexPath.row)
        cell.update(menu)
        return cell
    }
    
    //Section - Title
    /**
     參考學長Jeff Lin 作品：
     https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/21-%E9%B6%B4%E8%8C%B6%E6%A8%93app-part1-%E5%8A%9F%E8%83%BD%E4%BB%8B%E7%B4%B9-b3e2cb999f71
     */
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        //view.backgroundColor = UIColor(named: "Color3")
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: tableView.rowHeight/3))
        let title = Category.allCases[section].rawValue
        let font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        let attribute:[NSAttributedString.Key:Any] = [.foregroundColor:SelectedColor,.font:font]
        let attrubutedText = NSAttributedString(string: title, attributes: attribute)
        label.attributedText = attrubutedText
        view.addSubview(label)
        return view
    }
    //設定Section的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.rowHeight/3
    }
    
    
    // MARK: - Actions
    //點選DM
    @IBSegueAction func showDMDetail(_ coder: NSCoder) -> DetailViewController? {
        var name = "芒果波登"
        if indexDM == 1 || indexDM == 4 {
            name = "麥雪歐蕾"
        }
        let drink = Drink(name: name, size: "", temperature: -1, sugar: -1, selectedSizePrice: 0, addWhiteTapiocaPrice: 0, addAgarPearlPrice: 0, cupCount: 1, unitPrice: 0, total: 0)
        return DetailViewController(coder: coder, drink: drink)
    }
    //點選List
    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailViewController? {
        //點選第幾個section,第幾個row
        if let sectionIndex = MenuTableView.indexPathForSelectedRow?.section,
           let row = MenuTableView.indexPathForSelectedRow?.row {
            
            let menu = getMenuByCategory(categoryIndex: sectionIndex, menuIndex: row)
            
            let drink = Drink(name: menu.name, size: "", temperature: -1, sugar: -1, selectedSizePrice: 0, addWhiteTapiocaPrice: 0, addAgarPearlPrice: 0, cupCount: 1, unitPrice: 0, total: 0)
            return DetailViewController(coder: coder, drink: drink)
            
        } else {
            return nil
        }
    }
    
    //從Detail返回
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    // MARK: - Data
    func fetchMenus() {
        let urlStr = "https://raw.githubusercontent.com/amazingwiplala/demodata/main/Menu.json"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let resultMenu = try decoder.decode(ResultMenu.self, from: data)
                        menus = resultMenu.items
                        DispatchQueue.main.async {
                            self.classify()
                            self.MenuTableView.reloadData()
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
    //飲品分類
    func classify(){
        //宣告類別的鎮列
        for category in Category.allCases {
            menuDic.updateValue([Menu](), forKey: category.rawValue)
        }
        //將飲料加入分類section
        for menu in menus {
            addToCategory(menu)
        }
    }
    //加入section
    func addToCategory(_ menu:Menu){
        for category in  menu.category {
            menuDic[category]?.append(menu)
        }
    }
    //get menu from menuDic by category + index
    func getMenuByCategory(categoryIndex:Int, menuIndex:Int) -> Menu{
        let categoryName = Category.allCases[categoryIndex].rawValue
        return menuDic[categoryName]![menuIndex]
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

//MARK: - 上下捲動Table View
extension ListViewController:UIScrollViewDelegate{

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("scrollViewDidScroll")
        let visibleRowsIndexpath = MenuTableView.indexPathsForVisibleRows
        let visibleSections = visibleRowsIndexpath!.map({$0.section})
        let visibleRows = visibleRowsIndexpath!.map({$0.row})
        
        //print("visibleRowsIndexpath:\(visibleRowsIndexpath!)")
        //print("mapSections:\(mapSections)")
        //print("mapRows:\(mapRows)")
        //print("mapSections.count:\(mapSections.count)")
        //print("Set(mapSections).count:\(Set(mapSections).count)")
        
        if Set(visibleSections).count == 1 || visibleRows[0] == 0 {
            changeCategoryButtonColor(visibleSections[0])
            scrollToCategoryButton(visibleSections[0])
        }
    }
    
    //連動 - 橫向捲動category按鈕
    func scrollToCategoryButton(_ index:Int){
        let maxX:CGFloat = CategoryScrollView.contentSize.width - CategoryScrollView.frame.width
        var x:CGFloat = CGFloat(index * 100)
        if x > maxX {
            x = maxX
        }else if x < CategoryScrollView.frame.width {
            x = CGFloat(index * 60)
        }
        CategoryScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

}

/* 改用page control
//DM
func displayDM(){
    
    // 建立一個陣列 用來放置要輪播的圖片
    let imgArr = [
      UIImage(named:"kebuke-dm-1")!,
      UIImage(named:"kebuke-dm-2")!,
      UIImage(named:"kebuke-dm-3")!,
      UIImage(named:"kebuke-dm-4")!,
      UIImage(named:"kebuke-dm-5")!
    ]
    // 設置要輪播的圖片陣列
    DMImageView.animationImages = imgArr

    // 輪播一次的總秒數
    DMImageView.animationDuration = 20

    // 要輪播幾次 (設置 0 則為無限次)
    DMImageView.animationRepeatCount = 0
    
    // 開始輪播
    DMImageView.startAnimating()
    
}
*/
