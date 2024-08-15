//
//  CryptoTableViewCell.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 9.08.2024.
//

import UIKit
import Kingfisher

class CryptoTableViewCell: UITableViewCell {
    
    static let identifier = "CryptoTableViewCell"
    
    let marketCapRank = UILabel()
    let cryptoImage = UIImageView()
    let cryptoName = UILabel()
    let cryptoSymbol = UILabel()
    let cryptoPrice = UILabel()
    let cryptoPriceChange = UILabel()
    var stackView = UIStackView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cryptoStyle()
        cryptoLayout()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cryptoSetup(model: Crypto){
        
        cryptoName.text = model.name
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_EN")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 8

        
        let formattedValue = String(format: "%.2f", model.priceChangePercentage24H ?? 0.0)
        if model.priceChangePercentage24H ?? 0.0 > 0.001 {
            cryptoPriceChange.text = "%+\(formattedValue)"
            cryptoPriceChange.backgroundColor = UIColor(red: 92/255, green: 200/255, blue: 134/255, alpha: 1.0)

            if let formattedPrice = numberFormatter.string(from: NSNumber(value: model.currentPrice ?? 0.0)) {
                cryptoPrice.text = "$\(formattedPrice)"
                cryptoPrice.textColor = UIColor(red: 92/255, green: 200/255, blue: 134/255, alpha: 1.0)
            }
        }
        else if model.priceChangePercentage24H ?? 0.0 < -0.001  {
            cryptoPriceChange.backgroundColor = UIColor(red: 226/255, green: 84/255, blue: 97/255, alpha: 1.0)
            cryptoPriceChange.text = "%\(formattedValue)"
            if let formattedPrice = numberFormatter.string(from: NSNumber(value: model.currentPrice ?? 0.0)) {
                cryptoPrice.text = "$\(formattedPrice)"
                cryptoPrice.textColor = UIColor(red: 226/255, green: 84/255, blue: 97/255, alpha: 1.0)
            }
            
        }
        else{
            cryptoPriceChange.text = "%\(formattedValue)"
            cryptoPriceChange.backgroundColor = .systemGray
            if let formattedPrice = numberFormatter.string(from: NSNumber(value: model.currentPrice ?? 0.0)) {
                cryptoPrice.text = "$\(formattedPrice)"
                cryptoPrice.textColor = .systemGray
            }

        }
        cryptoSymbol.text = "\(model.symbol.uppercased())"
        marketCapRank.text = "\(model.marketCapRank ?? 0)"
        
        getIcon(iconUrl: model.image)
        
    }
    
    func getIcon(iconUrl : String){
        NetworkManager.shared.getCryptoImage(iconUrl: iconUrl) { [weak self] data, errorMessage in
            
            if let errorMessage = errorMessage {
                        DispatchQueue.main.async {
                            print("Error: \(errorMessage.rawValue)")
                        }
                        return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self?.cryptoImage.image = UIImage(data: data)
                        }
                    }
                
        }

    }
    
}

extension CryptoTableViewCell {
    
    func cryptoStyle(){
        
        stackView = UIStackView(arrangedSubviews: [cryptoName, cryptoSymbol])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually

        cryptoName.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cryptoSymbol.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        cryptoPriceChange.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        cryptoPrice.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        marketCapRank.font = UIFont.systemFont(ofSize: 10, weight: .medium)

        cryptoPriceChange.layer.cornerRadius = 6
        cryptoPriceChange.layer.masksToBounds = true
        cryptoPriceChange.textColor = .white
        cryptoSymbol.textColor = .gray
        
        cryptoPriceChange.textAlignment = .center
        cryptoPrice.textAlignment = .center
        marketCapRank.textAlignment = .center
        cryptoSymbol.contentMode = .scaleAspectFit
    }
    
    func cryptoLayout(){
        contentView.addSubview(marketCapRank)
        contentView.addSubview(cryptoImage)
        contentView.addSubview(stackView)
        contentView.addSubview(cryptoPrice)
        contentView.addSubview(cryptoPriceChange)
        
        marketCapRank.translatesAutoresizingMaskIntoConstraints = false
        cryptoImage.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cryptoPrice.translatesAutoresizingMaskIntoConstraints = false
        cryptoPriceChange.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            cryptoPriceChange.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cryptoPriceChange.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cryptoPriceChange.widthAnchor.constraint(equalToConstant: 60),
            cryptoPriceChange.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            cryptoPrice.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cryptoPrice.trailingAnchor.constraint(equalTo: cryptoPriceChange.leadingAnchor, constant: -10),
            cryptoPrice.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: cryptoImage.trailingAnchor, constant: 5),
            stackView.widthAnchor.constraint(equalToConstant: 150),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            cryptoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cryptoImage.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -5),
            cryptoImage.widthAnchor.constraint(equalToConstant: 35),
            cryptoImage.heightAnchor.constraint(equalToConstant: 35),
            cryptoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            marketCapRank.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            marketCapRank.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            marketCapRank.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            marketCapRank.trailingAnchor.constraint(equalTo: cryptoImage.leadingAnchor, constant: -5),
            marketCapRank.widthAnchor.constraint(equalToConstant: 25)
            
            
        ])

        
    }
}
