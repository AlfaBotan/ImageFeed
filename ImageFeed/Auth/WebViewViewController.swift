//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 13.05.24.
//

import UIKit
import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthView()
        updateProgress()
        startObserveOnLoadProgress()
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("не удалось создать urlComponents из WebViewConstants.unsplashAuthorizeURLString")
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]

        guard let url = urlComponents.url else {
            print("не удалось создать url из urlComponents")
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func startObserveOnLoadProgress() {
        estimatedProgressObservation = webView.observe(
                    \.estimatedProgress,
                     options: [.new],
                    changeHandler: { [weak self] _, _ in
                        guard let self = self else { return }
                        self.updateProgress()
                    })
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    @IBAction func tapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
         if let code = code(from: navigationAction) {
             print("CODE Acces")
             delegate?.webViewViewController(self, didAuthenticateWithCode: code)
             decisionHandler(.cancel)
          } else {
              print("CODE NOT Acces")
                decisionHandler(.allow)
          }
    }
    
     func code(from navigationAction: WKNavigationAction) -> String? {
         if
               let url = navigationAction.request.url,                         
               let urlComponents = URLComponents(string: url.absoluteString),
               urlComponents.path == "/oauth/authorize/native",
               let items = urlComponents.queryItems,
               let codeItem = items.first(where: { $0.name == "code" })
           {
               return codeItem.value
           } else {
               return nil
           }
    }
}



