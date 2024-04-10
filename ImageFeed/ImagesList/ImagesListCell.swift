//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Илья Волощик on 7.04.24.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientLayer: CAGradientLayer!
}

