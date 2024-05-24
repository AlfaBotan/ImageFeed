//
//  Profile.swift
//  ImageFeed
//
//  Created by Илья Волощик on 22.05.24.
//

import UIKit

struct Profile {
    let username: String?
    let name: String?
    let loginName: String?
    let bio: String?
    
    init(profileResult: ProfileResult) {
        username = profileResult.username
        loginName = "@\(username ?? "")"
        name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
        bio = profileResult.bio
    }
}

