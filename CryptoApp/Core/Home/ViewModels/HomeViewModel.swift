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
    
    @Published var isLoading : Bool = false
    
    @Published var searchText : String = ""
    
    @Published var sortOption : SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank , rankReversed , holdings, holdingsReversed , price , priceReversed
    }
    
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
            .combineLatest(coinDataService.$allCoins , $sortOption)
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main) // slight delay after receiving new value in textfield
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
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
                guard let self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
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
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    //MARK: - Private Functions
    private func filterAndSortCoins(text : String , coin : [CoinModel] , sort : SortOption) -> [CoinModel]{
        var updatedCoins = filterCoins(text: text, coin: coin)
        sortCoins(sort: sort, coins: &updatedCoins)
        
        return updatedCoins
    }
    
    private func filterCoins(text : String , coin : [CoinModel]) -> [CoinModel] {
        
        guard !text.isEmpty
            else{
                return coin    }
        
        let lowercasedText = text.lowercased()
        return coin.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }

    }
    
    private func sortCoins(sort : SortOption , coins : inout [CoinModel]) {
        
        switch sort{
        case .rank , .holdings:
            //NOOB
//            return coins.sorted { coin1, coin2 in
//                return coin1.rank < coin2.rank
//            }
            //PRO
             coins.sort(by: { $0.rank < $1.rank})
        case .rankReversed , .holdingsReversed:
             coins.sort(by: { $0.rank > $1.rank})
            
        case .price:
             coins.sort(by: { $0.currentPrice > $1.currentPrice})
            
        case .priceReversed:
             coins.sort(by: { $0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins : [CoinModel]) -> [CoinModel] {
        // will only sort by holdings or reverseHoldings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
            
        case.holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    
    //MARK: - Public Functions
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
}
