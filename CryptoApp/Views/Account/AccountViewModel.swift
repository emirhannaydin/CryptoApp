//
//  AccountViewModel.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 15.08.2024.
//

import Foundation
import FirebaseAuth

protocol AccountViewModelInterface{
    var view: AccountViewControllerInterface? { get set }
    
    func viewDidLoad()
}

final class AccountViewModel{
    weak var view: AccountViewControllerInterface?
    var user: User?

    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(uid: uid) { [weak self] user in
            guard let self = self else { return }

            self.user = user
            DispatchQueue.main.async {
                        self.view?.configureText()
            }
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            self.view?.showSignOutError()
        }
    }
    
}

extension AccountViewModel: AccountViewModelInterface {
    
    func viewDidLoad() {
        view?.style()
        view?.layout()
        self.fetchUser()
    }
    
}
