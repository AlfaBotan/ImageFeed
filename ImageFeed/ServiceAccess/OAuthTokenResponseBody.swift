//
//  File.swift
//  ImageFeed
//
//  Created by Илья Волощик on 17.05.24.
//

import UIKit

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
