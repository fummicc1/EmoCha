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
    @AppStorage("userName") var userName: String = "unknown"

    private var cancellables: Set<AnyCancellable> = []
    private let realtimeClient: RealtimeClient

    init(realtimeClient: RealtimeClient) {
        self.realtimeClient = realtimeClient
        self.me = Player(
            name: userName,
            currentFace: nil,
            opponentId: nil
        )
    }

    private func handleRealtimeEvent() {
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
