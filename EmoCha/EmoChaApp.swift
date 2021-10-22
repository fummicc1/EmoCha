//
//  EmoChaApp.swift
//  EmoCha
//
//  Created by Fumiya Tanaka on 2021/10/17.
//

import SwiftUI
import RealtimeClient

#if DEBUG
let base = "http://localhost:8080"
#else
let base = "https://8d92-2407-c800-3f12-1d-2485-9dda-294b-54af.ngrok.io"
#endif
let url = URL(string: base)!
let realtimeClient: RealtimeClient = RealtimeClientImpl(url: url)

@main
struct EmoChaApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
