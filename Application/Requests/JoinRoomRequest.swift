//
//  JoinRoomRequest.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/27.
//

import Foundation
import APIClient

public struct JoinRoomRequest: Request {
    public init(socketId: String, roomCode: String?) {
        self.socketId = socketId
        self.roomCode = roomCode
    }

    public typealias Response = MessageResponse

    let socketId: String
    let roomCode: String?

    public var path: String = "/users/setup"
    public var method: APIClientImpl.Method = .post
    public var parameters: [String: Any] {
        [
            "socketId": socketId,
            "roomCode": roomCode as Any
        ]
    }
    public var headers: [String : String] {
        [
            "Content-Type": "application/json"
        ]
    }
}

