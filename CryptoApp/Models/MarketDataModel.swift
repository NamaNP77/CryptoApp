//
//  MarketDataModel.swift
//  CryptoApp
//
//  Created by NamaN  on 09/09/23.
//

import Foundation
//JSON DATA
/*
 
 URL : https://api.coingecko.com/api/v3/global
 
 JSONResponse :
 {
   "data": {
     "active_cryptocurrencies": 9990,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 851,
     "total_market_cap": {
       "btc": 41925260.52797576,
       "eth": 663834742.7493691,
       "ltc": 17294615744.33073,
       "bch": 5655047227.097832,
       "bnb": 5043152696.287181,
       "eos": 1867589109630.5842,
       "xrp": 2152866323580.8997,
       "xlm": 8319788071597.576,
       "link": 173740731979.9061,
       "dot": 254305736601.09125,
       "yfi": 201060656.23046,
       "usd": 1084373268918.3286,
       "aed": 3982903016737.0146,
       "ars": 379530644121414.6,
       "aud": 1698516744756.3718,
       "bdt": 118990341276365.6,
       "bhd": 408793541156.44464,
       "bmd": 1084373268918.3286,
       "brl": 5407335742788.15,
       "cad": 1481199666678.9902,
       "chf": 967975557859.3643,
       "clp": 971674355079647.5,
       "cny": 7962552913667.289,
       "czk": 24724794904606.758,
       "dkk": 7558406996341.408,
       "eur": 1012750414506.2726,
       "gbp": 869934117496.6521,
       "hkd": 8501757521636.934,
       "huf": 390721376256651.5,
       "idr": 16679504310521036,
       "ils": 4167571784433.8076,
       "inr": 90051774864202.81,
       "jpy": 160286712483882.03,
       "krw": 1449058842988249.8,
       "kwd": 334474934797.8579,
       "lkr": 349929176473749.94,
       "mmk": 2276761504593361.5,
       "mxn": 19081174226521.332,
       "myr": 5071071592096.553,
       "ngn": 851775202735347,
       "nok": 11581648698682.182,
       "nzd": 1841667028732.8188,
       "php": 61451426643362.125,
       "pkr": 333309233533771,
       "pln": 4679667060680.508,
       "rub": 105997489205512.95,
       "sar": 4067285691404.434,
       "sek": 12066038237907.998,
       "sgd": 1479735762765.948,
       "thb": 38532992658225.33,
       "try": 29109999319739.227,
       "twd": 34797429762262.207,
       "uah": 40039914743216.32,
       "vef": 108578295416.79195,
       "vnd": 26088615051319156,
       "zar": 20737998987834.344,
       "xdr": 815120133126.1016,
       "xag": 47287501323.24817,
       "xau": 565034379.2352722,
       "bits": 41925260527975.76,
       "sats": 4192526052797576
     },
     "total_volume": {
       "btc": 987623.9511447068,
       "eth": 15637806.02159365,
       "ltc": 407405380.9050965,
       "bch": 133214678.1201156,
       "bnb": 118800416.01195763,
       "eos": 43994377431.17676,
       "xrp": 50714588723.01027,
       "xlm": 195987380030.11102,
       "link": 4092771423.048641,
       "dot": 5990623152.195861,
       "yfi": 4736340.746018066,
       "usd": 25544337682.7724,
       "aed": 93824352308.82288,
       "ars": 8940518188970.33,
       "aud": 40011577684.11192,
       "bdt": 2803028759260.8857,
       "bhd": 9629857685.677626,
       "bmd": 25544337682.7724,
       "brl": 127379394288.91313,
       "cad": 34892288057.78294,
       "chf": 22802382931.56588,
       "clp": 22889514667401.883,
       "cny": 187572071604.59775,
       "czk": 582436443504.8922,
       "dkk": 178051696950.22803,
       "eur": 23857134178.82527,
       "gbp": 20492842728.653393,
       "hkd": 200273993517.35648,
       "huf": 9204135753856.535,
       "idr": 392915338935099.75,
       "ils": 98174553016.19905,
       "inr": 2121329446232.8213,
       "jpy": 3775838105852.562,
       "krw": 34135153888865.535,
       "kwd": 7879150958.251133,
       "lkr": 8243203060341.353,
       "mmk": 53633159690927.49,
       "mxn": 449490938034.90356,
       "myr": 119458095173.48485,
       "ngn": 20065077249817.715,
       "nok": 272826298620.84995,
       "nzd": 43383736790.29009,
       "php": 1447597463216.687,
       "pkr": 7851690795242.159,
       "pln": 110237866486.88876,
       "rub": 2496959059579.6724,
       "sar": 95812136034.2832,
       "sek": 284236954263.7443,
       "sgd": 34857803201.91114,
       "thb": 907713058411.4681,
       "try": 685737719549.6865,
       "twd": 819715241806.3964,
       "uah": 943211283703.4238,
       "vef": 2557754532.1759934,
       "vnd": 614563648559421.8,
       "zar": 488520387023.78864,
       "xdr": 19201602003.12698,
       "xag": 1113941053.8776152,
       "xau": 13310388.036362182,
       "bits": 987623951144.7068,
       "sats": 98762395114470.69
     },
     "market_cap_percentage": {
       "btc": 46.46423124073678,
       "eth": 18.109942187152992,
       "usdt": 7.650376596533824,
       "bnb": 3.0506021318189545,
       "xrp": 2.465691712047688,
       "usdc": 2.4093722033150846,
       "steth": 1.2950604020864238,
       "ada": 0.8247071509116198,
       "doge": 0.8243237813458263,
       "sol": 0.737442708843391
     },
     "market_cap_change_percentage_24h_usd": -0.8036829722294416,
     "updated_at": 1694245908
   }
 }
 
 */



struct GlobalData : Codable{
    
    let data: MarketDataModel?
}


struct MarketDataModel : Codable{
    
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys : String , CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap : String {
        
//        if let item = totalMarketCap.first(where: { (key , value) in
//            return key == "usd"
//        }){
//            return "\(item.value)"
//        }
        
        // shorter and professional way to write above statement
        if let item = totalMarketCap.first(where: {$0.key == "usd"}){
            return "$"+item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume : String {
        if let item = totalVolume.first(where: {$0.key == "usd"}){
            return "$"+item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance : String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}){
            return item.value.asPercentString()
        }
        return ""
    }
}
