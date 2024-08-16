//
//  CollectionViewExtensions.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 16.08.2024.
//

import UIKit

extension MarketViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.top5Cryptos.count // Burada en yüksek 5 kriptoyu gösteriyoruz
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoCollectionViewCell.identifier, for: indexPath) as! CryptoCollectionViewCell

        let model = viewModel.top5Cryptos[indexPath.row] // En yüksek 5 kriptoyu kullanıyoruz
        cell.cryptoSetup(model: model)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.darkGray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 100)
    }
    
}
