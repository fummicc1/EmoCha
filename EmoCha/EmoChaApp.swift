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
let base = ""
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
