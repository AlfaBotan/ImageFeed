//
//  profileViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 7.05.24.
//

import UIKit
import Kingfisher


public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? {get set}
    func installNewValueForLables(bio: String, name: String, loginName: String)
    func installNewValueForAvatar(image: UIImage)
    func updateAvatar()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: (any ProfilePresenterProtocol)?
    
    private lazy var profileImage = UIImageView()
    private lazy var nameLable = UILabel()
    private lazy var loginNameLabel = UILabel()
    private lazy var statusLable = UILabel()
    private lazy var exitbutton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        addAllSubView()
        profileImage.kf.indicatorType = .activity
        presenter?.viewDidLoad()
    }
    
    private func addProfileImageView() {
        let image = UIImage(systemName: "person.crop.circle.fill")
        profileImage = UIImageView(image: image)
        profileImage.tintColor = .gray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = 35
        profileImage.layer.masksToBounds = true
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
        exitbutton.addTarget(self, action: #selector(exitFromProfile), for: .touchUpInside)
        exitbutton.accessibilityIdentifier = "logout button"
        view.addSubview(exitbutton)
        
        NSLayoutConstraint.activate([
            exitbutton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitbutton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitbutton.widthAnchor.constraint(equalToConstant: 24),
            exitbutton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func addAllSubView() {
        addProfileImageView()
        addProfileNameLable()
        addProfileDescriptionLable()
        addProfileStatusLable()
        addExitButton()
    }
    
     func installNewValueForLables(bio: String, name: String, loginName: String) {
        statusLable.text = bio
        nameLable.text = name
        loginNameLabel.text = loginName
        
    }
    
     func updateAvatar() {
        presenter?.updateAvatar()
    }
    
    func installNewValueForAvatar(image: UIImage) {
        profileImage.image = image
    }
    
    @objc
    func exitFromProfile() {
        let alert = UIAlertController(title: "Предупреждение", message: "Вы собираетесь выйти из личного кабинета?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Не надо", style: .cancel) { action in }
        let actionTwo = UIAlertAction(title: "Да выйти", style: .default) { [weak self] _ in
            guard let self = self else {return}
            presenter?.LogoutProfile()
        }
        alert.addAction(action)
        alert.addAction(actionTwo)
        present(alert, animated: true)
    }
    
    func configureProfile(_ presenter: ProfilePresenterProtocol) {
            self.presenter = presenter
            presenter.view = self
        }
}
