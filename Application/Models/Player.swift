//
//  Player.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/18.
//

import Foundation

public struct Player: Codable {
    public init(name: String, currentFace: Face? = nil, opponentId: String? = nil) {
        self.name = name
        self.currentFace = currentFace
        self.opponentId = opponentId
    }

    public let name: String
    public var currentFace: Face?
    public var opponentId: String?
}
