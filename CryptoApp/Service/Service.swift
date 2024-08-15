//
//  Service.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 14.08.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Service{
    
    static func fetchUser(uid: String, completion: @escaping(User) -> Void){
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            let user = User(data: data)
            completion(user)
        }
    }
}


