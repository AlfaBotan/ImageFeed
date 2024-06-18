//
//  LogoutServiceSpy.swift
//  ImageFeedTests
//
//  Created by Илья Волощик on 18.06.24.
//

import ImageFeed
import UIKit

final class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
    var logoutCalled: Bool = false
    
    func logout() {
        logoutCalled = true
    }
}
