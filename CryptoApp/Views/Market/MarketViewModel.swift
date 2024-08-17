//
//  MarketViewModel.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 16.08.2024.
//

import Foundation
import FirebaseAuth

protocol MarketViewModelInterface{
    var view: MarketViewControllerInterface? { get set }
    
    func viewDidLoad()
    func getTop5Cryptos(from cryptos: [Crypto]) -> [Crypto]
    func checkUser() -> Bool
    func filterContent(searchText: String)
}

final class MarketViewModel{
    weak var view: MarketViewControllerInterface?
    
    var cryptoList: [Crypto] = []
    var filteredCryptoList: [Crypto] = []
    var top5Cryptos: [Crypto] = []
    var pageNumber = 1
    var isLoading = false
    var isSearching = false
    
    func getCryptoService(page: Int) {
        self.isLoading = true
        NetworkManager.shared.getCrypto(pageNumber: page) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.view?.showNetworkError(error)
                self.isLoading = false
                return
            }
            
            guard let result = result else {
                self.view?.showNoDataError()
                self.isLoading = false
                return
            }
            DispatchQueue.main.async {
                self.cryptoList.append(contentsOf: result)
                if !self.isSearching {
                    self.filteredCryptoList = self.cryptoList
                    self.view?.reloadTable()

                } else {
                    if let searchText = self.view?.getSearchText() {
                        self.filterContent(searchText: searchText)
                    }
                }
                
                if self.top5Cryptos.isEmpty {
                    self.top5Cryptos = self.getTop5Cryptos(from: self.cryptoList)
                    self.view?.reloadCollection()
                }
                self.isLoading = false
                self.pageNumber += 1
            }
        }
    }
    
    
    
}
extension MarketViewModel: MarketViewModelInterface{
    
    func viewDidLoad() {
        view?.style()
        view?.layout()
        view?.userStatus()
        getCryptoService(page: pageNumber)
    }
    
    func getTop5Cryptos(from cryptos: [Crypto]) -> [Crypto] {
        let sortedCryptos = cryptos.sorted {
            ($0.priceChangePercentage24H ?? 0.0) > ($1.priceChangePercentage24H ?? 0.0)
        }
        let top5Cryptos = Array(sortedCryptos.prefix(5))
        return top5Cryptos
    }
    
    func checkUser() -> Bool{
        if Auth.auth().currentUser?.uid == nil{
            return true
        }
        else{
            return false
        }
    }
    
    func filterContent(searchText: String) {
        if searchText.isEmpty {
            filteredCryptoList = cryptoList
        } else {
            filteredCryptoList = cryptoList.filter { $0.name.lowercased().contains(searchText) }
        }
        self.view?.reloadTable()
    }
}
