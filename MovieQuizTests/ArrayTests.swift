//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Konstantin Lyashenko on 11.04.2024.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    private func testGetValueInRange() throws {
        // Given
        let array = [1, 2, 3, 3, 4, 5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    private func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 2, 3, 3, 4, 5]
        // When
        let value = array[safe: 20]
        // Then
        XCTAssertNil(value)
    }
}

