//
//  Cart.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/19.
//

import Foundation

//購物車
struct Cart {
    let name:String             //品項
    let size:String             //容量
    let temperature:Int         //溫度
    let sugar:Int               //甜度
    let selectedSizePrice:Int   //飲料錢
    let addWhiteTapiocaPrice:Int//加白玉錢
    let addAgarPearlPrice:Int   //加水玉錢
    let cupCount:Int    //杯數
    let unitPrice:Int   //單價
    let total:Int       //小計
}

