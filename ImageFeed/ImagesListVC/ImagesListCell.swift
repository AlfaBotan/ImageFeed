//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Илья Волощик on 7.04.24.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final public class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientLayer: CAGradientLayer!
    
    @IBAction func likeButtonPress(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        photo.kf.cancelDownloadTask()
        photo.image = nil
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = UIImage(named: isLiked ? "Active" : "No Active")
        likeButton.setImage(likeImage, for: .normal)
    }
}

