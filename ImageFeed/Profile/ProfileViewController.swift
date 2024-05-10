//
//  profileViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 7.05.24.
//

import UIKit

final class ProfileViewController: UIViewController {
    
   
    @IBOutlet weak var logoutButton: UIButton!
    
    private var profileImage = UIImageView()
    private var nameLable = UILabel()
    private var descriptionLable = UILabel()
    private var statusLable = UILabel()
    private var exitbutton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        logoutButton.isHidden = true
        
        addProfileImageView()
        addProfileNameLable()
        addProfileDescriptionLable()
        addProfileStatusLable()
        addExitButton()
    }
    
    private func addProfileImageView() {
        let image = UIImage(systemName: "person.crop.circle.fill")
        profileImage = UIImageView(image: image)
        profileImage.tintColor = .gray
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
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
        
        descriptionLable.text = "Description"
        descriptionLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLable)
        descriptionLable.font = .systemFont(ofSize: 13)
        descriptionLable.textColor = .ypGray
        
        NSLayoutConstraint.activate([
            descriptionLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 8),
            descriptionLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addProfileStatusLable(){
        statusLable.text = "Status"
        statusLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLable)
        statusLable.font = .systemFont(ofSize: 13)
        statusLable.textColor = .ypWhite
        
        NSLayoutConstraint.activate([
            statusLable.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 8),
            statusLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func addExitButton(){
        
//        exitbutton.tintColor = .red
        exitbutton.setImage(UIImage(named: "Exit"), for: .normal)
        exitbutton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitbutton)
        
        NSLayoutConstraint.activate([
            exitbutton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 99),
            exitbutton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitbutton.widthAnchor.constraint(equalToConstant: 24),
            exitbutton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    
}
