//
//  URLs.swift
//  Messenger
//
//  Created by Крылов Данила  on 20.08.2021.
//

import Foundation

enum URLs {

/// Friends list
    static let friendsList: String = "https://api.vk.com/method/friends.get?user_id=\(Session.shared.userID)&access_token=\(Session.shared.token)&order=name&fields=photo_200_orig&v=5.126"

/// Group list
    static let groupList: String = "https://api.vk.com/method/groups.get?user_id=\(Session.shared.userID)&access_token=\(Session.shared.token)&extended=1&v=5.126"

}
