//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 29/10/25.
//


import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&names=Bitcoin&symbols=btc&category=layer-1&price_change_percentage=24h&per_page=250&page=1&order=market_cap_desc&sparkline=true") else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (result) -> Data in
                guard let response = result.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { data in
                if let body = String(data: data, encoding: .utf8) {
                    print("Response body:\n\(body)")
                } else {
                    print("Response body is non-UTF8 data of length \(data.count)")
                }
            })
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let decodingError = error as? DecodingError {
                        print("🔴 Decoding Error (Specific): \(decodingError)")
                        // This will give you the specific key, context, and type that failed!
                    }  else {
                        print("🔵 Generic Combine/URL Error: \(error.localizedDescription)")
                    }
                }
            } receiveValue: { [weak self] result in
                self?.allCoins = result
                self?.coinSubscription?.cancel()
            }
    }
}
