//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Илья Волощик on 13.06.24.
//

import UIKit
import Kingfisher

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func LogoutProfile()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    weak var view: (any ProfileViewControllerProtocol)?

    private let profileLogoutService = ProfileLogoutService.shared
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        installNewValueForLables()
    }
    
    private func installNewValueForLables() {
        guard let profile = ProfileService.shared.profile else {
            print("Profile not have value")
            return
        }
        guard let bio = profile.bio,
              let name = profile.name,
              let loginName = profile.loginName
        else {
            return
        }
        view?.installNewValueForLables(bio: bio, name: name, loginName: loginName)
    }
    
    internal func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageUrl = URL(string: profileImageURL)
        else { return }
        print("""
              ссылка на картинку для фото профиля готова, центр уведомлений отработал
              \(imageUrl)
              ссылка на картинку для фото профиля готова, центр уведомлений отработал
              """)
        KingfisherManager.shared.retrieveImage(with: imageUrl) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let retrieveImage):
                self.view?.installNewValueForAvatar(image: retrieveImage.image)
            case .failure(let error):
                print("Ошибка при загрузке аватарки: \(error.localizedDescription)")
            }
        }
    }
    
     func LogoutProfile() {
        profileLogoutService.logout()
    }
}
