//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Илья Волощик on 7.05.24.
//

import UIKit
import Kingfisher
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    var fullImageURL: URL?
        
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var sharingButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet  weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        if let imageURL = fullImageURL {
            
            UIBlockingProgressHUD.show()
            imageView.kf.setImage(with: imageURL,
                                 placeholder: UIImage(named: "DownloadImage"),
                                  options: nil) { [weak self] result in
                                guard let self = self else {return}
                                    UIBlockingProgressHUD.dismiss()
                                  switch result {
                                  case .success(let value):
                                      
                                      self.imageView.frame.size = value.image.size
                                      self.imageView.contentMode = .scaleAspectFit
                                      self.rescaleAndCenterImageInScrollView(image: value.image)
                                  case .failure(let error):
                                      print("Изображение не загрузилось с ошибкой \(error)")
                                      self.showError()
                                  }
                              }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    @IBAction private func didTapShareButton() {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Не надо", style: .cancel) { action in }
        let actionTwo = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else {return}
            imageView.kf.setImage(with: self.fullImageURL,
                                  placeholder: UIImage(named: "DownloadImage"),
                                  options: nil) { [weak self] result in
                
                switch result {
                case .success(let value):
                    self?.imageView.frame.size = value.image.size
                    self?.rescaleAndCenterImageInScrollView(image: value.image)
                case .failure(let error):
                    print("Изображение не загрузилось с ошибкой \(error)")
                    self?.showError()
                }
            }
        }
        alert.addAction(action)
        alert.addAction(actionTwo)
        present(alert, animated: true)
    }
}
