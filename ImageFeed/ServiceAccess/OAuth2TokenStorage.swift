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
            guard let data = userDefaults.data(forKey: Keys.token.rawValue),
                  let token = try? JSONDecoder().decode(String.self, from: data) else {
                return ""
            }
           return token
        }
        
        set {
            guard let token = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(token, forKey: Keys.token.rawValue)
        }
    }
    
    func setNewToken(token: String) {
        self.token = token
    }
    
    func getStorageToken() -> String? {
        let storageToken = self.token
        if storageToken.isEmpty {
            return nil
        }
        return storageToken
    }
}
