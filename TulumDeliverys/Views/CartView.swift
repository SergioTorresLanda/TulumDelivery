//
//  CartView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import Foundation
import SwiftUI
import SwiftData
import FirebaseFirestore

struct CartView: View {
    @EnvironmentObject var vm: MyViewModel
    @EnvironmentObject var coordinator: AppCoordinator
//    @State private var navigateToMap = false

    var pretotalPrice:String {
        return vm.pretotal.formatted(.number.grouping(.automatic))
    }
    var deliveryCost:String {
        return (Double(vm.pretotal)*0.25).formatted(.number.grouping(.automatic))
    }
    var total:String {
        return (Double(vm.pretotal)*1.25).formatted(.number.grouping(.automatic))
    }
    
    var body: some View {
        VStack{
            Divider()
            Text("Step 2. Confirm your Cart items and your total bill.").font(.system(size: 20))
            Divider()
            Spacer()
            //Text("*You can edit your Cart and remove some stuff by swiping to the left on each item.").font(.system(size: 10))
            List{
                ForEach(vm.products, id: \.id) { item in
                    if item.isFavorite {
                        CartItemView(product: item)
                    }
                }
               /* .onDelete { indexSet in
                    viewmodel.deleteFavoriteFromIndex(at: indexSet)
                }*/
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
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
                        vm.writeDeliveryOrder(total: total)
                        coordinator.push(.map)
                    } label: {
                        ConfirmView(vm: vm, total: total)
                    }
                }
            }
            Divider()
            Text("Subtotal: $" + pretotalPrice + "  ")
                .frame(maxWidth: .infinity, alignment: .trailing).padding(7)
            Spacer()
            Text("Delivery service: $" + deliveryCost + "  ")
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

struct ConfirmView: View {
    var vm: MyViewModel
    @State var total: String

    var body: some View {
        HStack{
            Image(systemName: "arrowshape.turn.up.right.fill").frame(width: 50, height: 50, alignment: .trailing).foregroundColor(Color.yellow).aspectRatio(contentMode: .fill)
            //Text("").font(.system(size: 20)).bold()
               // .foregroundColor(Color.yellow)
        }
    }
}

