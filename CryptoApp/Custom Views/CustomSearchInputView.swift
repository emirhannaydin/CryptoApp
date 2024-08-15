//
//  AuthenticationInputView.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit

class CustomSearchInputView: UIView {
    init(image:UIImage, textField: UITextField){
        super.init(frame: .zero)
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.tintColor = UIColor.darkGray
        
        
        /*containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)*/
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        addSubview(imageView)
        addSubview(textField)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
