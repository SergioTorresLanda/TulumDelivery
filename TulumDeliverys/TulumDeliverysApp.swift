//
//  TulumDeliverysApp.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

/*class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}*/

@main
struct TulumDeliverysApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init(){
        FirebaseApp.configure()
    }
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var container = AppDependencyContainer()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                ContentView()
                    .navigationDestination(for: AppRoute.self) { route in
                        ViewFactory.build(route: route, coordinator: coordinator, container: container)
                    }
            }
            .modelContainer(container.modelContainer) // For @Query inside views
            .environmentObject(container.sharedViewModel)
            .environmentObject(coordinator)
        }
    }
}


/*  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Item.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
 .modelContainer(sharedModelContainer)
 */
