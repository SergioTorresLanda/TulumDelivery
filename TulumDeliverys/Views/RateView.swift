//
//  RateView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//

import Foundation
import SwiftUI
import SwiftData

struct RateView: View {
    @EnvironmentObject var vm: MyViewModel
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.rateScreenComponents) { wrapper in
                    // Ask the Factory to build the specific view
                    ViewFactory.view(for: wrapper.component) { actionID in
                        // Handle Actions (The "Backend-Driven Navigation")
                        handleServerAction(actionID)
                    }
                }
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Label("Back", systemImage: "arrowshape.turn.up.left.fill")
                    }.tint(Color.yellow)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        coordinator.popToRoot()
                    } label: {
                        HStack{
                            Image(systemName: "arrowshape.turn.up.right.fill").frame(width: 50, height: 50, alignment: .trailing).foregroundColor(Color.yellow).aspectRatio(contentMode: .fill)
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.fetchRateScreen()
        }
    }
    
    private func handleServerAction(_ actionID: String) {
        print("Server triggered action: \(actionID)")
        
        switch actionID {
        case "open_map":
            coordinator.push(.map)
        case "open_cart":
            coordinator.push(.cart)
        default:
            print("Unknown action ID: \(actionID)")
        }
    }
    
}
