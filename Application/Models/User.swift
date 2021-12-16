//
//  User.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/12/16.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct User: Codable {

    static let collectionName = "users"

    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?

    public let auth: String
    public let displayName: String
}

extension User {
    public struct Progress: Codable {

        static let collectionName = "progresses"

        @DocumentID var id: String?
        @ServerTimestamp var createdAt: Timestamp?
        @ServerTimestamp var updatedAt: Timestamp?

        public let date: Date
        public let corrections: [String]
        public let mistakes: [String]
    }
}
