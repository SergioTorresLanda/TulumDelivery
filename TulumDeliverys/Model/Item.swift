//
//  Item.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//

import Foundation
import SwiftData
import FirebaseFirestore
//import FirebaseFirestoreSwift

@Model
final class Item {
    var id : String
    //var timestamp: Date
    var name : String
    var isFavorite : Bool
    var image: String
    var price: Int
    var category:String
    var selectedItems:Int

    init(id:String, name:String, image:String, price:Int, category:String) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        isFavorite = false
        selectedItems=0
    }
}

struct Item2: Codable, Identifiable { // Identifiable es bueno para SwiftUI
    @DocumentID var id: String? // Mapea automáticamente el ID del documento
    var name: String
    var image: String
    var price: Int
    var category:String
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

