//
//  Item.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

struct User {
    var userID:String
    var name:String
    var email:String
    var lat:Double
    var long:Double
}

struct Dish {
    var dishId:Int
    var restaurantId:String
    var name:String
    var price:Double
    var imageUrl:String
}

struct Basket {
    var basketID:Int
    var userID:Int
}

struct Order {
    var orderID : Int
    var status : String
    var basket: Basket
   // var curLoc: [curLat, curLong]
}

