//
//  RemoteDataSource.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import Foundation
import FirebaseCore
import FirebaseFirestore

protocol RemoteDataSourceProtocol {
    func fetchProductsFromAPI() async throws -> [Item2]
}

class RemoteDataSource: RemoteDataSourceProtocol {
    private let db = Firestore.firestore()
    
    private let apiURL = URL(string: "https://www.amiiboapi.com/api/amiibo/")
    
    func fetchProductsFromAPI() async throws -> [Item2] {
        //try await addProducts()
        var items: [Item2] = []
        do {
            let snapshot = try await db.collection("products").getDocuments()
            items = try snapshot.documents.compactMap { document in
                try document.data(as: Item2.self)
            }
            print("Successfully fetched \(items.count) items.")
            return items
        } catch {
            print("Error getting documents or decoding: \(error)")
            throw error
        }
        //return itemsDummy
    }
    
    func addProducts() async throws {
        do {
          let ref = try await db.collection("products").addDocument(data: [
            "name": "Bacachat",
            "image": "image234",
            "price": 1834
          ])
          print("Document added with ID: \(ref.documentID)")
        } catch {
          print("Error adding document: \(error)")
        }
    }
    
    let itemsDummy = [Item2(id: "XXX", name: "Bacardi", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fbac2.png?alt=media&token=ab0ca2df-054c-4964-bfba-5851cc0ed37e", price: 500, category: "drinks"),
                  Item2(id: "XXXX", name: "Tequila", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fcabrito.png?alt=media&token=20386854-b7e1-4c63-8137-85aa13cf2e46", price: 400, category: "drinks"),
                  Item2(id: "XXXX", name: "Tequila", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fcabrito.png?alt=media&token=20386854-b7e1-4c63-8137-85aa13cf2e46", price: 300, category: "drinks"),
                  Item2(id: "XXXX", name: "Tequila", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fcabrito.png?alt=media&token=20386854-b7e1-4c63-8137-85aa13cf2e46", price: 200, category: "drinks"),
                  Item2(id: "XXXX", name: "Tequila", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fcabrito.png?alt=media&token=20386854-b7e1-4c63-8137-85aa13cf2e46", price: 100, category: "drinks"),
                  Item2(id: "XXXXX", name: "Tequila2", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fcabrito.png?alt=media&token=20386854-b7e1-4c63-8137-85aa13cf2e46", price: 200, category: "other"),
                  Item2(id: "XXXXXX", name: "Ice Bag", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fhielo2.png?alt=media&token=6db77f4f-fa5e-44fc-be6f-f754fa546cc4", price: 300, category: "other"),
                  Item2(id: "XXXXXXX", name: "Ice Bag", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fhielo2.png?alt=media&token=6db77f4f-fa5e-44fc-be6f-f754fa546cc4", price: 400, category: "other"),
                  Item2(id: "XXXXXXX", name: "Ice Bag", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fhielo2.png?alt=media&token=6db77f4f-fa5e-44fc-be6f-f754fa546cc4", price: 500, category: "other"),
                  Item2(id: "XXXXXXX", name: "Ice Bag", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fhielo2.png?alt=media&token=6db77f4f-fa5e-44fc-be6f-f754fa546cc4", price: 400, category: "food"),
                  Item2(id: "XXXXXXX", name: "Ice Bag", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fhielo2.png?alt=media&token=6db77f4f-fa5e-44fc-be6f-f754fa546cc4", price: 400, category: "food"),
                  Item2(id: "XXXXXXX", name: "Ice Bag", image: "https://firebasestorage.googleapis.com/v0/b/reyes-del-after-chiibalil.appspot.com/o/Assets%2Fhielo2.png?alt=media&token=6db77f4f-fa5e-44fc-be6f-f754fa546cc4", price: 400, category: "food")
    ]
}
