//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 19.04.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func showAnswerResult(isCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func updatePreviewImageBorderWidth(to borderWidth: CGFloat)
    func setButtonsInteractionEnabled(_ enabled: Bool)
}
