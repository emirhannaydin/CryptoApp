//
//  SplashScreenViewController.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 17.08.2024.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        animationView = LottieAnimationView(name: "lottie")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFill
        view.addSubview(animationView!)
        animationView?.play { [weak self] (finished) in
            if finished {
                self?.showMainApp()
            }
        }
    }
    
    private func showMainApp() {
        let viewController = UINavigationController(rootViewController: TabBarController())
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
        }
    }
    
}
