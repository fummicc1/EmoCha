//
//  GameViewModel.swift
//  EmoCha
//
//  Created by Fumiya Tanaka on 2021/10/19.
//

import Foundation
import Combine
import Vision

class GameViewModel: ObservableObject {
    private let smileJudge: SmileJudge

    var currentImageData: Data?

    init(smileJudge: SmileJudge = SmileJudgeImpl()) {
        self.smileJudge = smileJudge
    }

    func update(imageData: Data?) {
        currentImageData = imageData
        if let imageData = imageData {
            do {
                let level = try smileJudge.judge(source: imageData)
                print(level)
            } catch {
                print(error)
            }
        }
    }
}
