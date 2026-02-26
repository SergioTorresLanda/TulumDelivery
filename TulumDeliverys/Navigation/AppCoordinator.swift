//
//  AppCoordinator.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//
// AppCoordinator.swift
import SwiftUI

//@Observable
class AppCoordinator: ObservableObject {
    // 1. The Source of Truth for the Navigation Stack
    @Published var path = NavigationPath()
    
    // 2. Navigation Actions
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
