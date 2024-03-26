//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 20.03.2024.
//

import UIKit

final class AlertPresenter {
    
    weak var delegate: AlertPresenterDelegate?
    
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            model.completion?()
            self.delegate?.dismissAlert()
        }
        alert.addAction(action)
        delegate?.presentAlert(alert)
    }
}
