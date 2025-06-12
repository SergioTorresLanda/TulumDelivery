//
//  MainHCollectionView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 11/06/25.
//
import Foundation
import SwiftUI

struct MainHCollectionView: View {
    var products: [Item]
    var category: String
    var vm: MyViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text(category)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading)
                .padding(.bottom, 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) { // Adjust spacing between items
                    ForEach(products, id: \.id) { prod in
                        ProductView(product: prod, viewmodel: vm)
                    }
                }
                .padding(.horizontal) // Padding for the entire HStack within the ScrollView
            }
            .frame(height: 180)
            Spacer()
        }
    }
}

