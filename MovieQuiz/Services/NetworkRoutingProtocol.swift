//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 11.04.2024.
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
