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
            
            if let errorMessage = errorMessage {
                        DispatchQueue.main.async {
                            print("Error: \(errorMessage.rawValue)")
                        }
                        return
            }
            if let data = data {
                self?.view?.changeIcon(data: data)
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
