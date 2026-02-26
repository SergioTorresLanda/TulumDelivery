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

//@Observable
@MainActor
final class MyViewModel: ObservableObject {
    private let db = Firestore.firestore()
    private let repository: ProductRepositoryProtocol
    @Published var rateScreenComponents: [SDUIComponentWrapper] = []
    @Published var products: [Item] = []
    @Published var categorys: Set<String> = []
    @Published var pretotal:Int = 0
    @Published var totalItems = 0
    @Published var deliveryId = ""
    @Published private(set) var isLoading = false
    @Published var image: UIImage?
    private let cache = ImageDownloader()
    private(set) var deleteAll = false
    private(set) var isDelivery = false
    private(set) var timeLeft = 20

    init(repository:ProductRepositoryProtocol) {
         self.repository = repository
     }
    
    func fetchRateScreen() {

        let jsonString = """
        {
          "screenTitle": "Dashboard",
          "components": [
            {
              "type": "hero_card",
              "data": {
                "title": "Your Salary is Ready",
                "amount": "$1,250.00",
                "action_id": "cash_out_flow"
              }
            },
            {
              "type": "transaction_row",
              "data": {
                "merchant": "Uber Eats",
                "date": "2024-02-20",
                "amount": "-$24.50"
              }
            },
            {
              "type": "unknown_component",
              "data": { "foo": "bar" }
            }
          ]
        }
        """
        //Convert to Data
        guard let data = jsonString.data(using: .utf8) else { return }
        
        do {
            //Decode the Whole Response
            let response = try JSONDecoder().decode(ScreenResponse.self, from: data)
            
            //Assign to Published Property (Main Thread)
            DispatchQueue.main.async {
                self.rateScreenComponents = response.components
                // self.screenTitle = response.screenTitle
            }
            print("✅ Successfully decoded \(response.components.count) components")
            
        } catch {
            print("❌ Decoding failed: \(error)")
        }
    }
    
    func confirmDelivery(){
        //TODO: add to DB confirmation
        timeLeft=20
        isDelivery=false
    }
    func cancelDelivery(){
        //TODO: add to DB cancelation
        timeLeft=20
        isDelivery=false
    }
    
    func setDelivery(){
        isDelivery=true
        count()
    }
    
    func count(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
            self.timeLeft-=1
            self.timeLeft > 0 ? self.count() : ()
        }
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
        // 1. Jump to Background Actor
        let (newItems, newCategories) = try await repository.fetchAndProcess()
        // 2. Back on Main Thread
        // Update UI instantly with pre-processed data
        self.products = newItems
        self.categorys = newCategories
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
    
    func loadImage(url: URL) {
        Task {
            print("Requesting image...")
            defer{isLoading=false}
            // 2. AWAIT: We pause here and send the job to the Background Actor.
            // The Main Thread is now FREE to handle user touches while we wait.
            let downloadedImage = await cache.fetchAndResize(url: url)
            // 3. We are back on the Main Thread automatically!
            self.image = downloadedImage
        }
    }

    func fetchMoreData() async throws {
        isLoading = true
       // defer { isLoading = false }
        // 1. "async let" starts the tasks IMMEDIATELY in the background.
        // They are now running in parallel on available threads.
       // async let photosTask = repository.fetchPhotos()
       // async let videosTask = repository.fetchVideos()
        
        // ... You could do other work here while they download ...
        // 2. The Suspension Point
        // We pause here until BOTH tasks are finished.
        // If either one throws an error, the other is automatically cancelled (Structured Concurrency).
     //   let (newPhotos, newVideos) = try await (photosTask, videosTask)
        
        // 3. Atomic Update
        // We only update the UI state once both have succeeded.
       // self.photos = newPhotos
        //self.videos = newVideos
    }
    
    func fetchImagesSafely(urls: [URL]) async -> [UIImage] {
        
        // 1. Use a TaskGroup (Standard, not Throwing)
        // We handle errors INSIDE, so the group itself never fails.
        return await withTaskGroup(of: UIImage?.self) { group in
            
            var images: [UIImage] = []
            images.reserveCapacity(urls.count)
            
            for url in urls {
                group.addTask {
                    // 2. The Safety Net (do-catch inside the task)
                    // If this specific download fails, we catch it locally
                    // and return nil, allowing the group to continue.
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        return UIImage(data: data)
                    } catch {
                        print("⚠️ Failed to load \(url): \(error)")
                        return nil
                    }
                }
            }
            
            // 3. Filter out failures
            // The loop quietly ignores the nils and collects the successes.
            for await result in group {
                if let validImage = result {
                    images.append(validImage)
                }
            }
            
            return images
        }
    }
}
