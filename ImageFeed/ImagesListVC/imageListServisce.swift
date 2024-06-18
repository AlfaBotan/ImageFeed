//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Илья Волощик on 30.05.24.
//

import UIKit
public protocol ImagesListServiceProtocol: AnyObject {
    func fetchPhotosNextPage()
}

final class ImagesListService: ImagesListServiceProtocol {
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private var lastLoadedPage = 1
    private let formatter = ISO8601DateFormatter()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    static let shared = ImagesListService()
    private init(){}
    
    func fetchPhotosNextPage() {
        guard task == nil else {return}
        
        guard let request = getImagesListRequest(page: lastLoadedPage) else {
            print("Error creating request")
            return
        }
        
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.task = nil
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                guard 200 ..< 300 ~= statusCode else {
                    let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    print("[objectTask]: HTTP error - status code \(statusCode), message: \(errorMessage)")
                    return
                }
            }
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                
                DispatchQueue.main.async {
                    photoResults.forEach {
                        self.photos.append(
                            Photo(
                                id: $0.id,
                                size: CGSize(width: $0.width, height: $0.height),
                                createdAt: self.formatISODateString($0.createdAt),
                                welcomeDescription: $0.description,
                                thumbImageURL: $0.urls.thumb,
                                fullImageURL: $0.urls.full,
                                isLiked: $0.likedByUser,
                                regularImageURL: $0.urls.regular
                            )
                        )
                    }
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos]
                    )
                    self.lastLoadedPage += 1
                }
            } catch {
                print("Error decoding JSON: \(error)")
                
            }
        }
        task?.resume()
    }
    
    private func getImagesListRequest(page: Int) -> URLRequest? {
        guard let token = oAuth2TokenStorage.getStorageToken() else {
            return nil
        }
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = components?.url else {
            print("Не удалось собрать URL для запроса списка картинок")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func formatISODateString(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        return formatter.date(from: dateString)
    }
    
    private func convertPhotoResult(photoResult: PhotoResult) -> Photo {
        let date = formatISODateString(photoResult.createdAt)
        return Photo(id: photoResult.id, size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)), createdAt: date, welcomeDescription: photoResult.description, thumbImageURL: photoResult.urls.thumb, fullImageURL: photoResult.urls.full, isLiked: photoResult.likedByUser, regularImageURL: photoResult.urls.regular)
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        var httpMethod: String
        if !isLike {
            httpMethod = "DELETE"
        } else {
            httpMethod = "POST"
        }
        guard let token = oAuth2TokenStorage.getStorageToken() else {return}
        let urlString = "https://api.unsplash.com/photos/\(photoId)/like"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Не удалось собрать ссылку для лайка", code: 0, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {return}
            
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                guard 200 ..< 300 ~= statusCode else {
                    let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    print("[objectTask]: HTTP error - status code \(statusCode), message: \(errorMessage)")
                    completion(.failure(NSError(domain: "Ошибка 404", code: 0, userInfo: nil)))
                    return
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                let photo = self.photos[index]
                let newPhoto = Photo(id: photo.id,
                                     size: photo.size,
                                     createdAt: photo.createdAt,
                                     thumbImageURL: photo.thumbImageURL,
                                     fullImageURL: photo.fullImageURL,
                                     isLiked: isLike,
                                     regularImageURL: photo.regularImageURL)
                DispatchQueue.main.async {
                    self.photos[index] = newPhoto
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos]
                    )
                    completion(.success(()))
                }
            } else {
                DispatchQueue.main.async {
                    print("Не удалось выполнить запрос для смены состония LikeButton")
                    completion(.failure(NSError(domain: "Photo not found", code: 0, userInfo: nil)))
                }
            }
        }
        task.resume()
    }
    
    func removeData() {
        task = nil
        photos = []
        lastLoadedPage = 1
    }
}
