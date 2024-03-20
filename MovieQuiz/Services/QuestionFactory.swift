//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 18.03.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    private var askedQuestions: Set<Int> = Set()

    static private let quest = "Рейтинг этого фильма больше чем 6?"
    private let questions: [QuizQuestion] = [
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
    
    func requestNextQuestion() {
        guard questions.count > 0 else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        var randomIndex: Int
        
        repeat {
            randomIndex = Int.random(in: 0..<questions.count)
        } while askedQuestions.contains(randomIndex)
        
        let question = questions[safe: randomIndex]
        askedQuestions.insert(randomIndex)
        delegate?.didReceiveNextQuestion(question: question)
    }
    
    func resetState() {
        askedQuestions.removeAll()
    }
}
