//
//  Event.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/19.
//

import Foundation

public enum Events {
    case roomState
    case playerState
}

extension Events: Event {
    public var name: String {
        switch self {
        case .playerState:
            return "player"
        case .roomState:
            return "room"
        }
    }
}
