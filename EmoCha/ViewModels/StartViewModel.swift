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

    init(realtimeClient: RealtimeClient) {
        self.realtimeClient = realtimeClient
    }

    func onAppear() {
        realtimeClient.connect()
        
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

        let setupUser: [String: Any] = [
            "uid": uid
        ]
        realtimeClient.emit(event: Events.setupUser, value: setupUser)
    }

    func startMatching() {
        state = .matching
        realtimeClient.connect()

        realtimeClient.emit(
            event: Events.joinRoom,
            value: []
        )
    }
}
