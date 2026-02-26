//
//  ViewFactory.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//

import SwiftUI
import Foundation

struct ViewFactory {
    @ViewBuilder
        static func build(route: AppRoute, coordinator: AppCoordinator, container: AppDependencyContainer) -> some View {
            switch route {
            case .cart:
                CartView()
                    .navigationBarBackButtonHidden(true)
                  //  .toolbar(.hidden, for: .navigationBar)
            case .map:
                MapView()
                    .navigationBarBackButtonHidden(true)
            case .rate:
                RateView() ///NEW VIEW FOR SERVER DRIVER COMPONENTS
                    .navigationBarBackButtonHidden(true)
            case .productDetails(let id):
                Text("Product Details for \(id)")
            case .sduiScreen(let id):
                 // Re-use your SDUI logic from earlier!
                 ServerDrivenScreen(title: "Dynamic", components: [], onAction: { _ in })
            }
        }
    // The Factory Method
    // Takes a type-erased model and returns a concrete View
    @ViewBuilder
    static func view(for model: any ServerComponent, actionHandler: @escaping (String) -> Void) -> some View {
        switch model {
        case let hero as HeroCardModel:
            HeroCardView(model: hero) {
                // Pass the action ID back to the Coordinator
                if let actionID = hero.actionID {
                    actionHandler(actionID)
                }
            }
        
        case let transaction as TransactionRowModel:
            TransactionRowView(model: transaction)
            
        case is UnknownModel:
            // Crucial: Handle unknown types by returning an EmptyView
            // so the layout doesn't break.
            EmptyView()
            
        default:
            EmptyView()
        }
    }
}
