//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Илья Волощик on 17.05.24.
//

import UIKit

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    
    static let shared = OAuth2Service()
    private init(){}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard
            let baseURL = URL(string: "https://unsplash.com")
        else { print("Fail create baseURL for OAuthTokenRequest")
               return nil
        }
        guard
         let url = URL(
             string: "/oauth/token"
             + "?client_id=\(Constants.accessKey)"
             + "&&client_secret=\(Constants.secretKey)"
             + "&&redirect_uri=\(Constants.redirectURI)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL
         )
        else {
            print("Fail create URL for OAuthTokenRequest")
            return nil
        }
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
            assert(Thread.isMainThread)
        guard lastCode != code else {
                   completion(.failure(AuthServiceError.invalidRequest))
                   return
               }

               task?.cancel()
               lastCode = code
            guard
                let request = makeOAuthTokenRequest(code: code)
            else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }

//        let task = URLSession.shared.data(for: request) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    do {
//                        let decoder = JSONDecoder()
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//                        let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                        completion(.success(response.accessToken))
//                    } catch {
//                        completion(.failure(error))
//                        print("не получилось декодировать полученный ответ")
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//                self.task = nil
//                self.lastCode = nil
//            }
//        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case.success(let oAuthTokenResponseBody):
                    completion(.success(oAuthTokenResponseBody.accessToken))
                case.failure(let error):
                    print("Ошибка там где не ждали")
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        
            self.task = task
            task.resume()
        }
    
}
