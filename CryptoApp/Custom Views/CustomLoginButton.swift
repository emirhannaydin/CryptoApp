//
//  CustomLoginButton.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit

class CustomLoginButton: UIButton {
    
    init(title: String, type: UIButton.ButtonType){
        super.init(frame: .zero)
        
        
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        layer.cornerRadius = 7
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
