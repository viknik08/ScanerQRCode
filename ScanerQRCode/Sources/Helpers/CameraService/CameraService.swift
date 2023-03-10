//
//  CameraService.swift
//  ScanerQRCode
//
//  Created by Виктор Басиев on 10.03.2023.
//

import Foundation
import AVFoundation

protocol CameraServiceDelegat: AnyObject {
    func cameraServiceDismiss(_ cameraService: CameraService)
    func cameraServiceShowAlert(_ cameraService: CameraService)
    func cameraService(_ cameraService: CameraService, foundQRCode code: String)
}

protocol CameraServiceProtocol: AnyObject {
    
    var delegate: CameraServiceDelegat? { get set }
    var captureSession: AVCaptureSession? { get set }
    var previewLayer: AVCaptureVideoPreviewLayer? { get set }
    
    func cameraSettings()
    func getCaptureLayer() -> AVCaptureVideoPreviewLayer?
    func failed()
    func found(code: String)
}

class CameraService: NSObject, AVCaptureMetadataOutputObjectsDelegate, CameraServiceProtocol {

    weak var delegate: CameraServiceDelegat?

    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?

    func cameraSettings() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        captureSession = AVCaptureSession()
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if ((captureSession?.canAddInput(videoInput)) != nil) {
            captureSession?.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if ((captureSession?.canAddOutput(metadataOutput)) != nil) {
            captureSession?.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession ?? AVCaptureSession())
        previewLayer?.videoGravity = .resizeAspectFill
    }

    func getCaptureLayer() -> AVCaptureVideoPreviewLayer? {
        guard let previewLayer = previewLayer else { return nil }

        return previewLayer
    }

    func failed() {
        delegate?.cameraServiceShowAlert(self)
        captureSession = nil
    }


    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        delegate?.cameraServiceDismiss(self)
    }

    //MARK: - Work method

    func found(code: String) {
        DispatchQueue.main.async {
            self.delegate?.cameraService(self, foundQRCode: code)
        }
    }

    var prefersStatusBarHidden: Bool {
        return true
    }

//    var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
}

