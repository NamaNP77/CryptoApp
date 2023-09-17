//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by NamaN  on 17/09/23.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject{
    
    @Published var coin : CoinModel
    private let coinDetailSerivce : CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var overviewStatistics : [StatisticModel] = []
    @Published var additionalStatistics : [StatisticModel] = []
    
    init(coin : CoinModel) {
        self.coin = coin
        self.coinDetailSerivce = CoinDetailDataService(coin: coin)
        addSubcribers()
    }
    
    private func addSubcribers(){
        
        coinDetailSerivce.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }.store(in: &cancellables)
    }
    
    private func mapDataToStatistic(coinDetailmodel : CoinDetailModel? , coinModel : CoinModel) -> (overview : [StatisticModel] , additional : [StatisticModel]){
        //overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray : [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        //additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "NA"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "NA"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "NA"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetailmodel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "NA" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailmodel?.hashingAlgorithm ?? "NA"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray : [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return (overviewArray, additionalArray)
    }
}
