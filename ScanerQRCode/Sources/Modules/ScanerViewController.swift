//
//  ScanerViewController.swift
//  ScanerQRCode
//
//  Created by Виктор Басиев on 07.03.2023.
//

import UIKit

class ScanerViewController: UIViewController {

    var presenter: ScanerPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

//MARK: - Extension
extension ScanerViewController: ScanerViewProtocol {
    
}
