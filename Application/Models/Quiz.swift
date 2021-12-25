import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import EasyFirebaseSwift

public struct Quiz: FirestoreModel {

    public static let collectionName = "questions"

    @DocumentID public var ref: DocumentReference?
    @ServerTimestamp public var createdAt: Timestamp?
    @ServerTimestamp public var updatedAt: Timestamp?

    public var level: Level
    public var question: String
    public var selection: [Selection]
    public var answer: Selection
}

extension Quiz {
    public enum Level: Codable {
        case high
        case medium
        case low
    }

    public struct Selection: SubCollectionModel, Codable {
        public static var parentModelType: FirestoreModel.Type {
            Quiz.self
        }

        public static let collectionName = "selections"

        @DocumentID public var ref: DocumentReference?
        @ServerTimestamp public var createdAt: Timestamp?
        @ServerTimestamp public var updatedAt: Timestamp?

        public var text: String
    }
}
