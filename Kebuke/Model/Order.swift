//
//  Order.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/19.
//

import Foundation

//訂單
struct Order {
    let orderNumber:String
    let orderDate:Date
    let customer:String
    let cart:[Cart]
    let price:Int
}

