//
//  Photo.swift
//  ImageFeed
//
//  Created by Илья Волощик on 3.06.24.
//

import UIKit

struct Photo {
    var id: String
    var size: CGSize
    let createdAt: Date?
    var welcomeDescription: String?
    var thumbImageURL: String
    var fullImageURL: String
    var isLiked: Bool
    let regularImageURL: String
}
