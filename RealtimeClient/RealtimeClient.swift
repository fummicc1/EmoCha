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
    var onUpdateSocketId: AnyPublisher<String, Never> { get }
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
    private let socketIdSubject: PassthroughSubject<String, Never> = PassthroughSubject()
    private var subjects: [PassthroughSubject<RealtimeData, Never>] = []
    private let error: PassthroughSubject<Error, Never> = PassthroughSubject()

    public init(url: URL) {
        self.manager = SocketManager(
            socketURL: url,
            config: [.log(true), .compress]
        )
        self.socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { [weak self] data, _ in
            print("connect")
            guard let info = data[1] as? [String: String], let sid = info["sid"] else {
                assertionFailure()
                return
            }
            self?.socketIdSubject.send(sid)
        }
    }
}

extension RealtimeClientImpl: RealtimeClient {

    public var onUpdateSocketId: AnyPublisher<String, Never> {
        socketIdSubject.eraseToAnyPublisher()
    }

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
