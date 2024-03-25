//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Konstantin Lyashenko on 22.03.2024.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isCurrent(_ answers: GameRecord) -> Bool {
        self.correct > answers.correct
    }
}
