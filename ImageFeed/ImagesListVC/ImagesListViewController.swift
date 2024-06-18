//
//  ViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 30.03.24.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
     var presenter: ImageListPresenterProtocol? {get set}
     func updateTableViewAnimated()
     func showErrorAlert(error: Error)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    private let showSingleImageSegueIdentifire = "ShowSingleImage"
    var presenter: (any ImageListPresenterProtocol)?

    @IBOutlet private weak var imageInCell: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImageListPresenter()
        presenter?.view = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter?.prepare(for: segue, sender: sender)
    }
    
    func configureImagesList(_ presenter: ImageListPresenterProtocol) {
            self.presenter = presenter
            presenter.view = self
        }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {return 0}
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier , for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Не прошёл каст ячейки")
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        guard let presenter = presenter else {return UITableViewCell()}
        presenter.configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
}
// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifire, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter else {return CGFloat()}
        return presenter.tableViewHeightForRowAtIndexPath(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.tableViewWillDisplay(tableView, willDisplay: cell, forRowAt: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController {
     func updateTableViewAnimated() {
         presenter?.updateTableView(tableView: tableView)
    }
}
// MARK: - ImagesListCellLikes

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        presenter?.imageListCellDidTapLike(cell, tableView: tableView)
    }
    
    internal func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: "Ошибка при попытке изменить состояние лайка: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

