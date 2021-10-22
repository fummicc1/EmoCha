//
//  StartPage.swift
//  EmoCha
//
//  Created by Fumiya Tanaka on 2021/10/17.
//

import SwiftUI

struct StartPage: View {

    @ObservedObject var viewModel: StartViewModel

    var body: some View {
        NavigationView {
            VStack {
                SWButton(text: "マッチングモード") {
                    viewModel.startMatching()
                }
            }
            .padding()
            .navigationTitle("EmoCha")
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct StartPage_Previews: PreviewProvider {
    static var previews: some View {
        StartPage(
            viewModel: StartViewModel(
                realtimeClient: realtimeClient
            )
        )
    }
}
