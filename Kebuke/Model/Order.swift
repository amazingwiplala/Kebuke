//
//  Order.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/19.
//

import Foundation

//訂單
struct Order : Codable {
    
    let customer:String         //顧客名稱
    let drinkName:String        //飲料品名
    let drinkSize:String        //飲料容量 中/大
    let drinkTemperature:String //飲料溫度
    let drinkSugar:String       //飲料甜度
    let addWhiteTapioca:String?  //加白玉
    let addAgarPearl:String?     //加水玉
    let drinkCount:Int          //飲料杯數
    let drinkPrice:Int          //飲料價格
    let totalPrice:Int          //杯數*價格
    let orderTime:String        //訂購時間 yyyy-MM-dd HH:mm:ss
    
   /*
    let orderNumber:String
    let orderDate:Date
    let customer:String
    let drink:[Drink]
    let price:Int
   */
}

//POST/Patch資料時decode JSON的結構
struct OrderPost:Codable{
    let records:[Field]
}
struct Field:Codable{
    var id:String?
    var fields:Order
}

struct OrderGet:Codable{
    let records:[OrderRecord]
}
struct OrderRecord:Codable{
    let id:String
    let createdTime:String
    let fields:Order
}

//Patch資料後decode 回傳資料JSON的結構
struct Response:Codable{
    let records:[Info]
}
struct Info:Codable{
    let id:String
    let createdTime:String
}

//刪除資料時decode JSON的結構
struct Records:Codable{
    let records:[deleteResponse]
}

struct deleteResponse:Codable{
    let deleted:Bool
    let id:String
}

