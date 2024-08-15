//
//  SceneDelegate.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 6.08.2024.
//

import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        //let viewController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }
    
    /*func createMainViewController() -> UINavigationController{
        let controller = MainViewController()
        //controller.title = "Market"
        controller.tabBarItem = UITabBarItem(title: "Market", image: UIImage(systemName: "chart.xyaxis.line"), tag: 0)

        return UINavigationController(rootViewController: controller)
    }
    func createFavoritesViewController() -> UINavigationController{
        let controller = FavoritesViewController()
        //controller.title = "Favorites"
        controller.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)

        return UINavigationController(rootViewController: controller)
    }
    func createAccountViewController() -> UINavigationController{
        let controller = AccountViewController()
        //controller.title = "Account"
        controller.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person"), tag: 2)

        return UINavigationController(rootViewController: controller)
    }
    
    func createTabBar() -> UITabBarController{
        let tabbar = UITabBarController()
        
        tabbar.tabBar.tintColor = .systemPink
        tabbar.tabBar.unselectedItemTintColor = .systemGray
        tabbar.tabBar.layer.backgroundColor = UIColor.white.cgColor
        tabbar.viewControllers = [createMainViewController(),createFavoritesViewController(),createAccountViewController()]
        return tabbar
    }
*/
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

