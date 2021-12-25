import Foundation
import EasyFirebaseSwift

public protocol UserRepository {
    func create(auth: String, displayName: String) async throws
    func update(user: User) async throws
    func fetch(id: String) async throws -> User
    func delete(user: User) async throws
}

public actor UserRepositoryImpl {    
    private let firestore: FirestoreClient

    public init(client: FirestoreClient = FirestoreClient()) {
        self.firestore = client
    }
}

extension UserRepositoryImpl: UserRepository {

    public func create(auth: String, displayName: String) async throws {
        let user = User(
            ref: nil,
            createdAt: nil,
            updatedAt: nil,
            auth: auth,
            displayName: displayName
        )
        try await firestore.create(user)
    }

    public func update(user: User) async throws {
        try await firestore.update(user)
    }

    public func fetch(id: String) async throws -> User {
        let user: User = try await firestore.get(uid: id)
        return user
    }

    public func delete(user: User) async throws {
        try await firestore.delete(user)
    }
    
}
