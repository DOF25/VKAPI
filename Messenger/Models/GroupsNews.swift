//
//  GroupsNews.swift
//  Messenger
//
//  Created by Крылов Данила  on 23.09.2021.
//

import UIKit
import SwiftyJSON

struct GroupsNews: Equatable {

    let id: Int
    let name: String
    let photo: String

    init(json: SwiftyJSON.JSON) {

        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo = json["photo_50"].stringValue
    }
}
