//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Илья Волощик on 17.05.24.
//

import UIKit

private enum Keys: String {
    case token
}

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    private var token: String {
        get {
            guard let token = userDefaults.string(forKey: Keys.token.rawValue) else {
                return ""
            }
           return token
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    func setNewToken(token: String) {
        self.token = token
        print("Установлен Новый токен")
//        switchToTabBarController()
    }
    
    func getStorageToken() -> String? {
        let storageToken = self.token
        if storageToken.isEmpty {
            return nil
        }
        print("Из UD взят токен")
        return storageToken
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
