//
//  ViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 30.03.24.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifire = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet private weak var imageInCell: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

   func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
       guard let image = UIImage(named: photosName[indexPath.row]) else { return }
       cell.photo.image = image
       cell.dateLable.text = dateFormatter.string(from: Date())
       let likeImage = UIImage(named: indexPath.row % 2 == 0 ? "Active" : "No Active")
       cell.likeButton.setImage(likeImage, for: .normal)
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifire {
        guard
            let viewControler = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
        else {
            assertionFailure("Invalid segue destination")
            return
        }
            let image = UIImage(named: photosName[indexPath.row])
            viewControler.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

    // MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier , for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Не прошёл каст ячейки")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    
}
   // MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifire, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}


