//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 13.05.24.
//

import UIKit

class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let webViewVC = WebViewViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
   func configureBackButton() {
       navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward")
       navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward")
       navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard 
                let webViewVC = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(showWebViewSegueIdentifier)")
                 }
            webViewVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        print("sdfdsfdsfdsf")
        dismiss(animated: true)
    }
    
    
}
