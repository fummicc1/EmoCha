import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import EasyFirebaseSwift

public struct User: FirestoreModel {
    public static var collectionName: String = "users"

    @DocumentID public var ref: DocumentReference?
    @ServerTimestamp public var createdAt: Timestamp?
    @ServerTimestamp public var updatedAt: Timestamp?

    public var auth: String
    public var displayName: String
}

extension User {
    public struct Progress: Codable {

        public static let collectionName = "progresses"

        @DocumentID public var ref: DocumentReference?
        @ServerTimestamp public var createdAt: Timestamp?
        @ServerTimestamp public var updatedAt: Timestamp?

        public var date: Date
        public var corrections: [String]
        public var mistakes: [String]
    }
}
