//
//  LoginViewModel.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 15.08.2024.
//

import Foundation

protocol LoginViewModelInterface{
    var view: LoginViewControllerInterface? { get set }
    
    func viewDidLoad()
}

final class LoginViewModel{
    weak var view: LoginViewControllerInterface?
    
    func login(emailText: String, passwordText: String){
        AuthenticationService.login(emailText: emailText, passwordText: passwordText) { [weak self] result, error in
            guard let self = self else { return }

            if error != nil {
                self.view?.showLoginError()
                return
            }
            self.view?.LoginSuccess()
        }
    }
}
extension LoginViewModel: LoginViewModelInterface{
    
    func viewDidLoad() {
        view?.style()
        view?.layout()
    }
    
    
}
