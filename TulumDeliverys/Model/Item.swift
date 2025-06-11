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
    var id : String
    var timestamp: Date
    var name : String
    var isFavorite : Bool
    var image: String

    init(timestamp: Date, name:String, image:String) {
        id = UUID().uuidString
        self.timestamp = timestamp
        self.name = name
        self.image = image
        isFavorite = false
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

