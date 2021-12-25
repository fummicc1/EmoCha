import Foundation
import Combine
import FirebaseAuth
import AuthenticationServices
import EasyFirebaseSwift

public struct AuthUser {
    let uid: String
    let email: String?
    let displayName: String?
    let signedUpAt: Date?
    let loggedInAt: Date?
}

public protocol AuthRepository {
    var user: AnyPublisher<AuthUser?, Never> { get }
    var isLoggedIn: Bool { get }
    var userValue: AuthUser? { get }
    func signInWithApple() -> AnyPublisher<(token: String, nonce: String), Error>
    func signInWithCredential(token: String, nonce: String) -> AnyPublisher<AuthUser, Error>
    func linkWithCredential(token: String, nonce: String) -> AnyPublisher<AuthUser, Error>
    func delete() -> AnyPublisher<Void, Error>
    func signOut() -> AnyPublisher<Void, Error>
}

public class AuthRepositoryImpl: NSObject {

    private var cancellables: Set<AnyCancellable> = []

    public init(
        auth: FirebaseAuthClient = FirebaseAuthClient(),
        apple: AppleAuthClient = AppleAuthClient()
    ) {
        self.firAuth = auth
        self.auth = apple
        super.init()
        firAuth.user
            .replaceError(with: nil)
            .map { (user: FirebaseAuth.User?) -> AuthUser? in
                guard let user = user else {
                    return nil
                }
                let email: String?
                guard let userInfo = user.providerData.first(where: { $0.providerID == "apple.com" }) else {
                    return nil
                }
                email = userInfo.email
                let authUser = AuthUser(
                    uid: user.uid,
                    email: email,
                    displayName: user.displayName,
                    signedUpAt: user.metadata.creationDate,
                    loggedInAt: user.metadata.lastSignInDate
                )
                return authUser
            }
            .setFailureType(to: Never.self)
            .assign(to: \.value, on: userRelay)
            .store(in: &cancellables)
    }

    private let userRelay: CurrentValueSubject<AuthUser?, Never> = .init(nil)
    private let authorizationFlowSubject: CurrentValueSubject<(token: String?, nonce: String?), Never> = .init((nil, nil))

    private let auth: AppleAuthClient
    private let firAuth: FirebaseAuthClient


}

enum AuthRepositoryError: Swift.Error {
    case appleIdHasAlreadyLinkedWithOtherAccount
}

extension AuthRepositoryImpl: AuthRepository {

    public var isLoggedIn: Bool {
        firAuth.uid != nil
    }

    public var user: AnyPublisher<AuthUser?, Never> {
        userRelay.eraseToAnyPublisher()
    }

    public var userValue: AuthUser? {
        userRelay.value
    }

    public func signInWithApple() -> AnyPublisher<(token: String, nonce: String), Error> {
        auth.delegate = self
        auth.startSignInWithAppleFlow()
        return authorizationFlowSubject.compactMap({ auth -> (token: String, nonce: String)? in
            guard let nonce = auth.nonce else {
                return nil
            }
            guard let token = auth.token else {
                return nil
            }
            return (token, nonce)
        }).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    public func linkWithCredential(token: String, nonce: String) -> AnyPublisher<AuthUser, Error> {
        let credential = firAuth.getAppleCredential(idToken: token, nonce: nonce)
        return firAuth
            .link(with: credential)
            .mapError({ error in
                let error = error as NSError
                if error.code == 17025 {
                    let sendError = AuthRepositoryError.appleIdHasAlreadyLinkedWithOtherAccount
                    return sendError
                }
                return error
            })
            .map { user in
                let authuser = AuthUser(
                    uid: user.uid,
                    email: user.email,
                    displayName: user.displayName,
                    signedUpAt: user.metadata.creationDate,
                    loggedInAt: user.metadata.lastSignInDate
                )
                self.userRelay.send(authuser)
                return authuser
            }.eraseToAnyPublisher()
    }

    public func signInWithCredential(token: String, nonce: String) -> AnyPublisher<AuthUser, Error> {
        firAuth.signInWithApple(idToken: token, nonce: nonce).map { user in
            let authuser = AuthUser(
                uid: user.uid,
                email: user.email,
                displayName: user.displayName,
                signedUpAt: user.metadata.creationDate,
                loggedInAt: user.metadata.lastSignInDate
            )
            self.userRelay.send(authuser)
            return authuser
        }.eraseToAnyPublisher()
    }

    public func delete() -> AnyPublisher<Void, Error> {
        firAuth.delete()
    }

    public func signOut() -> AnyPublisher<Void, Error> {
        firAuth.signOut()
    }
}

extension AuthRepositoryImpl: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        #if DEBUG
        print(error)
        #endif
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let nonce = auth.currentNonce,
              let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let token = String(data: tokenData, encoding: .utf8) else {
            return
        }
        authorizationFlowSubject.send((token, nonce))
    }
}
