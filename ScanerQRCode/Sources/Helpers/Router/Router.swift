//
//  Router.swift
//  ScanerQRCode
//
//  Created by Виктор Басиев on 10.03.2023.
//

import UIKit

protocol MainRouterProtocol {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: ModuleBuilderProtocol? { get set }
}

protocol RouterProtocol: MainRouterProtocol {
    func initialController()
    
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var moduleBuilder: ModuleBuilderProtocol?
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
    func initialController() {
        if let navigationController = navigationController {
            guard let scanerView = moduleBuilder?.createScanerModule(router: self) else { return }
            navigationController.viewControllers = [scanerView]
        }
        
    }

}
