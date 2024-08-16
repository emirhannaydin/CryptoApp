//
//  CustomLoginTextField.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit

class CustomTextField: UITextField {
    init(placeHolder: String, placeholderColor: UIColor){
        super.init(frame: .zero)
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        borderStyle = .none
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
