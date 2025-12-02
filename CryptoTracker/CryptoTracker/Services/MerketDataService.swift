//
//  MerketDataService.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 31/10/25.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketSubcription: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketSubcription = NetworkingManager.download(url: url)
            .decode(type: GlobalDataModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] model in
                self?.marketData = model.data
                self?.marketSubcription?.cancel()
            })
    }
    
}
