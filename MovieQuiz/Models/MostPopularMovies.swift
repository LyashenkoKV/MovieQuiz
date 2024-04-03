//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 03.04.2024.
//

import Foundation

private enum ParseError: Error {
    case yearFailure
    case runtimeMinsFailure
}

struct MostPopularMovies: Decodable {
    let items: [MostPopularMovie]
    let errorMessage: String
}

struct MostPopularMovie: Decodable {
    let title: String
    let imageURL: URL
    let rating: String?
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
