//
//  Users.swift
//  Messenger
//
//  Created by Крылов Данила  on 20.08.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift

final class Users: Object {

    /// ID
    @objc dynamic var id: Int = 0
    /// Имя
    @objc dynamic var firstName: String = ""
    /// Фамилия
    @objc dynamic var lastName: String = ""
    /// Аватарка пользователя
    @objc dynamic var avatar: String = ""

//MARK: - Convenience init
    convenience init(json: SwiftyJSON.JSON) {
        self.init()

        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatar = json["photo_200_orig"].stringValue
    }

//MARK: - Setting primary key

    override class func primaryKey() -> String? {
        return "id"
    }

}
