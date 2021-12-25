import SwiftUI
import Combine
import AVFoundation

public struct CameraView: UIViewControllerRepresentable {

    @Binding var cameraOutput: Data?

    public init(cameraOutput: Binding<Data?>) {
        self._cameraOutput = cameraOutput
    }

    public func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraController()
        controller.delegate = self
        let viewController = CameraViewController(cameraController: controller)
        return viewController
    }

    public func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {

    }
}

extension CameraView: CameraControllerDelegate {
    func didOutput(data: Data) {
        self.cameraOutput = data
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(cameraOutput: .constant(nil))
    }
}

private protocol CameraControllerDelegate {
    func didOutput(data: Data)
}

private class CameraController: NSObject {
    var session: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var videoOutput: AVCaptureVideoDataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var delegate: CameraControllerDelegate?

    let queue: DispatchQueue = DispatchQueue(label: "dev.fummicc1.EmoCha.CameraController")

    func prepare() throws {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            assertionFailure()
            return
        }
        let session = AVCaptureSession()
        let cameraInput = try AVCaptureDeviceInput(device: camera)
        if session.canAddInput(cameraInput) {
            session.addInput(cameraInput)
        }
        let cameraOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(cameraOutput) {
            session.addOutput(cameraOutput)
        }
        cameraOutput.setSampleBufferDelegate(self, queue: queue)

        self.frontCamera = camera
        self.frontCameraInput = cameraInput
        self.videoOutput = cameraOutput
        self.session = session
    }

    func startRunning() {
        session?.startRunning()
    }

    func setupPreview(on view: UIView) throws {
        guard let session = session else {
            assertionFailure()
            return
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)

        self.previewLayer = previewLayer
    }
}

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = sampleBuffer.imageBuffer else {
            return
        }
        let image = CIImage(cvImageBuffer: imageBuffer)
        guard let data = CIContext().jpegRepresentation(
            of: image,
            colorSpace: image.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
            options: [:]) else {
                return
            }
        delegate?.didOutput(data: data)
    }
}

public class CameraViewController: UIViewController {
    fileprivate init(cameraController: CameraController) {
        self.cameraController = cameraController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let cameraController: CameraController

    public override func viewDidLoad() {
        super.viewDidLoad()

        cameraController.queue.async {

            do {
                try self.cameraController.prepare()
                DispatchQueue.main.async {
                    do {
                        self.cameraController.startRunning()
                        try self.cameraController.setupPreview(on: self.view)
                    } catch {
                        assertionFailure(error.localizedDescription)
                    }
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }

        }
    }
}
