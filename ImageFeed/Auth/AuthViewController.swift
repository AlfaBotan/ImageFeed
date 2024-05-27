//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 13.05.24.
//

import UIKit
import WebKit
import ProgressHUD

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let webViewVC = WebViewViewController()
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
  private func configureBackButton() {
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
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                print("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
                 }
            webViewVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success(let token):
                print("""
                          func webViewViewController(
                      \(token)
                          func webViewViewController(
                      """)
                self.oAuth2TokenStorage.setNewToken(token: token)
                self.delegate?.didAuthenticate(self)
            case .failure(_):
                print("ошибка из функции webViewViewController")
                self.showAlert()
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
