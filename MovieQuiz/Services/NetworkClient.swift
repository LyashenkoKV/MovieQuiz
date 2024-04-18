//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 03.04.2024.
//

import Foundation


struct NetworkClient: NetworkRoutingProtocol {
    // MARK: - Fetch
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                switch response.statusCode {
                case 429:
                    handler(.failure(NetworkError.tooManyRequests))
                case 200..<300:
                    if let data = data {
                        handler(.success(data))
                    } else {
                        handler(.failure(NetworkError.emptyData))
                    }
                case 503:
                    handler(.failure(NetworkError.serviceUnavailable))
                default:
                    handler(.failure(NetworkError.unknownError))
                }
            } else if let error = error {
                if let nsError = error as NSError?, nsError.code == NSURLErrorTimedOut {
                    handler(.failure(NetworkError.requestTimedOut))
                } else {
                    handler(.failure(NetworkError.noInternetConnection))
                }
            }
        }
        task.resume()
    }
}
