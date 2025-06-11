//
//  RemoteDataSource.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//
import Foundation

protocol RemoteDataSourceProtocol {
    func fetchProductsFromAPI() async throws -> [Item]
}

class RemoteDataSource: RemoteDataSourceProtocol {
    
    private let apiURL = URL(string: "https://www.amiiboapi.com/api/amiibo/")
    
    func fetchProductsFromAPI() async throws -> [Item] {
        //guard let url = apiURL else { throw URLError(.badURL) }
        //let (data, _) = try await URLSession.shared.data(from: url)
       // let resp = try JSONDecoder().decode(Item.self, from: data)
        let items = [Item(timestamp: Date(),name: "name", image: "https://raw.githubusercontent.com/N3evin/AmiiboAPI/master/images/icon_04380001-03000502.png")]
        return items
    }
}
