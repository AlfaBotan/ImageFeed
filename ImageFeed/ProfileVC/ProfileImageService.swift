//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Илья Волощик on 23.05.24.
//

import UIKit

final class ProfileImageService {
    
    private(set) var profileImage: ProfileImage?
    private(set) var profile = ProfileService.shared.profile
    
    private(set) var avatarURL: String?
    private var lastToken: String?
    private var task: URLSessionTask?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    static let shared = ProfileImageService()
    private init(){}
    
    func makeProfileImageRequest(token: String, userName: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(userName)") 
        else {
            print("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
        }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = oAuth2TokenStorage.getStorageToken() else {return}
        
//        task?.cancel()
//        lastToken = token
        
        guard
            let request = makeProfileImageRequest(token: token, userName: username)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

    let task = URLSession.shared.data(for: request) { result in
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    guard let smallProfileImage = profileResult.profileImage?.small else {
                        print("Error: [ProfileImageService] image is nil")
                        completion(.failure(NetworkError.imageError))
                        return
                        
                    }
                    self.profileImage = profileResult.profileImage
                    self.avatarURL = smallProfileImage
                    completion(.success(smallProfileImage))
                } catch {
                    completion(.failure(error))
                    print("не получилось декодировать полученный ответ")
                }
            case .failure(let error):
                print("Ошибка из метода fetchProfile")
                completion(.failure(error))
            }
//            self.task = nil
//            self.lastToken = nil
        }
    }
//        self.task = task
        task.resume()
    }
    
}
