//
//  AddFavoriteMovieStruct.swift
//  TMDB
//
//  Created by Пащенко Иван on 01.05.2024.
//

import Foundation

// MARK: - AddFavoriteMovieStruct
struct AddFavoriteMovieStruct: Codable {
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
