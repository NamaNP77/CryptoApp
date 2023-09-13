//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by NamaN  on 05/09/23.
//

import Foundation
import Combine
// we are going to use this model on multiple view so put it into the environment than making it observable object

class HomeViewModel : ObservableObject {
    
    @Published var statistics : [StatisticModel] = []
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    
    @Published var searchText : String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubcriber()
    }
    
    func addSubcriber(){
//
        
        ///this function is no longer needed as the purpose this is served ahead by searchText subscriber
        
        
//        dataService.$allCoins
//            .sink { [weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//            }
//            .store(in: &cancellables)
        
        //update all coins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main) // slight delay after receiving new value in textfield
            .map { (text , startingCoins) -> [CoinModel] in
                
                guard !text.isEmpty
                    else{
                        return startingCoins    }
                
                let lowercasedText = text.lowercased()
                return startingCoins.filter { (coin) -> Bool in
                    return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
                }
                
            }
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        //update market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map { (marketDataModel , portfolioCoins) -> [StatisticModel] in
                var stats : [StatisticModel] = []
                
                guard let data = marketDataModel else {return stats}
                
                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                
                
                let volume = StatisticModel(title: "24h Volume", value: data.volume, percentageChange: data.marketCapChangePercentage24HUsd)
                
                let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance, percentageChange: data.marketCapChangePercentage24HUsd)
                
                let portfolioValue = portfolioCoins
                    .map { coin -> Double in
                    return coin.currentHoldingsValue
                }
                    .reduce(0, +)
                
                let previousValue = portfolioCoins
                    .map { coin -> Double in
                        let currentValue = coin.currentHoldingsValue
                        let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                        let previousValue = currentValue / (1+percentChange)
                        return previousValue
                    }
                    .reduce(0, +)
                    
                let percentageChange = ((portfolioValue - previousValue)/previousValue) * 100
                    
                
                let portfolio = StatisticModel(title: "Portfolio Value",
                                               value: portfolioValue.asCurrencyWith2Decimals(),
                                               percentageChange: percentageChange)
                
                stats.append(contentsOf: [
                    marketCap,
                    volume,
                    btcDominance,
                    portfolio
                ])
                return stats
            }
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        //update portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels , portfolioEntities) -> [CoinModel] in
                
                coinModels
                    .compactMap { coin -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else {return nil}
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
}
