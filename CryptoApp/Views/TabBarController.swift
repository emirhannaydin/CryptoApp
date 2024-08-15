//
//  CustomTabBarController.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 14.08.2024.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController {

    let marketVC = MarketViewController()
    let favoriteVC = FavoritesViewController()
    let accountVC = AccountViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userStatus()
        style()
        configureTabBar()
    }
    
}

extension TabBarController{
    private func style(){
        viewControllers = [configureViewController(rootViewController: marketVC, title: "Market", image: "chart.xyaxis.line"),
                           configureViewController(rootViewController: favoriteVC, title: "Favorite", image: "star"),
                           configureViewController(rootViewController: accountVC, title: "Account", image: "person")]
    }
    
    private func layout(){
        
    }
    
    private func userStatus() {
        if Auth.auth().currentUser?.uid == nil {
            print("Kullanıcı yok")
            let loginScreenVC = UINavigationController(rootViewController: LoginViewController())
            loginScreenVC.modalPresentationStyle = .fullScreen
            self.present(loginScreenVC, animated: true)
            
        } else {
            print("Kullanıcı var")
        }
    }
    
    private func signout(){
        do {
            try Auth.auth().signOut()
            let loginScreenVC = UINavigationController(rootViewController: LoginViewController())
            DispatchQueue.main.async {
                loginScreenVC.modalPresentationStyle = .fullScreen
                self.present(loginScreenVC, animated: true)
            }
            
            
        } catch {
            print("Çıkış yaparken hata oluştu")
        }
    }
    
    private func configureViewController(rootViewController: UIViewController, title: String, image: String) -> UINavigationController{
        let controller = UINavigationController(rootViewController: rootViewController)
        controller.tabBarItem.title = title
        controller.tabBarItem.image = UIImage(systemName: image)
        return controller
    }
    
    private func configureTabBar(){
        
        self.tabBar.tintColor = .systemPink
        self.tabBar.unselectedItemTintColor = .darkGray
        let backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
                }
        self.tabBar.backgroundColor = backgroundColor
        self.tabBar.itemPositioning = .fill
    }
}

