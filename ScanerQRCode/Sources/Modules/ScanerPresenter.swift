//
//  ScanerPresenter.swift
//  ScanerQRCode
//
//  Created by Виктор Басиев on 10.03.2023.
//

import UIKit
import AVFoundation

protocol ScanerViewProtocol: AnyObject {
    func showAlert()
    func dismiss()
    func pushTo(controller: UIViewController)
    func addLayer(layer: AVCaptureVideoPreviewLayer?)
}

protocol ScanerPresenterProtocol: AnyObject {
    init(view: ScanerViewProtocol, router: RouterProtocol, cameraService: CameraServiceProtocol)
    
    func handleAppearigView()
    func handleDisappearigView()
    func runCapture()
    func test()
}

class ScanerPresenter: ScanerPresenterProtocol {

    weak var view: ScanerViewProtocol?
    var router: RouterProtocol?
    var cameraService: CameraServiceProtocol?
    
    required init(view: ScanerViewProtocol, router: RouterProtocol, cameraService: CameraServiceProtocol) {
        self.view = view
        self.router = router
        self.cameraService = cameraService
    }
    
    func test() {
        cameraService?.cameraSettings()
        let layer = cameraService?.getCaptureLayer()
        view?.addLayer(layer: layer)
        runCapture()
    }

    func runCapture() {
        cameraService?.captureSession?.startRunning()
    }

    func handleAppearigView() {
        if (cameraService?.captureSession?.isRunning == false) {
            cameraService?.captureSession?.startRunning()
        }
    }

    func handleDisappearigView() {
        if (cameraService?.captureSession?.isRunning == true) {
            cameraService?.captureSession?.stopRunning()
        }
    }

}

extension ScanerPresenter: CameraServiceDelegat {

    func cameraServiceDismiss(_ cameraService: CameraService) {
        view?.dismiss()
    }

    func cameraServiceShowAlert(_ cameraService: CameraService) {
        view?.showAlert()
    }

    func cameraService(_ cameraService: CameraService, foundQRCode code: String) {
        print(code)
        WebView.urlText = code
        view?.pushTo(controller: WebView())
    }
    
}
