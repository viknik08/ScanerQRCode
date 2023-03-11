//
//  WebView.swift
//  ScanerQRCode
//
//  Created by Виктор Басиев on 11.03.2023.
//

import UIKit
import WebKit
import SnapKit

class WebView: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    static var urlText: String = ""
    
    private var activityIndicatorContainer: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    let NSDateURL = NSData(contentsOf: URL(string: WebView.urlText)!)
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(webView)
        
        // Constraints
        webView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        setToolBar()
        sendRequest(urlString: WebView.urlText)
    }
    
    private func sendRequest(urlString: String) {
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    private func setActivityIndicator() {
        activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicatorContainer.center.x = webView.center.x
        activityIndicatorContainer.center.y = webView.center.y - 44
        activityIndicatorContainer.backgroundColor = UIColor.black
        activityIndicatorContainer.alpha = 0.8
        activityIndicatorContainer.layer.cornerRadius = 10
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicatorContainer.addSubview(activityIndicator)
        webView.addSubview(activityIndicatorContainer)
        
        // Constraints
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    private func setToolBar() {
        let screenWidth = self.view.bounds.width
        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(openAVC))
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.isTranslucent = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.items = [shareButton]
        webView.addSubview(toolBar)
        
        // Constraints
        toolBar.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(webView)
        }
    }
    
    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func openAVC() {
        let items: [Any] = [NSDateURL!]
        let activityViewController = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = doneSharingHandler
        activityViewController.popoverPresentationController?.sourceView = self.view
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc func doneSharingHandler(activityType: UIActivity.ActivityType?, completed: Bool, _ returnedItems: [Any]?, error: Error?) {
        let successAlert = UIAlertController(title: "Download success!", message: "Your data was successfully downloaded!", preferredStyle: .alert)
        let successButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        successAlert.addAction(successButton)
        
        let errorAlert = UIAlertController(title: "Oops!", message: "Somethings gone wrong! Your data was not downloaded =(", preferredStyle: .alert)
        let errorButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        errorAlert.addAction(errorButton)
        if completed {
            present(successAlert, animated: true)
        } else {
            present(errorAlert, animated: true)
        }
    }
  
    private func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicatorContainer.removeFromSuperview()
        }
    }
    
}

extension WebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.setActivityIndicator()
        self.showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.showActivityIndicator(show: false)
    }
    
}


