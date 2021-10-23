//
//  SetupUserRequest.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/23.
//

import Foundation
import APIClient

public struct SetupUserRequest: Request {
    public init(socketId: String) {
        self.socketId = socketId
    }

    public typealias Response = MessageResponse

    let socketId: String

    public var path: String = "/users/setup"
    public var method: APIClientImpl.Method = .post
    public var parameters: [String: Any] {
        [
            "socketId": socketId
        ]
    }
    public var headers: [String : String] {
        [
            "Content-Type": "application/json"
        ]
    }
}
