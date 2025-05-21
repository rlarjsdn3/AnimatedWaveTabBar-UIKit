//
//  SceneDelegate.swift
//  UIKitTemplate
//
//  Created by 김건우 on 4/4/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let firstViewController = FirstViewController()
        firstViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        let secondViewController = SecondViewController()
        secondViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        let thirdViewController = ThirdViewController()
        thirdViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        let fourthViewController = ThirdViewController()
        fourthViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear.fill")
        )
        let tabBarController = MyTabBarController()
        tabBarController.setViewControllers(
            [firstViewController, secondViewController, thirdViewController, fourthViewController],
            animated: false
        )
        tabBarController.tintColor = .label
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.33) {
            tabBarController.setTabBarHidden(true, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.33) {
                tabBarController.setTabBarHidden(false, animated: true)
            }
        }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

