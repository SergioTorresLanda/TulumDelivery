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
    //@State private var navigateToCart = false

    var body: some View {
        ZStack{
            if let vm = viewmodel {
                if vm.isLoading{
                    ProgressView()
                }else{
                    NavigationView {
                    //NavigationStack {
                        VStack{
                            HStack{
                                Spacer()
                                Text("Aldea Tulum Deliverys").font(.system(size: 25)).bold()
                                Spacer()
                                Spacer()
                                Spacer()
                                NavigationLink(destination: CartView(viewmodel: vm)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)) {
                                    ButtonView(vm: vm)
                                }
                               /* Button {
                                    navigateToCart = true
                                } label: {
                                    ButtonView(vm: vm)
                                }*/
                                Spacer()
                            }
                            Spacer()
                            Divider()
                            Text("Step 1. Add some stuff to your cart.").font(.system(size: 20))
                            Text("Products available:  \(vm.products.count)").font(.system(size: 10))
                            //.foregroundColor(Color.yellow)
                            Divider()
                            List{
                                ForEach(Array(vm.categorys)) { cat in
                                    MainHCollectionView(products: vm.products.filter{$0.category == cat}, category: cat.uppercased(), vm: vm)
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                           
                        }.padding(.top, 1)
                        /*.navigationDestination(isPresented: $navigateToCart) {
                            CartView(viewmodel: vm).navigationBarBackButtonHidden(true)
                        }*/
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
    var vm: MyViewModel
    var body: some View {
        HStack{
            Image(systemName: "cart.fill").frame(alignment: .trailing).foregroundColor(Color.yellow).aspectRatio(contentMode: .fill)
            Text((String(vm.totalItems)+"    ")).font(.system(size: 20)).frame(alignment: .leading)
                //.background(Color.blue)
                .foregroundColor(Color.yellow)
        }
        .border(.yellow, width: 1)
        //.cornerRadius(10)
        .clipped()
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

/*List{
    ForEach(vm.products, id: \.id) { prod in
        ProductView(product: prod, viewmodel: vm)
    }
    .listRowSeparator(.hidden)
}
.listStyle(.plain)*/
extension String: @retroactive Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
