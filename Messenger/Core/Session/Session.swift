//
//  Session.swift
//  Messenger
//
//  Created by Крылов Данила  on 20.08.2021.
//

import Foundation

final class Session {

    static let shared = Session()
    var token = ""
    var userID = ""

    private init() { }
}
