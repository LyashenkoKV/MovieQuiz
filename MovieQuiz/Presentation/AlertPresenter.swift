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
        delegate?.showAlert(with: model)
    }
}
