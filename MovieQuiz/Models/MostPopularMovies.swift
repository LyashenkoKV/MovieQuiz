//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 03.04.2024.
//

import Foundation

struct MostPopularMovies: Decodable {
    let items: [MostPopularMovie]
    let errorMessage: String
}

struct MostPopularMovie: Decodable {
    let title: String
    let imageURL: URL
    let rating: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.rating = try container.decodeIfPresent(String.self, forKey: .rating)
        
        if let imageURLString = try container.decodeIfPresent(String.self, forKey: .imageURL), let imageURL = URL(string: imageURLString) {
            self.imageURL = imageURL
        } else {
            self.imageURL = URL(string: "")!
        }
    }
    
    var resizedImageURL: URL {
        guard !imageURL.absoluteString.isEmpty else {
            return imageURL
        }
        
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
