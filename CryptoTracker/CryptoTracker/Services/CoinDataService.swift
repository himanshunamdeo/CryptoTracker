//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 29/10/25.
//

import Foundation
import Combine

@MainActor
class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&names=Bitcoin&symbols=btc&category=layer-1&price_change_percentage=24h&per_page=250&page=1&order=market_cap_desc&sparkline=true") else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] result in
                self?.allCoins = result
                self?.coinSubscription?.cancel()
            })
    }
}
