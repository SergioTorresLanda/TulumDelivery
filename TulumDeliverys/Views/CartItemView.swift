//
//  CartItemView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 11/06/25.
//
import Foundation
import SwiftUI

struct CartItemView: View {
    var product: Item
    var viewmodel: MyViewModel
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: product.image)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "slowmo")
            }
            .frame(width: 50, height: 50)
            .clipShape(.rect(cornerRadius: 10))
            Text(product.name).bold().lineLimit(2).multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 16))
            Spacer()
            Text("$"+String(product.price))
            Spacer()
            Text("x"+String(product.selectedItems))
            Spacer()
            Text("= $"+String(product.selectedItems*product.price))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.gray.opacity(0.1),
                    in: RoundedRectangle(cornerRadius: 10,
                                         style: .continuous))
        .listRowSeparator(.hidden)
    }
}
