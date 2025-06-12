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
    @Environment(\.dismiss) var dismiss
    var pretotalPrice:String {
        return viewmodel.pretotal.formatted(.number.grouping(.automatic))
    }
    var deliveryCost:String {
        return (Double(viewmodel.pretotal)*0.2).formatted(.number.grouping(.automatic))
    }
    var total:String {
        return (Double(viewmodel.pretotal)*1.2).formatted(.number.grouping(.automatic))
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Step 2. Confirm your Cart items and your total bill.").font(.system(size: 20))
                List{
                    ForEach(viewmodel.selected, id: \.id) { item in
                        CartItemView(product: item,
                                     viewmodel: viewmodel
                        )
                    }
                    .onDelete { indexSet in
                        viewmodel.deleteFavoriteFromIndex(at: indexSet)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                // .navigationTitle("Step 2. Confirm your Cart items and select payment method.")
                .navigationBarTitleDisplayMode(.large)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Label("Back", systemImage: "arrow.left.circle")
                        }.tint(Color.yellow)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: MapView(viewmodel: viewmodel)) {
                            ConfirmView(vm: viewmodel)
                        }
                    }
                }
                
                Text("Subtotal: $" + pretotalPrice + "  ")
                    .frame(maxWidth: .infinity, alignment: .trailing).padding(7)
                Spacer()
                Text("Delivery cost: $" + deliveryCost + "  ")
                    .frame(maxWidth: .infinity, alignment: .trailing).padding(7)
                Spacer()
                Divider()
                Text("Total: $" + total + "  ")
                    .bold().font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .trailing).padding(10)
                Divider()
                Spacer()
            }
        }
    }
}

struct ConfirmView: View {
    var vm: MyViewModel
    var body: some View {
        HStack{
            Image(systemName: "checkmark.seal.fill").frame(width: 50, height: 50, alignment: .center).foregroundColor(Color.yellow).aspectRatio(contentMode: .fill)
            Text("OK").font(.system(size: 20)).bold()
                .foregroundColor(Color.yellow)
        }
    }
}

