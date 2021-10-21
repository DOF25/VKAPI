//
//  Posts.swift
//  Messenger
//
//  Created by Крылов Данила  on 21.09.2021.
//

import UIKit
import SwiftyJSON

struct Posts: Equatable {
    
    let sourceId: Int
    let date: Date
    let text: String?
    let comments: Int
    let likes: Int
    let photo: String?
    let photoHeight: Int?
    let photoWidth: Int?
    
    init(json: SwiftyJSON.JSON) {
        self.date = Date(timeIntervalSince1970: json["date"].doubleValue)
        self.sourceId = json["source_id"].intValue
        self.text = json["text"].stringValue
        let comments = json["comments"].dictionaryValue
        self.comments = comments["count"]?.intValue ?? 0
        let likes = json["likes"].dictionaryValue
        self.likes = likes["count"]?.intValue ?? 0
        let attachments = json["attachments"].arrayValue.first
        let photoDictionary = attachments?["photo"].dictionaryValue
        let sizes = photoDictionary?["sizes"]?.arrayValue
        let xSize = sizes?.first(where: { $0["type"].stringValue == "x"})
        self.photo = xSize?["url"].stringValue
        self.photoHeight = xSize?["height"].intValue
        self.photoWidth = xSize?["width"].intValue
    }
}
