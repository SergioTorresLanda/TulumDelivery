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
    @State var favCount = 0
    
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: product.image)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "slowmo")
            }
            .frame(width: 90, height: 90)
            .clipShape(.rect(cornerRadius: 25))
            Spacer()
            Text(product.name).bold().lineLimit(2).multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 16))
            Text("$"+String(product.price))
            Spacer()
            HStack{
                Button{
                    if favCount>0{
                        viewmodel.removeFavorite(with: product)
                        favCount-=1
                    }
                } label: {
                    Image(systemName: "minus.rectangle.fill")
                }//.background(Color.yellow)
                    .foregroundColor(Color.yellow)
                Text(String(favCount))
                Button{
                    viewmodel.addFavoriteToSD(with: product)
                    favCount+=1
                } label: {
                    Image(systemName: "plus.rectangle.fill")
                }//.background(Color.gray)
                .foregroundColor(Color.yellow)
            }
        }
        .frame(maxWidth: 120, alignment: .leading)
        .padding()
        .background(.gray.opacity(0.1),
                    in: RoundedRectangle(cornerRadius: 10,
                                         style: .continuous))
        .listRowSeparator(.hidden)
    }
}

/*
 VStack {
         Image(systemName: "photo")
             .resizable()
             .scaledToFit()
             .frame(width: 100, height: 100)
             .background(Color.gray.opacity(0.2))
             .cornerRadius(10)
         Text(product.name)
             .font(.caption)
             .lineLimit(1)
     }
     .padding(8)
     .background(Color.white)
     .cornerRadius(12)
     .shadow(radius: 2)
 */
