import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // Массив вопросов
    private var questions: [QuizQuestion] = []
    // Индекс текущего вопроса
    private var currentQuestionIndex = 0
    // Счетчик правильных ответов
    private var correctAnswers = 0
    // Модель Mock-данных
    private let mockData = MockData()
    // Состояние алерта
    private var isAlertPresented = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImage.layer.cornerRadius = 15
        questions = mockData.questions
        setupQuiz()
    }
    
    // MARK: - Methods
    private func showAlert(with result: QuizResultsViewModel) {
        guard !isAlertPresented else {
                return
            }
            isAlertPresented = true
        
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.butttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.setupQuiz()
            self.correctAnswers = 0
            self.isAlertPresented = false
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func compare(givenAnswer: Bool) {
        let currentQestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: givenAnswer == currentQestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showNextQuestionOrResults()
            self.previewImage.layer.borderWidth = 0
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
        let result = QuizResultsViewModel(title: "Этот раунд окончен!",
                                          text: "Ваш результат \(correctAnswers)/\(questions.count)",
                                          butttonText: "Сыграть еще раз")
        if currentQuestionIndex == questions.count - 1 {
            showAlert(with: result)
        } else {
            currentQuestionIndex += 1
            setupQuiz()
        }
    }

    private func setupQuiz() {
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = QuizConverter.convert(model: currentQuestion,
                                              currentIndex: currentQuestionIndex + 1,
                                              totalCount: questions.count)
        show(quiz: viewModel)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
    }
    
    // MARK: - IBActions
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        compare(givenAnswer: true)
        sender.isEnabled = false
    }
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        compare(givenAnswer: false)
        sender.isEnabled = false
    }
}
// MARK: - QuizQuestion
struct QuizQuestion {
    fileprivate var image: String
    fileprivate var text: String
    fileprivate var correctAnswer: Bool
}

// MARK: - MockData
fileprivate struct MockData {
    static private let quest = "Рейтинг этого фильма больше чем 6?"
    fileprivate let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Godfather",
                text: quest,
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: quest,
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: quest,
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: quest,
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: quest,
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: quest,
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: quest,
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: quest,
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: quest,
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: quest,
                correctAnswer: false)
        ]
}

// MARK: - QuizStepViewModel
fileprivate struct QuizStepViewModel {
    var image: UIImage
    var question: String
    var questionNumber: String
}

// MARK: - QuizConverter
fileprivate struct QuizConverter {
    static func convert(model: QuizQuestion, currentIndex: Int, totalCount: Int) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentIndex)/\(totalCount)")
    }
}

// MARK: - QuizResultsViewModel
fileprivate struct QuizResultsViewModel {
    let title: String
    let text: String
    let butttonText: String
}
