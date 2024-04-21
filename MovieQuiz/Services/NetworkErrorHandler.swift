//
//  NetworkErrorHandler.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 15.04.2024.
//

import Foundation

enum NetworkError: Error {
    case noInternetConnection
    case requestTimedOut
    case emptyData
    case tooManyRequests
    case unknownError
    case serviceUnavailable
}

struct NetworkErrorHandler: NetworkErrorProtocol {
    
    static func errorMessage(from error: Error) -> String {
        var errorMessage = "Произошла ошибка при загрузке данных"
        
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noInternetConnection:
                errorMessage = "Отсутствует подключение к интернету"
            case .requestTimedOut:
                errorMessage = "Превышено время ожидания ответа от сервера"
            case .emptyData:
                errorMessage = "Данные не были получены"
            case .tooManyRequests:
                errorMessage = "Вы превысили лимит запросов к API. Попробуйте снова позже."
            case .unknownError:
                errorMessage = "Неизвестная ошибка"
            case .serviceUnavailable:
                errorMessage = "Сервис недоступен. Попробуйте снова позже."
            }
        }
        return errorMessage
    }
}
