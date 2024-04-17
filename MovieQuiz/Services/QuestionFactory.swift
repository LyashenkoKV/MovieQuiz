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
    
    // MARK: - loadData
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
    // MARK: - requestNextQuestion
    func requestNextQuestion() {
        generateNextQuestion { [weak self] question in
            guard let self = self, let question = question else { return }
            DispatchQueue.main.async {
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    // MARK: - generateNextQuestion
    private func generateNextQuestion(completion: @escaping (QuizQuestion?) -> Void) {
        guard movies.count > 0 else {
            completion(nil)
            return
        }
        guard let randomIndex = generateRandomIndex() else {
            completion(nil)
            return
        }
        guard let movie = movies[safe: randomIndex] else {
            completion(nil)
            return
        }

        let url = movie.resizedImageURL

        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self else { return }

            if let error = error {
                self.errorHandler?(error)
                completion(nil)
                return
            }

            guard let data = data else {
                self.errorHandler?(NetworkError.emptyData)
                completion(nil)
                return
            }

            let randomRating = Int.random(in: 6...9)
            let compare = self.getComparisonString(movieRating: movie.rating, randomRating: randomRating)
            let correctAnswer = self.getCorrectAnswer(movieRating: movie.rating, randomRating: randomRating)

            let text = "Рейтинг этого фильма \(compare) \(randomRating)?"
            let question = QuizQuestion(image: data, text: text, correctAnswer: correctAnswer)
            self.askedQuestions.insert(randomIndex)

            DispatchQueue.main.async {
                completion(question)
            }
        }.resume()
    }
// MARK: - generateRandomIndex
    private func generateRandomIndex() -> Int? {
        var randomIndex: Int
        repeat {
            randomIndex = Int.random(in: 0..<movies.count)
        } while askedQuestions.contains(randomIndex)
        return randomIndex
    }
// MARK: - getComparisonString
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
// MARK: - getCorrectAnswer
    private func getCorrectAnswer(movieRating: String?, randomRating: Int) -> Bool {
        guard let rating = Float(movieRating ?? "") else { return false }
        return rating > Float(randomRating) || rating < Float(randomRating)
    }
// MARK: - resetState
    func resetState() {
        askedQuestions.removeAll()
    }
}
