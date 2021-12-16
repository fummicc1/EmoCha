//
//  UserRepository.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/12/16.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol UserRepository {
    func save(user: User) async throws
    func get(id: String) async throws -> User
    func delete() async throws
}

public actor UserRepositoryImpl {    
    private let firestore: Firestore = Firestore.firestore()
}

extension UserRepositoryImpl: UserRepository {
    public func save(user: User) async throws {
    }

    public func get(id: String) async throws -> User {
        fatalError()
    }

    public func delete() async throws {
    }
    
}
