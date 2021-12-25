import SwiftUI
import Combine
import Application

class RootModel: ObservableObject {
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository

        authRepository.user
            .map({ $0 != nil })
            .assign(to: &$isLoggedIn)
    }

    private let authRepository: AuthRepository

    @Published var isLoggedIn: Bool = false
}
