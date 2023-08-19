//
//  DetailViewController.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/16.
//

import UIKit

let IMAGE_URL:String = "https://raw.githubusercontent.com/amazingwiplala/demodata/main/"
let TIPS_STRING:String = "咖啡因每日攝取限量300mg，孩童及孕哺婦斟酌食用。 糖量、熱量及咖啡因含量皆以最高值標示。"
let BackgroundColor = UIColor(red: 23/255, green: 61/255, blue: 80/255, alpha: 1)
let SelectedColor = UIColor(red: 182/255, green: 151/255, blue: 100/255, alpha: 1)
let UnSelectedColor = UIColor.white

class DetailViewController: UIViewController {
    
    var cart: Cart
    
    init?(coder: NSCoder, cart: Cart) {
        self.cart = cart
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //var cartTest = Cart(name: "芒果波登", size: "L", temperature: 2, sugar: 3, selectedSizePrice: 75, addWhiteTapiocaPrice: 10, addAgarPearlPrice: 0, cupCount: 1, unitPrice: 85, total: 85)
    
    var item:Menu = Menu(name: "", category: [], brief: "", introduction: "", tips: "", reveal: [], place: "", price: [], addon: [], temperature: [], sugar: [])
    
    //飲料選擇
    var selectedSize:String = ""        //容量
    var selectedTemperature:Int = -1    //溫度
    var selectedSugar:Int = -1          //甜度
    var cupCount:Int = 1                //杯數
    
    //飲料價格
    var selectedSizePrice:Int = 0
    var addWhiteTapiocaPrice:Int = 0    //加料白玉價格
    var addAgarPearlPrice:Int = 0       //加料水玉價格
    
    //簡介
    @IBOutlet weak var DrinkImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var BriefLabel: UILabel!
    @IBOutlet weak var IntroductionLabel: UILabel!
    @IBOutlet weak var TipsLabel: UILabel!
    
    //容量
    @IBOutlet weak var SizeMButton: UIButton!
    @IBOutlet weak var SizeLButton: UIButton!
    @IBOutlet weak var SizeMLabel: UILabel!
    @IBOutlet weak var SizeLLabel: UILabel!
    
    //加料
    @IBOutlet var AddOnSwitch: [UISwitch]!
    @IBOutlet var AddOnLabel: [UILabel]!
    @IBOutlet var AddOnPriceLabel: [UILabel]!
    
    //溫度 20~29
    @IBOutlet var TemperatureButton: [UIButton]!
    
    //甜度 30~36
    @IBOutlet var SugarButton: [UIButton]!
    
    //杯數
    @IBOutlet weak var CupLabel: UILabel!
    @IBOutlet weak var CupSwitch: UIStepper!
    
    //加入購物車
    @IBOutlet weak var addToCart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAll()
        
        
    }
    
    func initAll(){
        print(cart.name)
        searchMenuByName(cart.name)
    
        initImage()
        initNavigationBar()
        initMenu()
        
        initSelect()
    }
    
    
    // MARK: - Actions
    //容量 - Ｍ
    @IBAction func selectSizeM(_ sender: UIButton) {
        //設定按鈕
        SizeMButton.configuration?.background.backgroundColor = SelectedColor
        SizeLButton.configuration?.background.backgroundColor = UnSelectedColor
        
        //設定容量
        selectedSize = "M"
        
        //設定價格
        if let priceString = SizeMLabel.text?.replacingOccurrences(of: "$", with: "") {
            selectedSizePrice = Int( priceString ) ?? 0
        }
        updateOrder()
    }
    
    //容量 - Ｌ
    @IBAction func selectSizeL(_ sender: UIButton) {
        //設定按鈕
        SizeMButton.configuration?.background.backgroundColor = UnSelectedColor
        SizeLButton.configuration?.background.backgroundColor = SelectedColor
        
        //設定容量
        selectedSize = "L"
        
        //設定價格
        if let priceString = SizeLLabel.text?.replacingOccurrences(of: "$", with: "") {
            selectedSizePrice = Int( priceString ) ?? 0
        }
        updateOrder()
    }
    
