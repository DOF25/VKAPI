//
//  Builder.swift
//  Messenger
//
//  Created by Крылов Данила  on 16.09.2021.
//

import UIKit

final class Builder {

// MARK: - Public methods

    static func initializeFriendsViewController() -> UINavigationController {

        let friendsViewController = UINavigationController(rootViewController:
                                                            FriendsViewController(network: NetworkLayer()))
        return friendsViewController
    }

    static func initializeGroupsViewController() -> UINavigationController {

        let groupsViewController = UINavigationController(rootViewController:
                                                            GroupsController(network: NetworkLayer()))
        return groupsViewController
    }

    static func makeTabBarController() -> UITabBarController {

        let tabBarController = UITabBarController()

        tabBarController.setViewControllers([initializeFriendsViewController(), initializeGroupsViewController()],
                                            animated: false)
        guard let items = tabBarController.tabBar.items else { return UITabBarController() }
        items[0].image = UIImage(named: "friends-2")
        items[1].image = UIImage(named: "Groups-2")

        tabBarController.modalPresentationStyle = .fullScreen
        return tabBarController
    }

}
