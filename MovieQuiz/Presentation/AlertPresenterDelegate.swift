//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 20.03.2024.
//

import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(with model: AlertModel)
}
