//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by NamaN  on 05/09/23.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins : [CoinModel] = []
    var coinSubcription : AnyCancellable?
    
    init() {
        getCoins()
    }
        
    private func getCoins(){
        
        guard let url = URL(string:"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en" )
        else{return}
        
        coinSubcription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubcription?.cancel()
            })
//            .sink { (completion) in
//                switch completion  {
//                case .finished:
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//                self?.coinSubcription?.cancel()
//            }
            

    }
}
