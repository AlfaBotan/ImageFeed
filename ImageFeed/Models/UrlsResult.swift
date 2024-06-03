//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Илья Волощик on 3.06.24.
//

import UIKit

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
