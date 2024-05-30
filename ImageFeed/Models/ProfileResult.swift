//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Илья Волощик on 22.05.24.
//

import UIKit

struct ProfileResult: Codable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
}
