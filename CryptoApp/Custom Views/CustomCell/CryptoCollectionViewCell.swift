//
//  CryptoCollectionViewCell.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 12.08.2024.
//

import UIKit

class CryptoCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "CryptoCollectionViewCell"
    
    let cryptoName = UILabel()
    let cryptoPrice = UILabel()
    let cryptoPriceChange24h = UILabel()
    let cryptoImage = UIImageView()
    var firstStackView = UIStackView()
    var secondStackView = UIStackView()
    let errorLabel = UILabel()

    
    override init(frame: CGRect){
        super.init(frame: frame)
        cryptoStyle()
        cryptoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func cryptoSetup(model: Crypto){
        
        let formattedPriceValue = String(format: "%.3f", model.currentPrice ?? 0.0)
        let formattedPriceChangedValue = String(format: "%.2f", model.priceChangePercentage24H ?? 0.0)

        cryptoName.text = model.symbol.uppercased()
        cryptoPrice.text = " $\(formattedPriceValue)"
        cryptoPriceChange24h.text = "+%\(formattedPriceChangedValue)"
        getIcon(iconUrl: model.image)
        
    }
    
    func getIcon(iconUrl : String){
        NetworkManager.shared.getCryptoImage(iconUrl: iconUrl) { [weak self] data, errorMessage in
            guard let self = self else { return }

            if let errorMessage = errorMessage {
                        DispatchQueue.main.async {
                            self.showError(message: errorMessage.rawValue)
                        }
                        return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.cryptoImage.image = UIImage(data: data)
                        }
                    }
                
        }

    }
}

extension CryptoCollectionViewCell{
    func cryptoStyle(){
        firstStackView = UIStackView(arrangedSubviews: [cryptoName, cryptoPrice])
        firstStackView.axis = .horizontal
        firstStackView.spacing = 0
        firstStackView.distribution = .fillProportionally
        cryptoName.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cryptoPrice.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        cryptoPriceChange24h.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cryptoPriceChange24h.textColor = UIColor(red: 92/255, green: 200/255, blue: 134/255, alpha: 1.0)
        
        
        secondStackView = UIStackView(arrangedSubviews: [firstStackView, cryptoPriceChange24h])
        secondStackView.axis = .vertical
        secondStackView.distribution = .fill
        secondStackView.alignment = .center
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        cryptoPriceChange24h.translatesAutoresizingMaskIntoConstraints = false
        
        firstStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        secondStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        cryptoImage.contentMode = .scaleAspectFit
    }
    
    
    
    func cryptoLayout(){
        contentView.addSubview(secondStackView)
        contentView.addSubview(cryptoImage)
        
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        cryptoImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            cryptoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cryptoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cryptoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            cryptoImage.heightAnchor.constraint(equalToConstant: 40),
            cryptoImage.widthAnchor.constraint(equalToConstant: 40),
            
            secondStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            secondStackView.leadingAnchor.constraint(equalTo: cryptoImage.trailingAnchor, constant: 5),
            secondStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            secondStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            secondStackView.widthAnchor.constraint(equalToConstant: 100)
           
        ])
        
    }
    
    private func setupErrorLabel() {
            errorLabel.textColor = .red
            errorLabel.textAlignment = .center
            errorLabel.isHidden = true
            contentView.addSubview(errorLabel)
            
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                errorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                errorLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9)
            ])
        }
    
    func showError(message: String) {
            errorLabel.text = message
            errorLabel.isHidden = false
        }
}
