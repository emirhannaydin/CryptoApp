//
//  User.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 14.08.2024.
//

import Foundation

struct User{
    let email: String
    let uid: String
    let username: String
    
    init(data: [String: Any]) {
        self.email = data["email"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
    }
}
