//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by Himanshu Namdeo on 29/10/25.
//

import Foundation
import Combine

enum NetworkingError: LocalizedError {
    case badServerResponse(url: URL)
    case unknownError
    case badURL
    
    var errorDescription: String? {
        switch self {
        case .badServerResponse(let url): return "Bad Response from the server from url: \(url)"
        case .unknownError: return "Unknown error occured"
        case .badURL: return "The provided URL is invalid"
        }
    }
}
class NetworkingManager {
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(result: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func download(urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        // If the URLRequest has no URL, fail with a publisher error
        guard let url = urlRequest.url else {
            return Fail<Data, Error>(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleURLResponse(result: $0, url: url) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(result: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = result.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badServerResponse(url: url)
        }
        return result.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            if let decodingError = error as? DecodingError {
                print("🔴 Decoding Error (Specific): \(decodingError)")
            } else {
                print("🔵 Generic Combine/URL Error: \(error.localizedDescription)")
            }
        }
    }
}
