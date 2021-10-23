//
//  APIClient.swift
//  APIClient
//
//  Created by Fumiya Tanaka on 2021/10/23.
//

import Combine
import Foundation
import Alamofire

public protocol Request {
    associatedtype Response: Decodable
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    var method: APIClientImpl.Method { get }
}

public protocol APIClient {
    func request<R>(request: R) -> AnyPublisher<R.Response, Error> where R: Request
}

public enum APIClientError: Error {
    case some(message: String?)
}

public struct APIClientImpl {
    public init() { }

    public enum Method {
        case get
        case post
        case put
        case delete

        var af: HTTPMethod {
            switch self {
            case .get:
                return .get
            case .post:
                return .post
            case .put:
                return .put
            case .delete:
                return .delete
            }
        }
    }
}

extension APIClientImpl: APIClient {

    public func request<R>(request: R) -> AnyPublisher<R.Response, Error> where R : Request {
        AF.request(
            "\(Secrets.api)/\(request.path)",
            method: request.method.af,
            parameters: request.parameters,
            headers: HTTPHeaders(request.headers)
        )
            .publishDecodable()
            .value()
            .mapError({ APIClientError.some(message: $0.errorDescription) })
            .eraseToAnyPublisher()
    }
}
