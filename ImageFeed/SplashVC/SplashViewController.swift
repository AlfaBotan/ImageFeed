//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 20.05.24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let storageToken = oAuth2TokenStorage.getStorageToken() {
            print("\(storageToken)")
            performSegue(withIdentifier: "profileOrGallaryIdentifire", sender: nil)
//            switchToTabBarController()
        } else {
            performSegue(withIdentifier: "logInOrUpFlowIdentifire", sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `window` приложения
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        // Создаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        performSegue(withIdentifier: "profileOrGallaryIdentifire", sender: nil)
//        switchToTabBarController()
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Проверим, что переходим на авторизацию
        if segue.identifier == "logInOrUpFlowIdentifire" {
            
            // Доберёмся до первого контроллера в навигации. Мы помним, что в программировании отсчёт начинается с 0?
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \("logInOrUpFlowIdentifire")")
                return
            }
            
            // Установим делегатом контроллера наш SplashViewController
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}
