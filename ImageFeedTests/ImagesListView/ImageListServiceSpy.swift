//
//  ImageListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Илья Волощик on 18.06.24.
//

import ImageFeed
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

final class ImageListServiceSpy: ImagesListServiceProtocol {
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        let mockPhoto = Photo(id: "id",
                              size: CGSize(width: 1.0, height: 1.0),
                              createdAt: nil, thumbImageURL: "thumbImageURL",
                              fullImageURL: "fullImageURL",
                              isLiked: true,
                              regularImageURL: "regularImageURL")
        photos.append(mockPhoto)
    }
}
