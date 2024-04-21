//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Konstantin Lyashenko on 19.04.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var setButtonsInteractionEnabledCalled = true
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func updatePreviewImageBorderWidth(to borderWidth: CGFloat) {
        
    }
    
    func setButtonsInteractionEnabled(_ enabled: Bool) {
        
    }
    
}

final class MovieQuizPresenterTests: XCTestCase {
    
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "0/10")
    }
    
    func testPresenterCompareWithCorrectAnswer() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let question = QuizQuestion(image: Data(), text: "Question Text", correctAnswer: true)
        presenter.currentQuestion = question
        presenter.compare(givenAnswer: true)

        XCTAssertTrue(viewControllerMock.setButtonsInteractionEnabledCalled)
    }
    
    func testPresenterCompareWithIncorrectAnswer() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let question = QuizQuestion(image: Data(), text: "Question Text", correctAnswer: true)
        presenter.currentQuestion = question
        presenter.compare(givenAnswer: false)
        
        XCTAssertEqual(presenter.correctAnswers, 0)
    }
    
    func testPresenterIsLastQuestion() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        presenter.currentQuestionIndex = presenter.questionsAmount - 1
        
        XCTAssertTrue(presenter.isLastQuestion())
    }
    
    func testPresenterRestartQuiz() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        presenter.correctAnswers = 5
        presenter.currentQuestionIndex = 3
        presenter.restartQuiz()
        
        XCTAssertEqual(presenter.correctAnswers, 0)
        XCTAssertEqual(presenter.currentQuestionIndex, 0)
    }
}
