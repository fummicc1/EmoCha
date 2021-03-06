//
//  RootView.swift
//  EmoCha
//
//  Created by Fumiya Tanaka on 2021/10/17.
//

import SwiftUI
import Application

struct RootView: View {
    var body: some View {
        StartPage(
            viewModel: StartViewModel(
                startInteractor: StartInteractorImpl(),
                realtimeClient: realtimeClient
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
