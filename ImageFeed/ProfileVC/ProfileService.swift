//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Илья Волощик on 22.05.24.
//

import UIKit

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    
    private(set) var profile: Profile?
    private var lastToken: String?
    private var task: URLSessionTask?
    
    static let shared = ProfileService()
    private init(){}
    
    func makeProfileDataRequest(token: String) -> URLRequest? {
        let baseURL = Constants.defaultBaseURL
        var request = URLRequest(url: URL(string: "/me",
                                          relativeTo: baseURL)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
        }
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.cancel()
        lastToken = token
        
        guard
            let request = makeProfileDataRequest(token: token)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

//    let task = URLSession.shared.data(for: request) { result in
//        DispatchQueue.main.async {
//            switch result {
//            case .success(let data):
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
//                    let profile = Profile(profileResult: profileResult)
//                    self.profile = profile
//                    completion(.success(profile))
//                } catch {
//                    completion(.failure(error))
//                    print("не получилось декодировать полученный ответ")
//                }
//            case .failure(let error):
//                print("Ошибка из метода fetchProfile")
//                completion(.failure(error))
//            }
//            self.task = nil
//            self.lastToken = nil
//        }
//    }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case.success(let profileResult):
                    let profile = Profile(profileResult: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                case.failure(let error):
                    print("Ошибка из метода fetchProfile")
                    completion(.failure(error))
                }
                self.task = nil
                self.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
}
