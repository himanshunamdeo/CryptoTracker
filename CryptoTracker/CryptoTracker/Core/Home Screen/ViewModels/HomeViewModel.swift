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
    
    let coinDataService = CoinDataService()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addCoinDataSubscription()
    }
    
    func addCoinDataSubscription() {
        
        coinDataService.$allCoins
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
    }
}
