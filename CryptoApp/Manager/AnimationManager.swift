//
//  AnimationManager.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 17.08.2024.
//

import UIKit
import Lottie

class AnimationManager {

    static func showAnimation(on viewController: UIViewController, animationName: String, completion: @escaping () -> Void) {
        let animationView = LottieAnimationView(name: animationName)
        animationView.frame = viewController.view.bounds
        
        let backgroundView = UIView(frame: viewController.view.bounds)
        backgroundView.backgroundColor = UIColor.systemBackground
        backgroundView.alpha = 1.0
        
        if let tabBarController = viewController.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
        
        viewController.view.addSubview(backgroundView)
        viewController.view.addSubview(animationView)
        
        // Animasyon süresini 1 saniye olarak ayarla
        let fixedAnimationDuration: TimeInterval = 1.0
        let animationDuration = animationView.animation?.duration ?? 0

        // Animasyonun 1. saniyesinden başlayarak 1 saniye süresince oynatılacak şekilde ayarla
        let progressStart = 1.0 / animationDuration
        let progressEnd = min((1.0 + fixedAnimationDuration) / animationDuration, 1.0)
        
        animationView.play(fromProgress: CGFloat(progressStart), toProgress: CGFloat(progressEnd)) { finished in
            if finished {
                animationView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                if let tabBarController = viewController.tabBarController {
                    tabBarController.tabBar.isHidden = false
                }
                completion()
            }
        }
    }
}