    //溫度
    @IBAction func selectTemperature(_ sender: UIButton) {
        for button in TemperatureButton {
            let index = button.tag % 20
            if button==sender {
                //設定溫度
                selectedTemperature = index
                button.configuration?.background.backgroundColor = SelectedColor
            }else{
                button.configuration?.background.backgroundColor = UnSelectedColor
            }
        }
    }
    //甜度
    @IBAction func selectSugar(_ sender: UIButton) {
        for button in SugarButton {
            let index = button.tag % 30
            if button==sender {
                //設定甜度
                selectedSugar = index
                button.configuration?.background.backgroundColor = SelectedColor
            }else{
                button.configuration?.background.backgroundColor = UnSelectedColor
            }
        }
    }
    //加料 - 白玉
    @IBAction func addWhiteTapioca(_ sender: UISwitch) {
        if sender.isOn {
            addWhiteTapiocaPrice = 10
        }else{
            addWhiteTapiocaPrice = 0
        }
        updateOrder()
    }
    //加料 - 水玉
    @IBAction func addAgarPearl(_ sender: UISwitch) {
        if sender.isOn {
            addAgarPearlPrice = 10
        }else{
            addAgarPearlPrice = 0
        }
        updateOrder()
    }
    
    //杯數
    @IBAction func selectCupCount(_ sender: UIStepper) {
        cupCount = Int(sender.value)
        CupLabel.text = "\(cupCount)杯"
        updateOrder()
    }
    
    //加入購物車
    @IBAction func addToCart(_ sender: Any) {
        //容量
        if selectedSize == "" {
            validAlert("請問您要中杯還是大杯？")
            return
        }
        //溫度
        if selectedTemperature == -1 {
            validAlert("請選擇飲料的溫度！")
            return
        }
        //甜度
        if selectedSugar == -1 {
            validAlert("請選擇甜度！")
            return
        }
        //杯數
        if cupCount == 0 {
            validAlert("請至少點一杯喔！")
            return
        }
    }
    
    
    // MARK: - Functions
    
    //更新訂單
    func updateOrder(){
        
        //加入購物車
        let total = cupCount * ( selectedSizePrice + addWhiteTapiocaPrice + addAgarPearlPrice )
        let buttonText:String = "新增\(cupCount)杯。共\(total)元"
        let attrFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        let attrTitle = NSAttributedString(string: buttonText, attributes: [NSAttributedString.Key.font: attrFont])
        addToCart.setAttributedTitle(attrTitle, for: UIControl.State.normal)
        
        print(buttonText)
        
        //飲料選擇
        print("selectedSize=\(selectedSize)")           //容量
        print("selectedTemperature=\(selectedTemperature)")    //溫度
        print("selectedSugar=\(selectedSugar)")        //甜度
        print("cupCount=\(cupCount)")              //杯數
        
        //飲料價格
        print("selectedSizePrice=\(selectedSizePrice)")
        print("addWhiteTapiocaPrice=\(addWhiteTapiocaPrice)")    //加料白玉價格
        print("addAgarPearlPrice=\(addAgarPearlPrice)")      //加料水玉價格
        
        print("=====================")
        
    }
    
    // MARK: - Data
    
    //頁首-初始化
    func initNavigationBar(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 182/255, green: 151/255, blue: 100/255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        let image = UIImage(systemName: "xmark.circle")
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
    }
    
