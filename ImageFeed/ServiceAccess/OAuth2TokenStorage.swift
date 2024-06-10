//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Илья Волощик on 17.05.24.
//

import UIKit
import SwiftKeychainWrapper

private enum Keys: String {
    case token
}

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    private var token: String {
        get {
            guard let token: String = KeychainWrapper.standard.string(forKey: "Auth token") else {
                return ""
            }
            return token
        }
        
        set {
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: "Auth token")
            guard isSuccess else {
                print("не удалось сохранить токен в Keychain")
                return
            }
        }
    }
    
    func setNewToken(token: String) {
        self.token = token
        print("Установлен Новый токен в Keychain")
    }
    
    func getStorageToken() -> String? {
        let storageToken = self.token
        if storageToken.isEmpty {
            print("не удалось взять токен из Keychain")
            return nil
        }
        print("Из Keychain взят токен")
        return storageToken
    }
    
    func removeToken() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token")
        print("removeSuccessful \(removeSuccessful)")
    }
}
