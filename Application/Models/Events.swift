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
    case roomState

    case userState
    case setupUser
}

extension Events: Event {
    public var name: String {
        switch self {
        case .userState:
            return "user"
        case .setupUser:
            return "setup-user"
        case .createRoom:
            return "create-room"
        case .joinRoom:
            return "join-room"
        case .roomState:
            return "room"
        }
    }
}
