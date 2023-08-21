//
//  OrderTableViewCell.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var DrinkName: UILabel!
    @IBOutlet weak var DrinkSize: UILabel!
    @IBOutlet weak var DrinkTemperature: UILabel!
    @IBOutlet weak var DrinkSugar: UILabel!
    @IBOutlet weak var AddOnLabel: UILabel!
    @IBOutlet weak var Customer: UILabel!
    @IBOutlet weak var OrderTime: UILabel!
    @IBOutlet weak var TotalPrice: UILabel!
    @IBOutlet weak var CupCount: UILabel!
    
    @IBOutlet weak var DrinkImageView: UIImageView!
    @IBOutlet weak var DeleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(_ order:Order){
        DrinkName.text = order.drinkName
        DrinkSize.text = order.drinkSize
        DrinkTemperature.text = order.drinkTemperature
        DrinkSugar.text = order.drinkSugar
        var addOnStr:String = ""
        if let addWhiteTapioca = order.addWhiteTapioca {
            addOnStr.append(addWhiteTapioca)
        }
        if let addAgarPearl = order.addAgarPearl {
            if !addOnStr.isEmpty {
                addOnStr.append("、")
            }
            addOnStr.append(addAgarPearl)
        }
        AddOnLabel.text = addOnStr
        Customer.text = order.customer
        TotalPrice.text = "＄\(order.totalPrice)"
        CupCount.text = "x \(order.drinkCount)"
        OrderTime.text = order.orderTime
        updateImage(order)
    }
    
    func updateImage(_ order:Order){
        let urlStr = IMAGE_URL + "kebuke-\(order.drinkName).jpg"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url ) { data, response , error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.DrinkImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }else{
            self.DrinkImageView.image = UIImage(named: "DefaultImage")
        }
    }
    
    
    
}
