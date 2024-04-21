//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 20.03.2024.
//

import UIKit

final class AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
    
    func showAlert(with model: AlertModel, identifier: String? = nil) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in 
            model.completion?()
        }
        alert.addAction(action)
        
        switch model.context {
        case .gameOver:
            alert.view.accessibilityIdentifier = "GameOverAlert"
        case .error:
            alert.view.accessibilityIdentifier = "ErrorAlert"
        }
        
        delegate?.presentAlert(alert)
    }
}
