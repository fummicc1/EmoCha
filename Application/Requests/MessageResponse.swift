//
//  MessageResponse.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/23.
//

import Foundation

public struct MessageResponse: Decodable {
    public init(message: String) {
        self.message = message
    }
    public let message: String
}
