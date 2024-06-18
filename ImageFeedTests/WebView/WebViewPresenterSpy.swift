//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Илья Волощик on 12.06.24.
//
import ImageFeed
import UIKit

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        let url: URL = URL(string: "https://api.unsplash.com")!
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
    
    
}
