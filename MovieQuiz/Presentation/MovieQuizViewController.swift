import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Презентер
    private var presenter: MovieQuizPresenter?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImage.layer.cornerRadius = 15
        activityIndicator.hidesWhenStopped = true
        presenter = MovieQuizPresenter(viewController: self)
        guard let presenter = presenter else { return }
        presenter.questionFactory?.loadData()
    }
    
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
    }
    
    // MARK: - IBActions
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        presenter?.compare(givenAnswer: true)
    }
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        presenter?.compare(givenAnswer: false)
    }
}

