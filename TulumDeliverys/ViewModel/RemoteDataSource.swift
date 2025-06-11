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
        try await addProducts()
        var items: [Item2] = []
        do {
            let snapshot = try await db.collection("products").getDocuments()
            items = try snapshot.documents.compactMap { document in
                try document.data(as: Item2.self)
            }
            print("Successfully fetched \(items.count) items.")
            print("\(items[0].name)")
            print("\(items[0].image)")
            print("\(items[0].price)")
            return items
        } catch {
            print("Error getting documents or decoding: \(error)")
            throw error
        }
    
       // let itemsX = [Item(timestamp: Date(),name: "name", image: "https://raw.githubusercontent.com/N3evin/AmiiboAPI/master/images/icon_04380001-03000502.png")]
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
}
