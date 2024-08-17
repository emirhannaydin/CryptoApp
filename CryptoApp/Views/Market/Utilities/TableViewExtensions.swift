//
//  TableViewExtensions.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 16.08.2024.
//

import UIKit

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as! CryptoTableViewCell
        
        let model = viewModel.filteredCryptoList[indexPath.row]
        cell.cryptoSetup(model: model)
        
        
        cell.backgroundColor = UIColor.systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Mevcut ekranınızda veya geçişi başlatan yerde
        AnimationManager.showAnimation(on: self, animationName: "transitionAnimation") {
            let cryptoDetailVC = CryptoDetailsViewController()
            cryptoDetailVC.crypto = self.viewModel.filteredCryptoList[indexPath.row]
            self.navigationController?.pushViewController(cryptoDetailVC, animated: true)
        }

        
        }
}
