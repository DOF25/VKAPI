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
        friendsViewController.title = "Мои друзья"
        return friendsViewController
    }

    static func initializeGroupsViewController() -> UINavigationController {

        let groupsViewController = UINavigationController(rootViewController:
                                                            GroupsController())
        groupsViewController.title = "Мои группы"
        return groupsViewController

    }

    static func initializeNewsController() -> UINavigationController {

        let newsController = UINavigationController(rootViewController: NewsController(network: NetworkLayer()))

        newsController.title = "Новости"
        return newsController

    }

    static func makeTabBarController() -> UITabBarController {

        let tabBarController = UITabBarController()

        tabBarController.setViewControllers([initializeFriendsViewController(), initializeGroupsViewController(), initializeNewsController()],
                                            animated: false)
        guard let items = tabBarController.tabBar.items else { return UITabBarController() }
        items[0].image = UIImage(named: "friends-2")
        items[1].image = UIImage(named: "Groups-2")
        items[2].image = UIImage(systemName: "heart.fill")

        tabBarController.modalPresentationStyle = .fullScreen
        return tabBarController
    }

}
