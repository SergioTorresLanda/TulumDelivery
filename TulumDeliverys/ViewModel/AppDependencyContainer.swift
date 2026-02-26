//
//  AppDependencyContainer.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//

// AppDependencyContainer.swift
import SwiftData
import SwiftUI

@MainActor
class AppDependencyContainer: ObservableObject {
    // 1. The Database
    let modelContainer: ModelContainer
    // 2. The Shared ViewModel
    let sharedViewModel: MyViewModel
    init() {
        do {
            // Initialize SwiftData manually
            self.modelContainer = try ModelContainer(for: Item.self)
            // Build the Layered Dependency Graph
            let dataManager = DataManager(modelContainer: modelContainer)
            let remoteDS = RemoteDataSource()
            let repository = Repository(remoteDataSource: remoteDS, localDataSource: dataManager)
            // D. Instantiate the ViewModel once
            self.sharedViewModel = MyViewModel(repository: repository)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
}
