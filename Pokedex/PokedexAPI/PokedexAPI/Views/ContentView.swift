//
//  ContentView.swift
//  PokedexAPI
//
//  Created by Jeffrey Clay Setiawan on 26/03/24.
//

import SwiftUI

struct ContentView: View {
    @State var searchText = ""
    @StateObject var viewModel = PokedexViewmodel()
    let columns = [GridItem(), GridItem(), GridItem(), GridItem()]
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(viewModel.pokemons){ pokemon in
                        VStack{
                            AsyncImage(url: URL(string:pokemon.images.small), scale: 2.5)
                                .scaledToFit()
                                .frame(width: 160, height: 200)
                            Text(pokemon.name)
                                .scaledToFit()
                        }
                        
                    }
                    
                    switch viewModel.state {
                    case .empty:
                        Color.clear
                            .onAppear{
                                viewModel.loadMore()
                            }
                    case .isLoading:
                        ProgressView()
                            .progressViewStyle(.circular)
                    case .loadedAll:
                        Color.clear
                    case .error(let string):
                        Text(string)
                            .foregroundColor(.blue)
                    }
                }
                .searchable(text: $viewModel.searchTerm)
                .onAppear{
                    viewModel.getCard()
                }
                .navigationTitle("POKEDEX!")
                .environmentObject(viewModel)
            }
        }
        
    }
}
#Preview {
    ContentView()
}

