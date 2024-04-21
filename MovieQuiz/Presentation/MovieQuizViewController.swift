import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
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
    }
    
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        previewImage.image = step.image
        questionLabel.text = step.question
    }
    
    func showAnswerResult(isCorrect: Bool) {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.cornerRadius = 15
        previewImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func updatePreviewImageBorderWidth(to borderWidth: CGFloat) {
        previewImage.layer.borderWidth = borderWidth
    }
    
    func setButtonsInteractionEnabled(_ enabled: Bool) {
        yesButton.isUserInteractionEnabled = enabled
        noButton.isUserInteractionEnabled = enabled
    }
    
    // MARK: - IBActions
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        presenter?.compare(givenAnswer: true)
    }
    
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        presenter?.compare(givenAnswer: false)
    }
}

