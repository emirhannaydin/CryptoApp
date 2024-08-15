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
            self?.user = user
            DispatchQueue.main.async {
                        self?.view?.configureText()
                    }
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
        } catch {
            print("Çıkış yaparken hata oluştu")
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
