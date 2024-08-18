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
    
    func formatNumber(_ number: Double?) -> String {
        guard let number = number else { return "N/A" }

            let isNegative = number < 0
            let numberDouble = abs(number)

            var formattedNumber: String

            if numberDouble >= 1_000_000_000_000 {
                formattedNumber = String(format: "%.2fTr", numberDouble / 1_000_000_000_000)
            } else if numberDouble >= 1_000_000_000 {
                formattedNumber = String(format: "%.2fBn", numberDouble / 1_000_000_000)
            } else if numberDouble >= 1_000_000 {
                formattedNumber = String(format: "%.2fM", numberDouble / 1_000_000)
            } else if numberDouble >= 1_000 {
                formattedNumber = String(format: "%.2fK", numberDouble / 1_000)
            } else {
                formattedNumber = String(numberDouble)
            }

            if isNegative {
                formattedNumber = "-$\(formattedNumber)"
            }

            return formattedNumber
    }
}


