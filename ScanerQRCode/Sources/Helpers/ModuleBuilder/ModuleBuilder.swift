//
//  ModuleBuilder.swift
//  ScanerQRCode
//
//  Created by Виктор Басиев on 10.03.2023.
//

import UIKit

protocol ModuleBuilderProtocol {
    func createScanerModule(router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    func createScanerModule(router: RouterProtocol) -> UIViewController {
        let view = ScanerViewController()
        let cameraService = CameraService()
        let presenter = ScanerPresenter(view: view, router: router, cameraService: cameraService)
        view.presenter = presenter
        
        return view
    }

}
