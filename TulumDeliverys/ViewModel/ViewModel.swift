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
    var categorys: Set<String> = []
    var selected: [Item] = [] //Productos seleccionados guardados localmente listos para presentar a la vista
    var pretotal:Int = 0
    var totalItems = 0
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
            for prod in products{
                categorys.insert(prod.category)
            }
        } catch {
            print("Fallo la busqueda de Productos: \(error.localizedDescription)")
            products = []
        }
    }
    func fetchFavs() {
        pretotal=0
        totalItems=0
        do {
            selected = try repository.getProducts(isFavorite: true)
            for s in selected {
                pretotal+=s.selectedItems*s.price
                totalItems+=s.selectedItems
            }
        } catch {
            print("Fallo la busqueda de Seleccionados: \(error.localizedDescription)")
            selected = []
        }
    }
    
    // MARK: PERSISTENCIA DE FAVORITOS
    //Agregar favoritos
    func addFavoriteToSD(with product: Item){
        repository.addFavorite(product)
        fetchFavs()
    }
    // Eliminar de favoritos desde la lista general (boton favorito)
    func removeFavorite(with product: Item) {
        repository.removeFavorite(product)
        fetchFavs()
    }
    // Eliminar de favoritos desde la lista de favoritos (accion de eliminar)
    func deleteFavoriteFromIndex(at offsets: IndexSet) {
        repository.deleteFavorites(at: offsets, in: selected)
        fetchFavs()
    }

}
