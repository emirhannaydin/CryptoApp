//
//  Crypto.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 7.08.2024.
//

import Foundation

struct Crypto: Decodable {
    let id,symbol,name: String
    let image: String
    let currentPrice: Double?
    let marketCapRank: Int?
    let marketCap,totalVolume : Double?
    let high24H,low24H: Double?
    
    let priceChange24H: Double?
    let priceChangePercentage24H :Double?
    let marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let sparklineIn7D: SparklineIn7D?

}

struct SparklineIn7D: Codable {
    let price: [Double]
}
