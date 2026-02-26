//
//  DashboardCoordinator.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//
/*
class DashboardCoordinator {
    
    func start() -> UIViewController {
        // 1. Fetch JSON (Mocked here)
        let response = fetchFromBackend()
        
        // 2. Create the SwiftUI View
        let sduiView = ServerDrivenScreen(
            title: response.screenTitle,
            components: response.components,
            onAction: { [weak self] actionID in
                // 3. Handle Navigation NATIVELY
                self?.handleNavigation(actionID: actionID)
            }
        )
        
        // 4. Wrap in UIHostingController (The Bridge to UIKit)
        return UIHostingController(rootView: sduiView)
    }
    
    private func handleNavigation(actionID: String) {
        if actionID == "cash_out_flow" {
            print("Coordinator: Pushing Cash Out Screen natively!")
            // navigationController.pushViewController(...)
        }
    }
}
*/
