//
//  StartInteractor.swift
//  Application
//
//  Created by Fumiya Tanaka on 2021/11/13.
//

import Foundation
import Combine
import APIClient

public protocol StartInteractor {
    func setupUser(socketId: String, uid: String?) -> AnyPublisher<Void, Error>
    func joinRoom(socketId: String) -> AnyPublisher<Void, Error>
}

public struct StartInteractorImpl {
    private let apiClient: APIClient

    public init(apiClient: APIClient = APIClientImpl()) {
        self.apiClient = apiClient
    }
}

extension StartInteractorImpl: StartInteractor {

    public func setupUser(socketId: String, uid: String?) -> AnyPublisher<Void, Error> {
        let request = SetupUserRequest(socketId: socketId, uid: uid)
        return apiClient.request(request: request)
            .map { response in
                print(response.message)
                return
            }
            .eraseToAnyPublisher()
    }

    public func joinRoom(socketId: String) -> AnyPublisher<Void, Error> {
        let request = JoinRoomRequest(
            socketId: socketId,
            roomCode: nil
        )
        return apiClient.request(request: request)
            .map { response in
                print(response.message)
                return
            }.eraseToAnyPublisher()
    }
}
