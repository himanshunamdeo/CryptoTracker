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
    @Published var statistics = [StatisticsModel(title: "Title", value: "Value", percentageChange: 7),
                                     StatisticsModel(title: "Title", value: "Value"),
                                     StatisticsModel(title: "Title", value: "Value", percentageChange: 20),
                                     StatisticsModel(title: "Title", value: "Value", percentageChange: -10)]
    
    @Published var searchText: String = ""
    
    let coinDataService = CoinDataService()
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
}
