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
    case getRoom
    case fulfillRoom
}

extension Events: Event {
    public var name: String {
        switch self {
        case .createRoom:
            return "create-room"
        case .getRoom:
            return "get-room"
        case .fulfillRoom:
            return "fulfill-room"
        }
    }
}
