//
//  UsersNews.swift
//  Messenger
//
//  Created by Крылов Данила  on 23.09.2021.
//

import UIKit
import SwiftyJSON

struct UsersNews: Equatable {

    let firstName: String
    let lastName: String
    let photo: String
    let id: Int

    init(json: SwiftyJSON.JSON) {

        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = json["photo_50"].stringValue
        self.id = json["id"].intValue
    }
}
