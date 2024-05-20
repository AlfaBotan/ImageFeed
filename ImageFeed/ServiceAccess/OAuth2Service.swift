//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Илья Волощик on 17.05.24.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init(){}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard
            let baseURL = URL(string: "https://unsplash.com")
        else { print("baseURL")
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
            print("URL")
            return nil
        }
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let urlRequest: URLRequest = makeOAuthTokenRequest(code: code) else { return}
        let task = URLSession.shared.data(for: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.accessToken))
                } catch {
                    completion(.failure(error))
                    print("не получилось декодировать полученный ответ")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
