//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 20.05.24.
//

import UIKit

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let storageToken = oAuth2TokenStorage.getStorageToken() {
            print("""
                    SplashViewController  viewDidAppear
                  \(storageToken)
                    SplashViewController  viewDidAppear

                  """)
            fetchProfile(token: storageToken)
        } else {
            print("""
                  SplashViewController  viewDidAppear
                  нет токена
                  SplashViewController  viewDidAppear

                  """)
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
        print("Сработал метод didAuthenticate") 
        switchToTabBarController()
    }
    
//    func fetchProfileImageURL(username: String) {
//        profileImageService.fetchProfileImageURL(username: username) { _ in}
//    }
    
    func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                profileImageService.fetchProfileImageURL(username: (profileService.profile?.username)!) { result in
                    switch result {
                    case .success(let string):
                        print("""
                                      func fetchProfile(token: String)
                              \(string)
                                  func fetchProfile(token: String)
                              """)
                    case .failure(_):
                        print("что-то не так")
                    }
                }
                self.switchToTabBarController()
            case .failure(_):
                print("ошибка из функции fetchProfile в SplashVC")
                break
            }
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logInOrUpFlowIdentifire" {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \("logInOrUpFlowIdentifire")")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}
