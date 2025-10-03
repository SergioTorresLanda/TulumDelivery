//
//  ContentView.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 10/06/25.
//

import SwiftUI
import SwiftData

enum Route {
    case cart
    case map
}
let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.width

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext //Capa entre los objetos y la memoria.
    @State private var viewmodel: MyViewModel? //opcional por ser "late init"
    @State var route : [Route] = []
    var body: some View {
        ZStack{
            if let vm = viewmodel {
                if vm.isLoading{
                    ProgressView()
                }else{
                    //NavigationStack(path: $route) {
                    //NavigationStack {
                    NavigationView {
                        VStack{
                            HStack{
                                Spacer()
                                Text("Aldea Tulum Deliverys")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color.yellow)
                                    .bold()
                                Spacer()
                                Spacer()
                                Spacer()
                                NavigationLink(destination: CartView(viewmodel: vm)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)) {
                                    ButtonView(vm: vm)
                                }
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
                            .refreshable {
                                mainTask()
                            }
                            if vm.totalItems > 0 {
                                HStack {
                                    Spacer()
                                    Button {
                                        vm.deleteAllSelected()
                                    } label: {
                                        Label("Clear", systemImage: "cart.badge.minus.fill")                                           .font(.system(size: 20))
                                            .padding()
                                            .foregroundStyle(.red)
                                            .background(.black)
                                            .cornerRadius(20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.red, lineWidth: 1)
                                            )
                                    }
                                    .padding(.trailing, 20)
                                    Spacer()
                                    NavigationLink(destination: CartView(viewmodel: vm)
                                       .navigationBarBackButtonHidden(true)
                                       .toolbar(.hidden, for: .navigationBar)) {
                                           HStack{
                                               Label("Checkout", systemImage: "rectangle.portrait.and.arrow.forward.fill")
                                               .padding(16)
                                               .frame(maxWidth: .infinity)
                                               .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.black)
                                               )
                                               .font(.system(size: 20))
                                               .foregroundStyle(Color.yellow)
                                               .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.yellow, lineWidth: 1)
                                               )
                                           }
                                   }
                                    Spacer()
                                }
                               .padding(.horizontal, 10)
                            }
                           
                        }.padding(.top, 1)
                       /* .navigationDestination(for: Route.self) { path in
                            switch path{
                            case .cart:
                                CartView(viewmodel: vm)
                            case .map:
                                MapView(viewmodel: vm)
                            }
                         }*/
                    }
                }
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
            mainTask()
        }
        .onDisappear{
            //manejar la desaparicion de la vista (similar a viewDidDissapear en controllers)
        }
    }
    
    func mainTask(){
        Task{
            do {
                try await viewmodel?.fetchData()
            } catch {
                print (error)
            }
        }
    }
    
}

struct ButtonView: View {
    var vm: MyViewModel
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "cart.fill").frame(alignment: .trailing).foregroundColor(Color.yellow).aspectRatio(contentMode: .fill)
            if vm.totalItems ?? 0 > 0 {
                Text((String(vm.totalItems)+"    ")).font(.system(size: 20)).frame(alignment: .leading)
                //.background(Color.blue)
                    .foregroundColor(Color.yellow)
            }
        }
        //.border(.yellow, width: 1)
        //.cornerRadius(10)
        //.clipped()
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

extension String: @retroactive Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
