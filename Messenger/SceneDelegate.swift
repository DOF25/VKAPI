//
//  SceneDelegate.swift
//  Messenger
//
//  Created by Крылов Данила  on 18.08.2021.
//

import UIKit

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        window = UIWindow(frame: UIScreen.main.bounds)

        let viewController = VKLoginViewController()

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window?.windowScene = windowScene
    }
}

