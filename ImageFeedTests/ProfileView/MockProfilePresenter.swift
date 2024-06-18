//
//  MockProfilePresenter.swift
//  ImageFeedTests
//
//  Created by Илья Волощик on 16.06.24.
//

import ImageFeed
import UIKit

final class MockProfilePresenter: ProfilePresenterProtocol {
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    var viewDidLoadCalled: Bool = false
    let logoutService = ProfileLogoutServiceSpy()
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() {
        guard let mockImage = UIImage(named: "11") else {return}
        view?.installNewValueForAvatar(image: mockImage)
    }
    
    func LogoutProfile() {
        logoutService.logout()
    }
}
