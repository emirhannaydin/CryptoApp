//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 7.08.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    let baseURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&sparkline=true&price_change_percentage=24h&x-cg-pro-api-key="
    //let apiKey = "CG-yPZ3cAKkPWQkaDvWc8YVioDo"
    
    private init() {}


    func getCrypto(pageNumber: Int,completion: @escaping ([Crypto]?, ErrorMessage?) -> Void) {
        
        let endpoint = "\(baseURL)&page=\(pageNumber)"
        print(endpoint)
                
        guard let url = URL(string: endpoint) else {
            
            completion(nil, .invalidURL)
            
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(nil, .unableToComplete)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, .invalidResponse)
                return
            }

            guard let data = data else {
                completion(nil, .invalidData)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let cryptoList = try decoder.decode([Crypto].self, from: data)
                completion(cryptoList, nil)
            } catch {
                print("Decoding error: \(error)")

                completion(nil, .invalidData)
            }

        }.resume()
    }
    
    func getCryptoImage(iconUrl: String, completion: @escaping (Data?, ErrorMessage?) -> Void) {
        guard let url = URL(string: iconUrl) else {
            completion(nil, .invalidURL)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                
                completion(nil, .unableToComplete)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, .invalidResponse)
                return
            }

            guard let data = data else {
                completion(nil, .invalidData)
                return
            }

            completion(data, nil)
        }.resume()
    }


}

