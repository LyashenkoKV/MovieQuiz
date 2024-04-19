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
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "0/10")
    }
    
    func testPresenterCompareWithCorrectAnswer() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let question = QuizQuestion(image: Data(), text: "Question Text", correctAnswer: true)
        sut.currentQuestion = question
        sut.compare(givenAnswer: true)

        XCTAssertTrue(viewControllerMock.setButtonsInteractionEnabledCalled)
    }
    
    func testPresenterCompareWithIncorrectAnswer() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let question = QuizQuestion(image: Data(), text: "Question Text", correctAnswer: true)
        sut.currentQuestion = question
        sut.compare(givenAnswer: false)
        
        XCTAssertEqual(sut.correctAnswers, 0)
    }
    
    func testPresenterIsLastQuestion() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        sut.currentQuestionIndex = sut.questionsAmount - 1
        
        XCTAssertTrue(sut.isLastQuestion())
    }
    
    func testPresenterRestartQuiz() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        sut.correctAnswers = 5
        sut.currentQuestionIndex = 3
        sut.restartQuiz()
        
        XCTAssertEqual(sut.correctAnswers, 0)
        XCTAssertEqual(sut.currentQuestionIndex, 0)
    }
}
