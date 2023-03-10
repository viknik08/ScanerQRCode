//
//  ScanerPresenter.swift
//  ScanerQRCode
//
//  Created by Виктор Басиев on 10.03.2023.
//

import Foundation

protocol ScanerViewProtocol: AnyObject {
    
}

protocol ScanerPresenterProtocol: AnyObject {
    init(view: ScanerViewProtocol, router: RouterProtocol)
}

class ScanerPresenter: ScanerPresenterProtocol {

    weak var view: ScanerViewProtocol?
    var router: RouterProtocol?
    
    required init(view: ScanerViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }

}