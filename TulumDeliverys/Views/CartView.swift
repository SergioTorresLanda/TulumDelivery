//
//  CartView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import Foundation
import SwiftUI
import SwiftData

struct CartView: View {
    @State var viewmodel: MyViewModel
    @State var showingDetail = false

    var body: some View {
        List{
            ForEach(viewmodel.selected, id: \.id) { item in
                ProductView(product: item,
                         viewmodel: viewmodel,
                         isInFavoritesList: true
                )
                .onTapGesture {
                    showingDetail.toggle()
                }.sheet(isPresented: $showingDetail) {
                   // CardD(card: card)
                }
            }
            .onDelete { indexSet in
                viewmodel.deleteFavoriteFromIndex(at: indexSet)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle("Carrito:  \(viewmodel.selected.count)")
        .navigationBarTitleDisplayMode(.large)
        .task {
        }
        .onAppear{
        }
        .onDisappear{
        }
    }
}

