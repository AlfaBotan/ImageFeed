//
//  ImagesListVCSpy.swift
//  ImageFeedTests
//
//  Created by Илья Волощик on 18.06.24.
//

import ImageFeed
import UIKit

final class ImagesListVCSpy: ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImageListPresenterProtocol)?
    
    func updateTableViewAnimated() {
        
    }
    
    func showErrorAlert(error: any Error) {
        
    }
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
}
