//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 03.04.2024.
//

import Foundation

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    private let imdbURL = "https://tv-api.com/en/API/Top250Movies/"
    private let apiKeys = "k_zcuw1ytf"
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: imdbURL + apiKeys) else {
            preconditionFailure("Unable to construct mostPopularMoviewUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        let decoder = JSONDecoder()
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try decoder.decode(MostPopularMovies.self, from: data)
                    handler(.success(decodedData))
                } catch {
                    print(error.localizedDescription)
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
