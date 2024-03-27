//
//  PokedexViewModel.swift
//  PokedexAPI
//
//  Created by Jeffrey Clay Setiawan on 27/03/24.
//

import Foundation
import Combine

class PokedexViewmodel: ObservableObject{
    enum State: Comparable{
        case empty
        case isLoading
        case loadedAll
        case error(String)
    }
    var subscriptions = Set<AnyCancellable>()
    init(){
        $searchTerm
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink{ [weak self] term in
                self?.pokemons = []
                self?.page = 1
                self?.getCard()
        }.store(in: &subscriptions)
    }
    
    @Published var pokemons: [Pokemon] = [Pokemon]()
//    @Published var pokemonDetail: PokemonDetail
    @Published var searchTerm: String = ""
    @Published var state: State = .empty
    let pageSize:Int = 250
    var page = 1
    
    
    
    
    
    func loadMore(){
        getCard()
    }
    
    func getCard() {
        
        guard state == State.empty else{
            return
        }
        var req = URLRequest(url: URL(string: Endpoint.main + Endpoint.listCard + "?page=" + String(self.page) + "&pageSize="+String(self.pageSize)+"&q=name:"+String(searchTerm)+"*")!)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("X-Api-Key", forHTTPHeaderField: Endpoint.apiKey)
        print("Start Fetching data for \(searchTerm)")
        state = .isLoading
        
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse else {return}
            if let error = error{
                print("URLSession Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.state = .error("Could not Load: \(error.localizedDescription)")
                }
            }else if response.statusCode == 200{
                do{
                    let decoder = JSONDecoder()
                    let poke = try decoder.decode(PokemonIndex.self, from: data)
                    DispatchQueue.main.async{
                        
                        for pokemon in poke.results{
                            self.pokemons.append(pokemon)
                        }
                        self.state = ( poke.results.count == 250 ) ? .empty : .loadedAll
                        if self.state == .loadedAll{
                            self.page += 1
                        }
                    }
                } catch {
                    print("Decoding Error: \(error)")
                    DispatchQueue.main.async {
                        self.state = .error("Could not get data: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
    
//    func getDetailedPokemon(idCard: String) {
//        
//        guard state == State.empty else{
//            return
//        }
//        var req = URLRequest(url: URL(string: Endpoint.main + Endpoint.detailCard + idCard)!)
//        req.httpMethod = "GET"
//        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        req.addValue("X-Api-Key", forHTTPHeaderField: Endpoint.apiKey)
//        
//        URLSession.shared.dataTask(with: req) { (data, response, error) in
//            guard let data = data, error == nil, let response = response as? HTTPURLResponse else {return}
//            if let error = error{
//                print("URLSession Error: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.state = .error("Could not Load: \(error.localizedDescription)")
//                }
//            }else if response.statusCode == 200{
//                do{
//                    let decoder = JSONDecoder()
//                    let pokeDetail = try decoder.decode(PokemonDetail.self, from: data)
//                    DispatchQueue.main.async{
//                        let pokemonDetail = pokeDetail.result
//                    }
//                } catch {
//                    print("Decoding Error: \(error)")
//                    DispatchQueue.main.async {
//                        self.state = .error("Could not get data: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }.resume()
//    }
}

