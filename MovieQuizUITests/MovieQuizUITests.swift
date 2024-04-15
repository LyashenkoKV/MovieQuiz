//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Konstantin Lyashenko on 11.04.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
         
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPoosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPoosterData)
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
         
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPoosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPoosterData)
    }
    
    func testIndexLabel() {
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "1/10")
    }
    
    func testGameAlert() {
        for _ in 0..<10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        let gameAlert = app.alerts["GameOverAlert"]
        
        XCTAssertEqual(gameAlert.label, "Этот раунд окончен!", "Некорректный заголовок")
        XCTAssertEqual(gameAlert.buttons.firstMatch.label, "Сыграть еще раз", "Некорректный текст кнопки")
    }
    
    func testGameAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let gameAlert = app.alerts["GameOverAlert"]
        gameAlert.buttons.firstMatch.tap()
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(gameAlert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
    func testQuestionLabel() {
        let questionLabel = app.staticTexts["Question"]
        XCTAssertTrue(questionLabel.waitForExistence(timeout: 5), "Лейбл не появился")
        
        let questionText = questionLabel.label
        
        XCTAssertFalse(questionText.isEmpty, "Текст в лейбле отсутствует")
    }
}
