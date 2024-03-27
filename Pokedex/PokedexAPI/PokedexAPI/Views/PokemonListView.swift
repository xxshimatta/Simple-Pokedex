//
//  PokemonListView.swift
//  PokedexAPI
//
//  Created by Jeffrey Clay Setiawan on 27/03/24.
//

import SwiftUI

struct PokemonListView: View {
    @EnvironmentObject var vm: PokedexViewmodel
    var body: some View {
        NavigationView{
            VStack{
                Text("Hello World")
            }.onAppear{
            }
        }
    }
}

#Preview {
    PokemonListView()
}
