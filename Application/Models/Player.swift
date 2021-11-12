//
//  Player.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/18.
//

import Foundation

public struct Player: Codable {
    public init(uid: String, name: String, currentFace: Face? = nil, pairId: String? = nil) {
        self.uid = uid
        self.name = name
        self.currentFace = currentFace
        self.pairId = pairId
    }

    public let uid: String
    public let name: String
    public var currentFace: Face?
    public var pairId: String?
}
