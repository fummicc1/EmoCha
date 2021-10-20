//
//  Face.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/10/18.
//

import Foundation

public struct Face: Codable {
    public init(data: Data, smile: Double) {
        self.data = data
        self.smile = smile
        self.isSmile = smile > 0.5
    }

    public let data: Data
    public let smile: Double
    public let isSmile: Bool
}
