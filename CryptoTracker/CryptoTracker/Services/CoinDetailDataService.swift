//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 11/11/25.
//

import Foundation
import Combine

@MainActor
class CoinDetailDataService {
    
    @Published var coinDetail: CoinDetailModel? = nil
    var coinSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let coinID = coin.id,
            let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coinID)") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("CG-dvGQVo6RGSXGK6T9otPZwkNt", forHTTPHeaderField: "x-cg-pro-api-key")
        
        coinSubscription = NetworkingManager.download(urlRequest: urlRequest)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] result in
                self?.coinDetail = result
                self?.coinSubscription?.cancel()
            })
    }
}
