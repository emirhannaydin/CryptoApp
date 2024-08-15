//
//  Extensions.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit
import JGProgressHUD

extension UIViewController{
    func backgroundGradientColor(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemCyan.cgColor, UIColor.systemMint.cgColor]
        gradient.locations = [0,1]
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
    }
    
    func showHud(show: String,detailShow: String, delay: Double){
        view.endEditing(true)
        let jgProgressHud = JGProgressHUD(style: .dark)
        jgProgressHud.textLabel.text = show
        jgProgressHud.detailTextLabel.text = detailShow
        jgProgressHud.show(in: view)
        jgProgressHud.dismiss(afterDelay: delay)
        
    }
}
