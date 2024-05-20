//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 13.05.24.
//

import UIKit
import WebKit

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let webViewVC = WebViewViewController()
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    var delegate: AuthViewControllerDelegate?
    
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
        vc.dismiss(animated: true)
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                print("\(token)")
                self.oAuth2TokenStorage.setNewToken(token: token)
                self.delegate?.didAuthenticate(self)
            case .failure(_):
                print("ошибка из функции webViewViewController")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
