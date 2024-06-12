//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Илья Волощик on 4.06.24.
//

import Foundation
import WebKit
import Kingfisher

final class ProfileLogoutService {
    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imageListService = ImagesListService.shared
    
    
    static let shared = ProfileLogoutService()
    private init() {}
    
    func logout() {
        cleanCookies()
    }
    
    private func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        profileService.removeData()
        profileImageService.removeData()
        imageListService.removeData()
        tokenStorage.removeToken()
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
