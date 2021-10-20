//
//  Event.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/19.
//

import Foundation
import RealtimeClient

public enum Events {
    case createRoom
    case joinRoom
    case getRoomState
    case fulfillRoom
}

extension Events: Event {
    public var name: String {
        switch self {
        case .createRoom:
            return "create-room"
        case .joinRoom:
            return "join-room"
        case .getRoomState:
            return "get-room-state"
        case .fulfillRoom:
            return "fulfill-room"
        }
    }
}
