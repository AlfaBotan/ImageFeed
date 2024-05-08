//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 7.05.24.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage?
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}
