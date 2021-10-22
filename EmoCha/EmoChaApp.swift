//
//  EmoChaApp.swift
//  EmoCha
//
//  Created by Fumiya Tanaka on 2021/10/17.
//

import SwiftUI
import RealtimeClient

let base = Secrets.api
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
