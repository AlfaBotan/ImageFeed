//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 20.05.24.
//

import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token")
//        print("removeSuccessful \(removeSuccessful)")
        configurationUI()
    }
    
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
            switchToAuthViewController()
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        dismiss(animated: true)
        print("Сработал метод didAuthenticate")
    }
    
    func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                guard let userName = profileService.profile?.username else {
                    print("не получили имя пользователя для загрузки аватарки")
                    return
                }
                profileImageService.fetchProfileImageURL(username: userName) { result in
                    switch result {
                    case .success(let string):
                        print("""
                                      func fetchProfile(token: String)
                              \(string)
                                  func fetchProfile(token: String)
                              """)
                    case .failure(_):
                        print("что-то не так в func fetchProfile(token: String)")
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
    private func switchToAuthViewController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            print("Не удалось создать AuthViewController")
            fatalError("Invalid Configuration")
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
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

extension SplashViewController {
    // MARK: - Верстка кодом
    
    private func configurationUI() {
        view.backgroundColor = .ypBlack
        let imageView: UIImageView = UIImageView(image: UIImage(named: "LaunchScreen"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}


