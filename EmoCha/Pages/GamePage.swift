//
//  GamePage.swift
//  EmoCha
//
//  Created by Fumiya Tanaka on 2021/10/17.
//

import SwiftUI

struct GamePage: View {

    @ObservedObject var viewModel: GameViewModel = GameViewModel()

    var body: some View {
        CameraView(cameraOutput: Binding(get: {
            viewModel.currentImageData
        }, set: { imageData in
            viewModel.update(imageData: imageData)
        }))
    }
}

struct GamePage_Previews: PreviewProvider {
    static var previews: some View {
        GamePage()
    }
}
