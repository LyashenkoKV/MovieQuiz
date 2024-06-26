//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 19.03.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
    func resetState()
}
