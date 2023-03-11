//
//  ScanerViewController.swift
//  ScanerQRCode
//
//  Created by Виктор Басиев on 07.03.2023.
//

import UIKit
import AVFoundation

class ScanerViewController: UIViewController {

    var presenter: ScanerPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.handleAppearigView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.test()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.handleDisappearigView()
    }

}

//MARK: - Extension
extension ScanerViewController: ScanerViewProtocol {
    
    func addLayer(layer: AVCaptureVideoPreviewLayer?) {
        guard let layer = layer else { return }
        view.layer.addSublayer(layer)
        layer.frame = view.layer.bounds
    }

    func pushTo(controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    func showAlert() {
        let ac = UIAlertController(title: "Scanning not supported",
                                   message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

