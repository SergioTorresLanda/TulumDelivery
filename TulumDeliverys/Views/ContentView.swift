//
//  ContentView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext //Capa entre los objetos y la memoria.
    @State private var viewmodel: MyViewModel? //opcional por ser "late init"
    
    var body: some View {
        ZStack{
            if let vm = viewmodel {
                if vm.isLoading{
                    ProgressView()
                }else{
                    NavigationView {
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Text("Nombre Apellido")
                                Spacer()
                                Spacer()
                                Spacer()
                                NavigationLink(destination: CartView(viewmodel: vm)) {
                                    ButtonView()
                                }
                                Spacer()
                            }
                            Spacer()
                            Divider()
                            Text("Products available:  \(vm.products.count)").bold().font(.title3)
                            List{
                                ForEach(vm.products, id: \.id) { prod in
                                    ProductView(product: prod, viewmodel: vm)
                                }
                                .onDelete { indexSet in
                                    vm.deleteProducts(at: indexSet)
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                        }
                    }
                }
            }
        }.task {//trabajo asyncrono se usará el patrón (async/await) en lugar de completion handlers (@escaping).
            do {
                try await viewmodel?.fetchData()
            } catch {
                print (error)
            }
        }
        .onAppear{
            if viewmodel == nil {
                // Inicializar solo una vez todo el esquema del ViewModel usando la variable ambiental "modelContext"
                viewmodel = MyViewModel(
                    repository: Repository(
                        remoteDataSource: RemoteDataSource(),
                        localDataSource: LocalDataSource(
                            modelContext: modelContext)
                    )
                )
            }
        }
        .onDisappear{
            //manejar la desaparicion de la vista (similar a viewDidDissapear en controllers)
        }
    }
}

struct ButtonView: View {
    var body: some View {
        Text("Cart").font(.title)
            .frame(width: 150, height: 50, alignment: .center)
            .background(Color.red)
            .foregroundColor(Color.white)
            .border(.red, width: 5)
            .cornerRadius(25)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Item.self, configurations: config)
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create ModelContainer for preview: \(error)")
    }
}

