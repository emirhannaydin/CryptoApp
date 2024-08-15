//
//  AuthenticationService.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
struct AuthenticationRegisterUserModel {
    let emailText: String
    let passwordText: String
    let usernameText: String
}

struct AuthenticationService {
    
    static func login(emailText: String, passwordText: String, completion: @escaping(AuthDataResult?, Error?) -> Void){
        Auth.auth().signIn(withEmail: emailText, password: passwordText, completion: completion)
    }
    
    static func createUser(user: AuthenticationRegisterUserModel, completion: @escaping(Error?) -> Void){
        
        Auth.auth().createUser(withEmail: user.emailText, password: user.passwordText) { result, error in
            
            guard let uid = result?.user.uid else { return }
            let data = [
            
                "email": user.emailText,
                "password:": user.passwordText,
                "username": user.usernameText,
                "uid": uid
            ] as [String: Any]
            Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
            
        }
        
    }
}
