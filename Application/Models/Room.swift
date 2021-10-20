//
//  Room.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/18.
//

import Foundation

public struct Room: Codable {
    public init(members: [Player], id: String) {
        self.members = members
        self.id = id
    }

    public var members: [Player]
    public let id: String
}
