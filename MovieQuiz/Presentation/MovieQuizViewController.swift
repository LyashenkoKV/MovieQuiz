import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // Индекс текущего вопроса
    private var currentQuestionIndex = 0
    // Счетчик правильных ответов
    private var correctAnswers = 0
    // Общее количество вопросов
    private var questionsAmount = 10
    // Фабрика вопросов
    private var questionFactory: QuestionFactoryProtocol?
    // Вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    // Показ результатов
    private var alertPresenter = AlertPresenter()
    // Статистика игр
    private var statisticService: StatisticServiceProtocol?
    // Загрузчик фильмов
    private var moviesLoader: MoviesLoading?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImage.layer.cornerRadius = 15
        activityIndicator.hidesWhenStopped = true
        
        let moviesLoader = MoviesLoader()
        let questionFactory = QuestionFactory(delegate: self, moviesLoader: moviesLoader) { [weak self] error in
            guard let self else { return }
            let errorMessage = NetworkErrorHandler.errorMessage(from: error)
            self.showError(message: errorMessage) {
                self.restartQuiz()
            }
        }
        
        self.questionFactory = questionFactory
        activityIndicator.startAnimating()
        questionFactory.loadData()
        
        statisticService = StatisticServiceImplementation()
        alertPresenter.delegate = self
    }
    
    // MARK: - Methods
    private func compare(givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.previewImage.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.cornerRadius = 15
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    private func showNextQuestionOrResults() {
        guard let statisticService = statisticService else { return }
        
        if currentQuestionIndex == questionsAmount - 1 {
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
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.resetState()
        questionFactory?.requestNextQuestion()
    }

    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
    }
    
    private func showError(message: String, errorHandler: (() -> Void)? = nil) {
        let buttonText = "Попробовать еще раз?"
        let title = "Ошибка"
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let model = AlertModel(title: title, message: message, buttonText: buttonText, context: .error) { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.startAnimating()
                errorHandler?()
            }
            self.alertPresenter.showAlert(with: model)
        }
    }
    
    // MARK: - IBActions
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        compare(givenAnswer: true)
    }
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        compare(givenAnswer: false)
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        activityIndicator.startAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let errorMessage = NetworkErrorHandler.errorMessage(from: error)
        showError(message: errorMessage)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = QuizConverter.convert(model: question,
                                              currentIndex: currentQuestionIndex + 1,
                                              totalCount: questionsAmount)
        DispatchQueue.main.async {
            self.show(quiz: viewModel)
            self.activityIndicator.stopAnimating()
        }
    }
}
// MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
