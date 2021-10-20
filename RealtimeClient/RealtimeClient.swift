//
//  RealtimeClient.swift
//  RealtimeClient
//
//  Created by Fumiya Tanaka on 2021/10/18.
//

import Foundation
import SocketIO
import Combine

public typealias RealtimeData = SocketData

public protocol RealtimeClient {
    var onError: AnyPublisher<Error, Never> { get }
    func connect()
    func disconnect()
    func emit<E: Event>(event: E, value: RealtimeData)
    func listen<E: Event>(event: E) -> AnyPublisher<RealtimeData, Never>
}

public protocol Event {
    var name: String { get }
}

public class RealtimeClientImpl {

    private let manager: SocketManager
    private let socket: SocketIOClient
    private var subjects: [PassthroughSubject<RealtimeData, Never>] = []
    private let error: PassthroughSubject<Error, Never> = PassthroughSubject()

    public init(url: URL) {
        self.manager = SocketManager(
            socketURL: url,
            config: [.log(true), .compress]
        )
        self.socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { _, _ in
            print("connect")
        }

        socket.on(clientEvent: .error) { data, a in
            print(data)
            if let error = data as? Error {
                self.error.send(error)
            }
        }
    }
}

extension RealtimeClientImpl: RealtimeClient {

    public var onError: AnyPublisher<Error, Never> {
        error.eraseToAnyPublisher()
    }

    public func connect() {
        socket.connect()
    }

    public func disconnect() {
        socket.disconnect()
    }

    public func emit<E>(event: E, value: RealtimeData) where E : Event {
        socket.emit(event.name, value)
    }

    public func listen<E>(event: E) -> AnyPublisher<RealtimeData, Never> where E : Event {
        let subject = PassthroughSubject<RealtimeData, Never>()
        socket.on(event.name) { response, _ in
            for value in response.compactMap({ $0 as? RealtimeData }) {
                subject.send(value)
            }
        }
        subjects.append(subject)
        return subject.eraseToAnyPublisher()
    }
}
