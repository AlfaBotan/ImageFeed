//
//  MockProfileVC.swift
//  ImageFeedTests
//
//  Created by Илья Волощик on 16.06.24.
//


import ImageFeed
import UIKit

final class MockProfileViewController: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfilePresenterProtocol)?
    var profileAvatar: UIImage?
    
    func installNewValueForLables(bio: String, name: String, loginName: String) {
        
    }
    
    func installNewValueForAvatar(image: UIImage) {
        profileAvatar = image
    }
    
    func updateAvatar() {
        
    }
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
}
