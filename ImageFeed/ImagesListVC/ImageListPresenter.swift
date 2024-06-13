//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Илья Волощик on 13.06.24.
//

import UIKit
import Kingfisher

 protocol ImageListPresenterProtocol: AnyObject {
     var view: ImagesListViewControllerProtocol? { get set }
     func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
     func updateTableView(tableView: UITableView)
     func viewDidLoad()
     var photos: [Photo] { get set }
     func prepare(for segue: UIStoryboardSegue, sender: Any?)
     func tableViewWillDisplay(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
     func tableViewHeightForRowAtIndexPath(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     func imageListCellDidTapLike(_ cell: ImagesListCell, tableView: UITableView)
}

final class ImageListPresenter: ImageListPresenterProtocol {
    
    private let showSingleImageSegueIdentifire = "ShowSingleImage"
    var view: (any ImagesListViewControllerProtocol)?
    private let imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    weak var tableView: UITableView?
    internal var photos: [Photo] = []
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func viewDidLoad() {
        photos = imageListService.photos
        registerForNotifications()
        imageListService.fetchPhotosNextPage()
    }
    
    func registerForNotifications() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main )
        { [weak self] _ in
            guard let self = self else {return}
            view?.updateTableViewAnimated()
        }
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
            case .success(_):
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
    
    func updateTableView(tableView: UITableView) {
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
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        }
    }
    
     func tableViewWillDisplay(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         let lastIndexPath = photos.count - 1
         if indexPath.row == lastIndexPath {
             imageListService.fetchPhotosNextPage()
         }
    }
    
    func tableViewHeightForRowAtIndexPath(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell, tableView: UITableView) {
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
        view?.showErrorAlert(error: error)
    }
}
