//
//  ProductView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import Foundation
import SwiftUI

struct ProductView: View {
    var product: Item
    var viewmodel: MyViewModel
    @State var isInFavoritesList = false
    @State private var active:Bool = false
    
    var body: some View {
        HStack{
            Text(product.id + " - " + product.name).bold()
            Spacer()
            AsyncImage(url: URL(string: product.image)) { image in
                image.resizable()
            } placeholder: {
                Color.red
            }
            .frame(width: 90, height: 90)
            .clipShape(.rect(cornerRadius: 25))
            Spacer()
            isInFavoritesList ? // Si estoy en la lista de favoritos, que el botón no funcione y sea estatico (imagen).
            Button{
            } label: {
                Image(systemName: "heart.fill")
            }.background(Color.black)
                .foregroundColor(Color.red)
            :  // Si no estoy en la lista de favoritos, que el botón funcione.
            Button{
                active ? viewmodel.deleteFavoriteFromSD(id: product.id) : viewmodel.addFavoriteToSD(with: product)
                active.toggle()
            } label: {
                Image(systemName: "heart.fill")
            }.background(Color.black)
                .foregroundColor(active ? Color.red : Color.white)
           
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.gray.opacity(0.1),
                    in: RoundedRectangle(cornerRadius: 10,
                                         style: .continuous))
        .listRowSeparator(.hidden)
    }
}

