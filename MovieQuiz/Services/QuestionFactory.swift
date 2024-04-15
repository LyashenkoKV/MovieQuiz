//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 18.03.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var askedQuestions: Set<Int> = Set()
    private var movies: [MostPopularMovie] = []
    var errorHandler: ((Error) -> Void)?
    
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading, errorHandler: ((Error) -> Void)?) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
        self.errorHandler = errorHandler
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            guard let question = self.generateNextQuestion() else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }

    private func generateNextQuestion() -> QuizQuestion? {
        guard movies.count > 0 else {
            delegate?.didReceiveNextQuestion(question: nil)
            return nil
        }
        guard let randomIndex = generateRandomIndex() else { return nil }
        guard let movie = movies[safe: randomIndex] else { return nil }
        
        guard let imageData = try? Data(contentsOf: movie.resizedImageURL) else {
            errorHandler?(NetworkError.unknownError)
            return nil
        }
        
        let randomRating = Int.random(in: 6...9)
        let compare = getComparisonString(movieRating: movie.rating, randomRating: randomRating)
        let correctAnswer = getCorrectAnswer(movieRating: movie.rating, randomRating: randomRating)
        
        let text = "Рейтинг этого фильма \(compare) \(randomRating)?"
        let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
        askedQuestions.insert(randomIndex)
        
        return question
    }

    private func generateRandomIndex() -> Int? {
        var randomIndex: Int
        repeat {
            randomIndex = Int.random(in: 0..<movies.count)
        } while askedQuestions.contains(randomIndex)
        return randomIndex
    }

    private func getComparisonString(movieRating: String?, randomRating: Int) -> String {
        guard let rating = Float(movieRating ?? "") else { return "" }
        if rating > Float(randomRating) {
            return "больше"
        } else if rating < Float(randomRating) {
            return "меньше"
        } else {
            return "равен"
        }
    }

    private func getCorrectAnswer(movieRating: String?, randomRating: Int) -> Bool {
        guard let rating = Float(movieRating ?? "") else { return false }
        return rating > Float(randomRating) || rating < Float(randomRating)
    }

    func resetState() {
        askedQuestions.removeAll()
    }
}
