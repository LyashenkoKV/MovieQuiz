//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 20.03.2024.
//

import Foundation

struct AlertModel {
    enum Context {
        case gameOver, error
    }
    
    let title: String
    let message: String
    let buttonText: String
    let context: Context
    let completion: (()->Void)?
}
