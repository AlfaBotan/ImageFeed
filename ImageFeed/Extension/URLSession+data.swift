//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Илья Волощик on 17.05.24.
//

import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int, String)
    case urlRequestError(Error)
    case urlSessionError
    case imageError
    case decodingError
}

extension URLSession {
    
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    print("[objectTask]: HTTP error - status code \(statusCode), message: \(errorMessage)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode, errorMessage)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                print("urlRequestError")
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                print("urlSessionError")
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[objectTask]: URLRequest error - \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("[objectTask]: URLSession error - no data or response")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                return
            }
            
            if !(200 ..< 300).contains(statusCode) {
                let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                print("[objectTask]: HTTP error - status code \(statusCode), message: \(errorMessage)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode, errorMessage)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                fulfillCompletionOnTheMainThread(.success(result))
            } catch {
                print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.decodingError))
            }
        }
        task.resume()
        return task
    }
}
