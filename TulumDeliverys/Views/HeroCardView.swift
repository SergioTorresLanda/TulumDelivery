//
//  HeroCardView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//
import SwiftUI

struct HeroCardView: View {
    let model: HeroCardModel
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title).font(.headline)
            Text(model.amount).font(.largeTitle).bold()
            Button("Cash Out") { onTap() }
                .padding(.top, 4)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TransactionRowView: View {
    let model: TransactionRowModel
    
    var body: some View {
        HStack {
            Text(model.merchant)
            Spacer()
            Text(model.amount)
        }
        .padding()
        .background(Color.white)
    }
}
