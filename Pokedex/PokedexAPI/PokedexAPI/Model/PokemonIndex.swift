//
//  PokemonIndex.swift
//  PokedexAPI
//
//  Created by Jeffrey Clay Setiawan on 26/03/24.
//struct Endpoints {

//static let apiKey = "7a501459-4f92-4fe6-befd-ad986ee22460"
//static let main = "https://api.pokemontcg.io/v2/"
//static let listCard = "cards"
//static let detailCard = "cards/"
//}

import Foundation
import SwiftUI


struct PokemonIndex : Codable {
    var results: [Pokemon]
    
    enum CodingKeys: String, CodingKey{
        case results = "data"
    }
}

struct PokemonDetail: Codable{
    let result: Pokemon
    
    enum CodingKeys: String, CodingKey{
        case result = "data"
    }
}

struct Pokemon: Codable, Identifiable{
    let id: String
    let name: String
    let types: [String]?
    let evolvesFrom: String?
    let images: Images
}


struct Images: Codable{
    let small: String
    let large: String
}
