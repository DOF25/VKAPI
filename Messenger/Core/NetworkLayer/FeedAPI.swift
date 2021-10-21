//
//  FeedAPI.swift
//  Messenger
//
//  Created by Крылов Данила  on 12.10.2021.
//

import Foundation
import SwiftyJSON

final class FeedAPI {

    static let shared = FeedAPI()

    private init() {}

//MARK: - Posts' refresher

    func get(startTime: TimeInterval? = nil, startFrom: String? = nil, completion: @escaping(Feed) -> Void) {

        var urlString = ""

        if startTime != nil {
            guard let startTime = startTime else { return }
            urlString = "https://api.vk.com/method/newsfeed.get?access_token=\(Session.shared.token)&filters=post&v=5.131&start_time=\(startTime)"
        }

        if startFrom != nil {
            guard let startFrom = startFrom else { return }
            urlString = "https://api.vk.com/method/newsfeed.get?access_token=\(Session.shared.token)&filters=post&v=5.131&start_from=\(startFrom)"
        }

        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared

            session.dataTask(with: url) { data, response, error in

                let dispatchGroup = DispatchGroup()

                var postsArray = [Posts]()
                var usersArray = [UsersNews]()
                var groupsArray = [GroupsNews]()
                var startFrom = ""

                if let data = data {
                    do {
                        let json = try JSON(data: data)

                        DispatchQueue.global().async(group: dispatchGroup) {

                        let nextFrom = json["response"]["next_from"].stringValue
                        let postsJson = json["response"]["items"].arrayValue
                        let posts = postsJson.map { Posts(json: $0) }
                        postsArray = posts
                        startFrom = nextFrom

                        }
                        DispatchQueue.global().async(group: dispatchGroup) {

                            let groupsJson = json["response"]["groups"].arrayValue
                            let groups = groupsJson.map { GroupsNews(json: $0) }
                            groupsArray = groups
                        }
                        DispatchQueue.global().async(group: dispatchGroup) {

                            let usersJson = json["response"]["profiles"].arrayValue
                            let users = usersJson.map { UsersNews(json: $0) }
                            usersArray = users
                        }

                        dispatchGroup.notify(queue: DispatchQueue.main) {
                            let feed = Feed(users: usersArray,
                                            groups: groupsArray,
                                            posts: postsArray,
                                            startFrom: startFrom)
                            completion(feed)
                        }

                    } catch {
                        print(error)
                    }

                    if let error = error {
                        print(error)
                    }
                }
            }.resume()

    }
}
