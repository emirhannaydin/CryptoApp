//
//  ErrorMessage.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 7.08.2024.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidUsername = "This username created at invalid request"
    case unableToComplete = "Unable to complete your request"
    case invalidResponse = "Invalid response from the server"
    case invalidData = "The data received from the server was invalid"
    case invalidURL = "Invalid URL"
    case decodingError = "Error decoding data"
    
}
