//
//  Photos.swift
//  Messenger
//
//  Created by Крылов Данила  on 13.09.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class Photos: RealmSwift.Object{

    /// Photo ID
    @objc dynamic var id: Int = 0

    /// URL of Photo file
    @objc dynamic var url: String = ""

    convenience init(json: SwiftyJSON.JSON) {
        self.init()
        self.id = json["id"].intValue
        let sizes = json["sizes"].arrayValue.first
        self.url = sizes?["url"].stringValue ?? ""
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}
