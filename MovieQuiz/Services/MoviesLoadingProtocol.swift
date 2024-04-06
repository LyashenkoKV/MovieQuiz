//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 04.04.2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
