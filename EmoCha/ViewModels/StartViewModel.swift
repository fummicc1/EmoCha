//
//  StartViewModel.swift
//  EmoCha
//
//  Created by Fumiya Tanaka on 2021/10/19.
//

import Foundation
import Combine
import Application
import SwiftUI
import RealtimeClient
import APIClient

enum MatchingState {
    case prepare
    case matching
    case found
    case ready
}

class StartViewModel: ObservableObject {

    @Published var state: MatchingState = .prepare
    @Published var room: Room?
    @Published var me: Player?
    @AppStorage("uid") var uid: String?

    private var cancellables: Set<AnyCancellable> = []
    private let realtimeClient: RealtimeClient
    private let apiClient: APIClient
    private var socketId: String? = nil

    init(realtimeClient: RealtimeClient, apiClient: APIClient = APIClientImpl()) {
        self.realtimeClient = realtimeClient
        self.apiClient = apiClient

        realtimeClient.onUpdateSocketId
            .setFailureType(to: Error.self)
            .flatMap { socketId -> AnyPublisher<SetupUserRequest.Response, Error> in
                self.socketId = socketId
                let request = SetupUserRequest(socketId: socketId)
                return apiClient.request(request: request)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                print(response.message)
            })
            .store(in: &cancellables)

        realtimeClient.listen(event: Events.roomState)
            .sink { data in
                print(data)
            }
            .store(in: &cancellables)

        realtimeClient.listen(event: Events.userState)
            .sink { data in
                print(data)
            }
            .store(in: &cancellables)
    }

    func startMatching() {
        guard let socketId = socketId else {
            assertionFailure()
            return
        }
        state = .matching
        let request = JoinRoomRequest(
            socketId: socketId,
            roomCode: nil
        )
        apiClient.request(request: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: { response in
                print(response.message)
            }
            .store(in: &cancellables)
    }
}
