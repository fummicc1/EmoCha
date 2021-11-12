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
import APIClient
import RealtimeClient

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
    private let interactor: StartInteractor
    private let realtimeClient: RealtimeClient
    private var socketId: String? = nil

    init(startInteractor: StartInteractor, realtimeClient: RealtimeClient) {
        self.interactor = startInteractor
        self.realtimeClient = realtimeClient

        realtimeClient.onUpdateSocketId
            .setFailureType(to: Error.self)
            .flatMap { socketId -> AnyPublisher<Void, Error> in
                self.socketId = socketId
                return self.interactor.setupUser(socketId: socketId, uid: "nil")
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: { })
            .store(in: &cancellables)

        realtimeClient.listen(event: Events.roomState)
            .sink { room in
                print(room)
            }
            .store(in: &cancellables)

        realtimeClient.listen(event: Events.playerState)
            .sink { player in
                print(player)
            }
            .store(in: &cancellables)
    }

    func startMatching() {
        guard let socketId = socketId else {
            assertionFailure()
            return
        }
        state = .matching
        interactor.joinRoom(socketId: socketId)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            } receiveValue: { }
            .store(in: &cancellables)
    }
}
