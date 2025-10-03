//
//  Untitled.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//

import Foundation
import SwiftData
import SwiftUI
import FirebaseFirestore

@Observable
final class MyViewModel {
    private let db = Firestore.firestore()
    private let repository: ProductRepositoryProtocol
    var products: [Item] = []
    var categorys: Set<String> = []
    var pretotal:Int = 0
    var totalItems = 0
    var deliveryId = ""
    var rds = RemoteDataSource()
    private(set) var isLoading = false //propiedad para menejar el estado del ActivityIndicator (en la vista)
    private(set) var deleteAll = false
    //Se inyecta el contexto al inicializarse el viewmodel
    init(repository:ProductRepositoryProtocol) {
         self.repository = repository
     }
    
    func writeDeliveryOrder(total:String){
        var dictProds:[String:Any] = [:]
        for prod in products {
            if prod.isFavorite {
                dictProds[prod.name] = prod.selectedItems
            }
        }
        let dict:[String:Any] = ["usuario":UUID().uuidString,
                                 "timestampServer":FieldValue.serverTimestamp(),
                                 //"timestamp":ts,
                                 "productos":dictProds,
                                 "total":total]
        var ref: DocumentReference? = nil
        
        ref=db.collection("deliverys").addDocument(data: dict){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                //self.db.collection("usuarios").document(self.id!).collection("deliverys").document(ref!.documentID).setData(dict)
                print("Document added with ID: \(ref!.documentID)")
                self.deliveryId = ref!.documentID
            }
        }
    }
    
    func fetchData() async throws {
       isLoading = true
        categorys=[]
        products=[]
       defer { isLoading = false }
       try await fetchAndPersistProducts()
    }
    
    func fetchAndPersistProducts() async throws {
        categorys=[]
        products=[]
        let api = try await rds.fetchProductsFromAPI()
        var itemss: [Item] = []
        for prod in api {
            if prod.active ?? true {
                let item = Item(id: prod.id ?? UUID().uuidString,
                                name: prod.name ?? "--",
                                image: prod.image ?? "--",
                                price: prod.price ?? 0,
                                category: prod.category ?? "--",
                                active: prod.active ?? true
                )
                categorys.insert(prod.category ?? "ARTESANAL")
                itemss.append(item)
            }else{
                print(prod.name)
            }
        }
        products = itemss
    }
    
    func addFavorite(with p: Item){
        p.isFavorite = true
        p.selectedItems+=1
        pretotal += p.price
        totalItems += 1
    }

    func removeFavorite(with p: Item) {
        if p.selectedItems == 1 {
            p.isFavorite=false
        }
        p.selectedItems-=1
        pretotal -= p.price
        totalItems -= 1
    }
    
    func deleteAllSelected(){
        products.forEach { p in
            p.isFavorite = false
            p.selectedItems = 0
        }
        pretotal = 0
        totalItems = 0
        deleteAll = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.deleteAll = false
        }
    }
    
    func deleteFavoriteFromIndex(at offsets: IndexSet) {
       /* for index in offsets {
           // modelContext.delete(favs[index])
            if selected[index].selectedItems == 1 {
                favs[index].isFavorite=false
            }
            favs[index].selectedItems-=1
        }*/
    }

}
