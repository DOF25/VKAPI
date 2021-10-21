//
//  Groups.swift
//  Messenger
//
//  Created by Крылов Данила  on 22.08.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Groups: RealmSwift.Object {

    @objc dynamic var name: String = ""
    @objc dynamic var groupAvatar: String = ""
    @objc dynamic var id: Int = 0

    convenience init(json: SwiftyJSON.JSON){
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.groupAvatar = json["photo_100"].stringValue
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    
}
