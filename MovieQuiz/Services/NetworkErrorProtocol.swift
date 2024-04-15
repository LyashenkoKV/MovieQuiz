//
//  NetworkErrorHandlerProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 15.04.2024.
//

import Foundation

protocol NetworkErrorProtocol {
    static func errorMessage(from error: Error) -> String
}
