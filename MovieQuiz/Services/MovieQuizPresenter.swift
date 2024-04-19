//
//  QuizConverter.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 18.03.2024.
//

import UIKit

final class MovieQuizPresenter: QuizConverterProtocol {
    
    private weak var viewController: MovieQuizViewController?
    private let questionsAmount = 10
    private var currentQuestionIndex = 0
    
    // Счетчик правильных ответов
    var correctAnswers = 0
    // Фабрика вопросов
    var questionFactory: QuestionFactoryProtocol?
    // Вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    // Показ результатов
    private var alertPresenter = AlertPresenter()
    // Статистика игр
    private var statisticService: StatisticServiceProtocol?
    // Загрузчик фильмов
    private var moviesLoader: MoviesLoading?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        alertPresenter.delegate = self
        
        self.moviesLoader = MoviesLoader(networkClient: NetworkClient())
        guard let moviesLoader = self.moviesLoader else { return }
        questionFactory = QuestionFactory(delegate: self, moviesLoader: moviesLoader) { [weak self] error in
            guard let self else { return }
            let errorMessage = NetworkErrorHandler.errorMessage(from: error)
            self.showError(message: errorMessage) {
                self.restartQuiz()
            }
        }
        questionFactory?.loadData()
        viewController.activityIndicator.startAnimating()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image)
        return QuizStepViewModel(image: image ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // MARK: - Methods
    func showNextQuestionOrResults() {
        guard let statisticService = statisticService else { return }
        
        if isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService.bestGame
            let message = "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/\(questionsAmount) (\(bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            let title = "Этот раунд окончен!"
            let buttonText = "Сыграть еще раз"
            let statistic = AlertModel(title: title,
                                       message: message,
                                       buttonText: buttonText, context: .gameOver) { [weak self] in
                guard let self else { return }
                self.restartQuiz()
            }
            alertPresenter.showAlert(with: statistic)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func restartQuiz() {
        resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.resetState()
        questionFactory?.requestNextQuestion()
    }
    
    private func showError(message: String, errorHandler: (() -> Void)? = nil) {
        let buttonText = "Попробовать еще раз?"
        let title = "Ошибка"
        DispatchQueue.main.async {
            self.viewController?.activityIndicator.stopAnimating()
            let model = AlertModel(title: title, message: message, buttonText: buttonText, context: .error) { [weak self] in
                guard let self = self else { return }
                self.viewController?.activityIndicator.startAnimating()
                self.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.loadData()
                errorHandler?()
            }
            self.alertPresenter.showAlert(with: model)
        }
    }
    
    func compare(givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.viewController?.previewImage.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.viewController?.yesButton.isEnabled = true
            self.viewController?.noButton.isEnabled = true
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        viewController?.previewImage.layer.masksToBounds = true
        viewController?.previewImage.layer.borderWidth = 8
        viewController?.previewImage.layer.cornerRadius = 15
        viewController?.previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
    } 
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        viewController?.activityIndicator.startAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let errorMessage = NetworkErrorHandler.errorMessage(from: error)
        showError(message: errorMessage)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {
            self.viewController?.show(quiz: viewModel)
            self.viewController?.activityIndicator.stopAnimating()
        }
    }
}

extension MovieQuizPresenter: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        DispatchQueue.main.async {
            self.viewController?.present(alert, animated: true)
        }
    }
}
