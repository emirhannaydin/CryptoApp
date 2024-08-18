//
//  CustomLoginImageView.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit

final class CustomLoginImageView: UIImageView{
    init(imageName: String){
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        image = UIImage(systemName: imageName )
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
