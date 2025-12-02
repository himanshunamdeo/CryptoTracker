//
//  CoinDetailModel.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 11/11/25.
//

import Foundation

//https://pro-api.coingecko.com/api/v3/coins/bitcoin \


struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let previewListing: Bool?
    let description: Description?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case previewListing = "preview_listing"
        case description, links
    }
}

// MARK: - Tion
struct Description: Codable {
    let en, de: String?
}

// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?

    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}
