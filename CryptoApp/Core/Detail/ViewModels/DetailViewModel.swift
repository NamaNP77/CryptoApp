//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by NamaN  on 17/09/23.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject{
    
    private let coinDetailSerivce : CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin : CoinModel) {
        self.coinDetailSerivce = CoinDetailDataService(coin: coin)
        addSubcribers()
    }
    
    private func addSubcribers(){
        
        coinDetailSerivce.$coinDetails
            .sink { returnedCoinDetails in
                print("Received coin details data")
                print(returnedCoinDetails)
            }.store(in: &cancellables)
    }
}
