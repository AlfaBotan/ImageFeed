//
//  ViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 30.03.24.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private let showSingleImageSegueIdentifire = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private var photos: [Photo] = []
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
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main )
        { [weak self] _ in
            guard let self = self else {return}
            self.updateTableViewAnimated()
        }
        imageListService.fetchPhotosNextPage()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let largeImageURL = photos[indexPath.row].regularImageURL
        guard
            let imageUrl = URL(string: largeImageURL)
        else { return }
        print("""
          ссылка  готова, центр уведомлений отработал
          \(imageUrl)
          ссылка готова, центр уведомлений отработал
          """)
        cell.photo.kf.indicatorType = .activity
        cell.photo.kf.setImage(with: imageUrl,
                               placeholder: UIImage(named: "DownloadImage"),
                               options: nil) { result in
            
            switch result {
            case .success(let value):
                print("Изображение загружено")
            case .failure(let error):
                print("Изображение не загрузилось с ошибкой \(error)")
            }
        }
        if let date = photos[indexPath.row].createdAt {
            cell.dateLable.text = dateFormatter.string(from: date)
        } else {
            cell.dateLable.text = ""
        }
        let likeImage = UIImage(named: photos[indexPath.row].isLiked ? "Active" : "No Active")
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
            let largeImageURL = photos[indexPath.row].fullImageURL
            guard
                let imageUrl = URL(string: largeImageURL)
            else { return }
            viewControler.fullImageURL = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier , for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Не прошёл каст ячейки")
            return UITableViewCell()
        }
        imageListCell.delegate = self
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
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndexPath = photos.count - 1
        if indexPath.row == lastIndexPath {
            imageListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController {
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPath: [IndexPath] = []
                for i in (oldCount..<newCount) {
                    indexPath.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
}
// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success:
                    self.photos = self.imageListService.photos
                    cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
            }
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: "Ошибка при попытке изменить состояние лайка: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

