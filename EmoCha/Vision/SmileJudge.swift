//
//  SmileJudge.swift
//  Vision
//
//  Created by Fumiya Tanaka on 2021/10/19.
//

import Foundation
import opencv2

protocol SmileJudge {
    func judge(source: Data) throws -> Double
}

enum SmileJudgeError: Error {
    case invalidImageData
}

class SmileJudgeImpl {

    private let smileCascadeClassifierPath = Bundle.main.path(forResource: "haarcascade_smile", ofType: "xml")!
    private let faceCascadeClassifierPath = Bundle.main.path(forResource: "haarcascade_frontalface_default", ofType: "xml")!

    init() { }
}

extension SmileJudgeImpl: SmileJudge {
    func judge(source: Data) throws -> Double {
        guard let image = UIImage(data: source) else {
            throw SmileJudgeError.invalidImageData
        }
        let mat = Mat(uiImage: image)
        let faceCascade = CascadeClassifier(filename: faceCascadeClassifierPath)
        let smileCascade = CascadeClassifier(filename: smileCascadeClassifierPath)
        let mfaces: NSMutableArray = []
        faceCascade.detectMultiScale(image: mat, objects: mfaces)
        var faces = mfaces as NSArray as? [Rect2i] ?? []
        faces.sort(by: { $0.area() > $1.area() })
        guard let face = faces.first else {
            print("No faces detected")
            return 0
        }
        let facex = max(0, face.x)
        let facemx = min(mat.width(), face.x + face.width)
        let facey = max(0, face.y + face.height / 2)
        let facemy = min(mat.height(), face.y + face.height)
        let faceMat = mat.submat(
            rowRange: Range(start: facey, end: facemy),
            colRange: Range(start: facex, end: facemx)
        )
        let msmiles: NSMutableArray = []
        smileCascade.detectMultiScale(image: faceMat, objects: msmiles)
        let smiles = msmiles as NSArray as? [Rect2i] ?? []
        return min(1, Double(smiles.count) * 0.25)
    }
}
