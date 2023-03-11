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
    init(view: ScanerViewProtocol, router: RouterProtocol, cameraService: CameraServiceProtocol, webView: WebView)
    
    func handleAppearigView()
    func handleDisappearigView()
    func runCapture()
    func test()
}

class ScanerPresenter: ScanerPresenterProtocol {

    weak var view: ScanerViewProtocol?
    var router: RouterProtocol?
    weak var cameraService: CameraServiceProtocol?
    var webView: WebView?
    
    required init(view: ScanerViewProtocol, router: RouterProtocol, cameraService: CameraServiceProtocol, webView: WebView) {
        self.view = view
        self.router = router
        self.cameraService = cameraService
        self.webView = webView
        cameraService.delegate = self
    }
    
    func test() {
        cameraService?.cameraSettings()
        let layer = cameraService?.getCaptureLayer()
        view?.addLayer(layer: layer)
        runCapture()
    }

    func runCapture() {
        DispatchQueue.global(qos: .background).async {
            self.cameraService?.captureSession?.startRunning()
        }
    }
    
    func handleAppearigView() {
        DispatchQueue.global(qos: .background).async {
            if (self.cameraService?.captureSession?.isRunning == false) {
                self.cameraService?.captureSession?.startRunning()
            }
        }
    }
    
    func handleDisappearigView() {
        DispatchQueue.global(qos: .background).async {
            if (self.cameraService?.captureSession?.isRunning == true) {
                self.cameraService?.captureSession?.stopRunning()
            }
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
        guard let webView = webView else { return }
        webView.urlText = code
        view?.pushTo(controller: webView)
    }
    
}
