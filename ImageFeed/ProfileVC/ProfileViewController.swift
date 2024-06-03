//
//  profileViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 7.05.24.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var profileImage = UIImageView()
    private lazy var nameLable = UILabel()
    private lazy var loginNameLabel = UILabel()
    private lazy var statusLable = UILabel()
    private lazy var exitbutton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addProfileImageView()
        addProfileNameLable()
        addProfileDescriptionLable()
        addProfileStatusLable()
        addExitButton()
        
        installNewValueForLables()
        
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
    }
    
    private func installNewValueForLables() {
        guard let profile = ProfileService.shared.profile else {
            print("Profile not have value")
            return
        }
        statusLable.text = profile.bio
        nameLable.text = profile.name
        loginNameLabel.text = profile.loginName
    }
    
    private func addProfileImageView() {
        let image = UIImage(systemName: "person.crop.circle.fill")
        profileImage = UIImageView(image: image)
        profileImage.tintColor = .gray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addProfileNameLable(){
        
        nameLable.text = "Name"
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLable)
        nameLable.font = .systemFont(ofSize: 23, weight: .semibold)
        nameLable.textColor = .ypWhite
        
        NSLayoutConstraint.activate([
            nameLable.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            nameLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addProfileDescriptionLable(){
        loginNameLabel.text = "Description"
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.font = .systemFont(ofSize: 13)
        loginNameLabel.textColor = .ypGray
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addProfileStatusLable(){
        statusLable.text = "Status"
        statusLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLable)
        statusLable.font = .systemFont(ofSize: 13)
        statusLable.textColor = .ypWhite
        
        NSLayoutConstraint.activate([
            statusLable.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            statusLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addExitButton(){
        exitbutton.setImage(UIImage(named: "Exit"), for: .normal)
        exitbutton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitbutton)
        
        NSLayoutConstraint.activate([
            exitbutton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitbutton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitbutton.widthAnchor.constraint(equalToConstant: 24),
            exitbutton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func updateAvatar() {
           guard
               let profileImageURL = ProfileImageService.shared.avatarURL,
               let imageUrl = URL(string: profileImageURL)
           else { return }
        print("""
              ссылка готова, центр уведомлений отработал
              \(imageUrl)
              ссылка готова, центр уведомлений отработал
              """)
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: imageUrl,
                                 placeholder: UIImage(named: "person.crop.circle.fill"),
                                 options: [.processor(processor)]) { result in
                                  
                                  switch result {
                                // Успешная загрузка
                                  case .success(let value):
                                      // Картинка
                                      print(value.image)
                                      // Информация об источнике.
                                      print(value.source)
                                  case .failure(let error):
                                      print("Изображение не загрузилось с ошибкой \(error)")
                                  }
                              }
       }
}
