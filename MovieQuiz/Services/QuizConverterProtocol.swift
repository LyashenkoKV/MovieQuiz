//
//  QuizConverterProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 15.04.2024.
//

import Foundation

protocol QuizConverterProtocol {
    func convert(model: QuizQuestion) -> QuizStepViewModel
}
