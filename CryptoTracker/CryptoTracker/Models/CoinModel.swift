//
//  CoinModel.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 28/10/25.
//

import Foundation

//https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&names=Bitcoin&symbols=btc&category=layer-1&price_change_percentage=24h&per_page=250&page=1&order=market_cap_desc&sparkline=true


// JSON Response

/*
 
 [
   {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
     "current_price": 114289,
     "market_cap": 2278209659297,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 2278209659297,
     "total_volume": 50242531219,
     "high_24h": 115755,
     "low_24h": 113599,
     "price_change_24h": -904.5778949020023,
     "price_change_percentage_24h": -0.78527,
     "market_cap_change_24h": -18275287567.760742,
     "market_cap_change_percentage_24h": -0.79579,
     "circulating_supply": 19941062.0,
     "total_supply": 19941062.0,
     "max_supply": 21000000.0,
     "ath": 126080,
     "ath_change_percentage": -9.2751,
     "ath_date": "2025-10-06T18:57:42.558Z",
     "atl": 67.81,
     "atl_change_percentage": 168588.30833,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2025-10-28T09:34:10.547Z",
     "sparkline_in_7d": {
       "price": [
         107603.55609132143,
         107941.29470249634,
       ]
     },
     "price_change_percentage_24h_in_currency": -0.7852651522747313
   }
 */

struct CoinModel: Codable, Identifiable {
    let id, symbol, name: String?
    let image: String?
    let marketCapRank: Int?
    let currentPrice, marketCap, fullyDilutedValuation: Double?
    
    let totalVolume: Double?
    let high24H, low24H: Double?
    
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    
    let circulatingSupply, totalSupply, maxSupply: Double?
    
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id,
                         symbol: symbol,
                         name: name,
                         image: image,
                         marketCapRank: marketCapRank,
                         currentPrice: currentPrice,
                         marketCap: marketCap,
                         fullyDilutedValuation: fullyDilutedValuation,
                         totalVolume: totalVolume,
                         high24H: high24H,
                         low24H: low24H,
                         priceChange24H: priceChange24H,
                         priceChangePercentage24H: priceChangePercentage24H,
                         marketCapChange24H: marketCapChange24H,
                         marketCapChangePercentage24H: marketCapChangePercentage24H,
                         circulatingSupply: circulatingSupply,
                         totalSupply: totalSupply,
                         maxSupply: maxSupply,
                         ath: ath,
                         athChangePercentage: athChangePercentage,
                         athDate: athDate,
                         atl: atl,
                         atlChangePercentage: atlChangePercentage,
                         atlDate: atlDate,
                         lastUpdated: lastUpdated,
                         sparklineIn7D: sparklineIn7D,
                         priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency,
                         currentHoldings: amount)
        
    }
    
    var currentHoldingsValue: Double {
        return (currentPrice ?? 0) * (currentHoldings ?? 0)
    }
    
    var rank: Int {
        return marketCapRank ?? 0
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
