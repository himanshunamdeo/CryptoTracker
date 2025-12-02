//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 29/10/25.
//

import Foundation
import Combine
internal import UIKit

enum SortOptions {
    case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
}


class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var statistics: [StatisticsModel] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOptions = .holdings
    
    let coinDataService = CoinDataService()
    let marketDataService = MarketDataService()
    let portfolioDataService = PortfolioDataService()
    var isLoading = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscription()
    }
    
    func addSubscription() {
        
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoined in
                self?.allCoins = returnedCoined
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.statistics = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        $allCoins.combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                
                self.portfolioCoins = self.sortCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        self.isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOptions) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sortingOptions: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sortingOptions: SortOptions, coins: inout [CoinModel]) {
        switch sortingOptions {
        case .rank, .holdings:
            return coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            return coins.sort(by: { $0.rank > $1.rank})
        case .price:
            return coins.sort(by: {$0.currentPrice ?? 0 > $1.currentPrice ?? 0})
        case .priceReversed:
            return coins.sort(by: {$0.currentPrice ?? 0 < $1.currentPrice ?? 0})
        }
    }
    
    private func sortCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
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
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        return allCoins.compactMap { coinModel in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coinModel.id }) else {
                return nil
            }
            return coinModel.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketData: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
        var statistics: [StatisticsModel] = []
        
        guard let data = marketData else { return statistics }
        
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume, percentageChange: nil)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.bitcoinDominance, percentageChange: nil)
        
        let portfolioValue: Double = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0.0, +)
        
        let previousValue: Double = portfolioCoins
            .map { coin in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100.0
                let denominator = 1.0 + percentChange
                guard denominator != 0 else { return currentValue }
                return currentValue / denominator
            }
            .reduce(0.0, +)
        
        let percentChange: Double = previousValue != 0 ? ((portfolioValue - previousValue) / previousValue) * 100.0 : 0.0
        
        let portfolio = StatisticsModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentChange)
        
        statistics.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return statistics
    }
}

