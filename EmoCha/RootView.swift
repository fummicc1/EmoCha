//
//  RootView.swift
//  EmoCha
//
//  Created by Fumiya Tanaka on 2021/10/17.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        StartPage(viewModel: StartViewModel(realtimeClient: realtimeClient))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
