//
//  QuizConverterProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 15.04.2024.
//

import Foundation

protocol QuizPresenterProtocol {
    var viewController: MovieQuizViewControllerProtocol? { get set }
    var currentQuestion: QuizQuestion? { get set }
    var correctAnswers: Int { get set }
    
    func compare(givenAnswer: Bool)
    func showNextQuestionOrResults()
    func restartQuiz()
}
