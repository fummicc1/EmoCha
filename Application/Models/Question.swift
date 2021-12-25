import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public struct Question: Codable {

    static let collectionName = "questions"

    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?

    public let level: Level
    public let question: String
    public let selection: [Selection]
    public let answer: Selection
}

extension Question {
    public enum Level: Codable {
        case high
        case medium
        case low
    }

    public struct Selection: Codable {

        static let collectionName = "selections"

        @DocumentID var id: String?
        public let text: String
    }
}
