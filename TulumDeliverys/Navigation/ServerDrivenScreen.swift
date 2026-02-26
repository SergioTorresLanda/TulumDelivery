//
//  ServerDrivenScreen.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
import SwiftUI

struct ServerDrivenScreen: View {
    let title: String
    let components: [SDUIComponentWrapper]
    
    // The closure that talks to the native Coordinator
    let onAction: (String) -> Void
    
    var body: some View {
        List {
            ForEach(components) { wrapper in
                // Ask the Factory to build the view for this specific data model
                ViewFactory.view(for: wrapper.component, actionHandler: onAction)
                    // Hide the list row separators for a cleaner UI
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .navigationTitle(title)
    }
}