    //飲料資訊-初始化
    func initMenu(){
        
        //簡介
        navigationItem.title = item.name
        NameLabel.text = item.name
        BriefLabel.text = item.brief
        IntroductionLabel.text = item.introduction
        for reveal in item.reveal {
            IntroductionLabel.text?.append(reveal)
        }
        if let tip = item.tips {
            TipsLabel.text = item.tips
        }else{
            TipsLabel.text = TIPS_STRING
        }
        
        //容量
        SizeMButton.configuration?.background.backgroundColor = UnSelectedColor
        SizeLButton.configuration?.background.backgroundColor = UnSelectedColor
        SizeMButton.isEnabled = false
        SizeLButton.isEnabled = false
        SizeMLabel.text = "$0"
        SizeLLabel.text = "$0"
        for price in item.price {
            //中杯
            if price.size == "M" {
                SizeMButton.isEnabled = true
                SizeMLabel.text = "$" + String(price.price)
            }
            //大杯
            if price.size == "L" {
                SizeLButton.isEnabled = true
                SizeLLabel.text = "$" + String(price.price)
            }
        }
        
        //加料
        for option in item.addon {
            AddOnSwitch[option.level].isOn = false
            AddOnSwitch[option.level].isEnabled = option.valid
        }
        
        //溫度
        for option in item.temperature {
            TemperatureButton[option.level].isEnabled = option.valid
            TemperatureButton[option.level].configuration?.background.backgroundColor = UnSelectedColor
        }
        
        //甜度
        var hidden6:Bool
        var hidden1:Bool
        if item.sugar[6].valid && !item.sugar[1].valid {
            hidden6 = false
            hidden1 = true
        }else{
            hidden6 = true
            hidden1 = false
        }
        for button in SugarButton {
            button.configuration?.background.backgroundColor = UnSelectedColor
            button.isEnabled = item.sugar[button.tag % 30].valid
            if button.tag == 36 {       //減糖
                button.isHidden = hidden6
            }else if button.tag == 31 { //少糖
                button.isHidden = hidden1
            }
        }
        
        //加入購物車
        addToCart.titleLabel?.text = "新增\(cupCount)杯。共0元"
        
        //飲料選擇
        selectedSize = ""           //容量
        selectedTemperature = -1    //溫度
        selectedSugar = -1          //甜度
        cupCount = 1                //杯數
        
        //飲料價格
        selectedSizePrice = 0
        addWhiteTapiocaPrice = 0    //加料白玉價格
        addAgarPearlPrice = 0       //加料水玉價格
    }
    
    //飲料相片-初始化
    func initImage(){
        let urlStr = IMAGE_URL + "kebuke-\(item.name).jpg"
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
    //飲料選擇-初始化
    func initSelect(){
        //容量
        if cart.size == "M" {
            SizeMButton.configuration?.background.backgroundColor = SelectedColor
        }else if cart.size == "L" {
            SizeLButton.configuration?.background.backgroundColor = SelectedColor
        }
        //加料-白玉
        if cart.addWhiteTapiocaPrice > 0 {
            AddOnSwitch[0].isOn = true
        }
        //加料-水玉
        if cart.addAgarPearlPrice > 0 {
            AddOnSwitch[1].isOn = true
        }
        //溫度
        for button in TemperatureButton {
            if button.tag % 20 == cart.temperature {
                button.configuration?.background.backgroundColor = SelectedColor
            }
        }
        //甜度
        for button in SugarButton {
            if button.tag % 20 == cart.sugar {
                button.configuration?.background.backgroundColor = SelectedColor
            }
        }
        //飲料選擇
        selectedSize = cart.size           //容量
        selectedTemperature = cart.temperature   //溫度
        selectedSugar = cart.sugar         //甜度
        cupCount = cart.cupCount                //杯數
        
        //飲料價格
        selectedSizePrice = cart.selectedSizePrice
        addWhiteTapiocaPrice = cart.addWhiteTapiocaPrice    //加料白玉價格
        addAgarPearlPrice = cart.addAgarPearlPrice       //加料水玉價格
        
        updateOrder()
    }
    
    //搜尋菜單
    func searchMenuByName(_ name:String) {
        for m in menus {
            if m.name==name {
                item = m
                break
            }
        }
    }
    
    //訊息 - 輸入驗證
    func validAlert(_ title:String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
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
