//
//  RegisterViewModel.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 15.08.2024.
//

import Foundation
import FirebaseAuth

protocol RegisterViewModelInterface{
    var view: RegisterViewControllerInterface? { get set }
    
    func viewDidLoad()
}

final class RegisterViewModel{
    weak var view: RegisterViewControllerInterface?
    
    func register(emailText: String, passwordText: String, usernameText: String) {
            let user = AuthenticationRegisterUserModel(emailText: emailText, passwordText: passwordText, usernameText: usernameText)
            AuthenticationService.createUser(user: user) { error in
                if let error = error as NSError? {
                    if AuthErrorCode(rawValue: error.code) == .emailAlreadyInUse {
                        self.view?.showRegisterError("Email address is already taken.")
                    } else {
                        self.view?.showRegisterError("An error occurred: \(error.localizedDescription)")
                    }
                    return
                }
                self.view?.registerSuccess()
            }
        }
}

extension RegisterViewModel: RegisterViewModelInterface{
    
    func viewDidLoad(){
        view?.style()
        view?.layout()
    }
    
}
