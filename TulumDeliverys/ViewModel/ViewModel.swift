//
//  Untitled.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
final class MyViewModel {
    
    private let repository: ProductRepositoryProtocol // Injeccion de dependencia abstracta
    var products: [Item] = [] //Data pública guardada localmente listos para presentar a la vista
    var selected: [Item] = [] //Productos seleccionados guardados localmente listos para presentar a la vista
    private(set) var isLoading = false //propiedad para menejar el estado del ActivityIndicator (en la vista)
    
    //Se inyecta el contexto al inicializarse el viewmodel
    init(repository:ProductRepositoryProtocol) {
         self.repository = repository
         fetchProducts() //recuperar Data offline
     }
    
    func fetchData() async throws {
       isLoading = true
       defer { isLoading = false }
       try await repository.fetchAndPersistProducts()
       fetchProducts()
       fetchFavs() // Actualizar las listas del Viewmodel despues de guardarlas la data localmente.
   }
    // MARK: Actualizar la propiedad que vera la vista, usando de la data guardada en local como fuente de verdad.
    func fetchProducts() {
        do {
            products = try repository.getProducts(isFavorite: false)
        } catch {
            print("Fallo la busqueda de Amiibos: \(error.localizedDescription)")
            products = []
        }
    }
    func fetchFavs() {
        do {
            selected = try repository.getProducts(isFavorite: true)
        } catch {
            print("Fallo la busqueda de Seleccionados: \(error.localizedDescription)")
            selected = []
        }
    }
    
    // MARK: PERSISTENCIA DE LA DATA REGULAR
    // Eliminar elementos
    func deleteProducts(at offsets: IndexSet) {
        repository.deleteProducts(at: offsets, in: products)
        fetchProducts()
    }
    // MARK: PERSISTENCIA DE FAVORITOS
    //Agregar favoritos
    func addFavoriteToSD(with product: Item){
        repository.addFavorite(product)
        fetchFavs()
    }
    // Eliminar de favoritos desde la lista general (boton favorito)
    func deleteFavoriteFromSD(id: String) {
        repository.deleteFavorite(id: id, in: selected)
        fetchFavs()
    }
    // Eliminar de favoritos desde la lista de favoritos (accion de eliminar)
    func deleteFavoriteFromIndex(at offsets: IndexSet) {
        repository.deleteFavorites(at: offsets, in: selected)
        fetchFavs()
    }

}
