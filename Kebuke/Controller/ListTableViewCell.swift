//
//  ListTableViewCell.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/18.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DrinkImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var BriefLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DrinkImageView.layer.borderColor = BackgroundColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(_ menu:Menu){
        NameLabel.text = menu.name
        BriefLabel.text = menu.brief
        var count = 0
        var priceString = ""
        for price in menu.price {
            if count > 0 {
                priceString.append(" / ")
            }
            priceString.append("\(price.size) \(price.price)")
            count += 1
        }
        PriceLabel.text = priceString
        updateImage(menu)
    }
    
    func updateImage(_ menu:Menu){
        let urlStr = IMAGE_URL + "kebuke-\(menu.name).jpg"
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
