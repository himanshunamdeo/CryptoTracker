//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 11/11/25.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics = [StatisticsModel]()
    @Published var additionalStatistics = [StatisticsModel]()
    
    private let detailService: CoinDetailDataService
    private var cancellable = Set<AnyCancellable>()
    @Published var coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        detailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        detailService.$coinDetail
            .combineLatest($coin)
            .map(mapDetailStatistics)
            .sink { returnedArray in
                self.overviewStatistics = returnedArray.overview
                self.additionalStatistics = returnedArray.additional
            }
            .store(in: &cancellable)
    }
    
    private func mapDetailStatistics(coinDetail: CoinDetailModel?, coin: CoinModel) -> (overview: [StatisticsModel], additional: [StatisticsModel]) {
        let price = coin.currentPrice?.asCurrencyWith2Decimals()
        let priceChange = coin.priceChangePercentage24H
        let priceStats = StatisticsModel(title: "Current Price", value: price ?? "", percentageChange: priceChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coin.marketCapChangePercentage24H
        let marketCapStats = StatisticsModel(title: "Market Cap", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coin.rank)"
        let rankStats = StatisticsModel(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStats = StatisticsModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticsModel] = [priceStats, marketCapStats, rankStats, volumeStats]
        
        
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let highStats = StatisticsModel(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowStats = StatisticsModel(title: "24h low", value: low)
        
        let priceChange24H = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let priceChangePercentage24H = coin.priceChangePercentage24H
        let priceChange24HStats = StatisticsModel(title: "24H Price Change", value: priceChange24H, percentageChange: priceChangePercentage24H)
        
        let marketCapChange24H = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage24H = coin.marketCapChangePercentage24H
        let marketCapChange24HStats = StatisticsModel(title: "24H Market Cap Change", value: marketCapChange24H, percentageChange: marketCapChangePercentage24H)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockTimeStats = StatisticsModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "N/A"
        let hashingStats = StatisticsModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray : [StatisticsModel] = [highStats, lowStats, priceChange24HStats, marketCapChange24HStats, blockTimeStats, hashingStats]
        
        return (overviewArray, additionalArray)
    }
}
