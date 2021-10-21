//
//  NetworkLayer.swift
//  Messenger
//
//  Created by Крылов Данила  on 20.08.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift
import PromiseKit
import Alamofire

protocol NetworkLayerProtocol: AnyObject {
    func fetchFriendsList()
//    func fetchGroupsList()
    func fetchPhotos(usersID: Int)
    func getFeed(completion: @escaping(Feed) -> Void)
}


final class NetworkLayer: NetworkLayerProtocol {

//MARK: - Network Layer Protocol
    func fetchFriendsList() {
        downloadJsonFriends(url: URLs.friendsList)
    }

//    func fetchGroupsList() {
//        downloadJsonGroups(url: URLs.groupList)
//    }

    func fetchPhotos(usersID: Int) {
        downloadFriendsPhoto(usersId: usersID)
    }

    func getFeed(completion: @escaping (Feed) -> Void) {
        getPosts(completion: completion)
    }



// MARK: - Private methods

    private func downloadJsonFriends(url: String) {

        guard let url = URL(string: url) else { return }

        let session = URLSession.shared

        session.dataTask(with: url) { data, response, error in
            do {
                guard let data = data else {return}
                let json = try JSON(data: data)
                let friendsJSON = json["response"]["items"].arrayValue
                let friendsList = friendsJSON.map { Users(json: $0)}
                self.saveFriendsList(friendsList)
            } catch {
                print(error)
            }

        } .resume()

    }

    /// Saving friends in data base
    private func saveFriendsList(_ friends: [Users]) {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: configuration)
            realm.beginWrite()
            print(realm.configuration.fileURL)
            realm.add(friends, update: .modified)
            try realm.commitWrite()

        } catch {
            print(error)
        }
    }

    /// Saving groups in data base
    private func saveGroupsList(_ groups: [Groups]) {
        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: configuration)
            realm.beginWrite()
            realm.add(groups, update: .modified)
            try realm.commitWrite()

        } catch {
            print(error)
        }
    }

// MARK: - Friends Photos
    
    private func downloadFriendsPhoto(usersId: Int) {

        let urlString = "https://api.vk.com/method/photos.getAll?access_token=\(Session.shared.token)&owner_id=\(usersId)&extended=1&v=5.131"

        guard let url = URL(string: urlString) else { return }

        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in

            guard let data = data else { return }
            do {
                let json = try JSON(data: data)
//                print(json)
                let photoJson = json["response"]["items"].arrayValue
                let photoList = photoJson.map { Photos(json: $0)}
                self.updateAndSafePhotosInRealm(newPhotos: photoList)
            } catch {
                print(error)
            }
        }.resume()

    }

/// saving photos in data base
    private func updateAndSafePhotosInRealm(newPhotos: [Photos]) {

        let configuration = Realm.Configuration.init(deleteRealmIfMigrationNeeded: true)
        do {
            let realm = try Realm(configuration: configuration)
            let photos = realm.objects(Photos.self)
            realm.beginWrite()
            realm.delete(photos)
            realm.add(newPhotos, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

// MARK: - Posts

    private func getPosts(completion: @escaping(Feed) -> Void) {

        let urlString = "https://api.vk.com/method/newsfeed.get?access_token=\(Session.shared.token)&filters=post&v=5.131"

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
