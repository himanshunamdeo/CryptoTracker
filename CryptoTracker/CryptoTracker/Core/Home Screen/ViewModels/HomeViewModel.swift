//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 29/10/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var statistics: [StatisticsModel] = []
    @Published var searchText: String = ""
    
    let coinDataService = CoinDataService()
    let marketDataService = MarketDataService()
    let portfolioDataService = PortfolioDataService()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscription()
    }
    
    func addSubscription() {
        
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoined in
                self?.allCoins = returnedCoined
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)
        
        $allCoins.combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [CoinModel]  in
                coinModels.compactMap { coinModel in
                    guard let entity = portfolioEntities.first(where: { $0.coinID == coinModel.id }) else {
                        return nil
                    }
                    
                    return coinModel.updateHoldings(amount: entity.amount)
                }
            }
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedSearchText = text.lowercased()
        return coins.filter { coin in
            return coin.name?.lowercased() == lowercasedSearchText ||
            coin.id?.lowercased() == lowercasedSearchText ||
            coin.symbol?.lowercased() == lowercasedSearchText
        }
    }
    
    private func mapGlobalMarketData(marketData: MarketDataModel?) -> [StatisticsModel] {
        var statistics: [StatisticsModel] = []
        
        guard let data = marketData else { return statistics }
        
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: " BTC Dominance", value: data.bitcoinDominance)
        let portfolioValue = StatisticsModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolioValue])
        
        return statistics
    }
}
