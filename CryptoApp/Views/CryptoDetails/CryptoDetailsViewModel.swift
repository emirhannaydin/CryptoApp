//
//  CryptoDetailsViewModel.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 15.08.2024.
//

import Foundation


protocol CryptoDetailsViewModelInterface{
    var view: CryptoDetailsViewControllerInterface? { get set }
    
    func viewDidLoad()
}

final class CryptoDetailsViewModel{
    weak var view: CryptoDetailsViewControllerInterface?
    
    func getIcon(iconUrl : String){
        NetworkManager.shared.getCryptoImage(iconUrl: iconUrl) { [weak self] data, errorMessage in
            guard let self = self else { return }
            
            if let errorMessage = errorMessage {
                self.view?.showNetworkError(errorMessage)
                return
            }
            if let data = data {
                self.view?.changeIcon(data: data)
            }
        }
    }
    
}


extension CryptoDetailsViewModel: CryptoDetailsViewModelInterface{
    
    func viewDidLoad() {
        view?.style()
        view?.layout()
    }
}
