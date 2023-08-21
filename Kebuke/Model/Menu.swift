//
//  Drink.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/16.
//

import Foundation

struct ResultMenu:Codable {
    let store:String
    let items:[Menu]
}

//菜單
struct Menu:Codable {
    let name:String         //名稱
    let category:[String]   //類別
    let brief:String        //簡介
    let introduction:String //說明
    let tips:String?        //特色
    let reveal:[String]     //揭示
    let place:String?        //產地
    let price:[Price]       //容量+價格
    let addon:[Option]       //加料選項
    let temperature:[Option]//溫度選項
    let sugar:[Option]      //糖度選項
}
//容量+價格
struct Price:Codable {
    let size:String //中杯、大杯
    let price:Int
}
//選單
struct Option:Codable {
    let level:Int
    let valid:Bool
}




