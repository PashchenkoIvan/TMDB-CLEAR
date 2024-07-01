//
//  RawBodyParameters.swift
//  tmdb
//
//  Created by Пащенко Иван on 28.06.2024.
//

import Foundation

// MARK: - addRemoveFavoriteMovie
struct addRemoveFavoriteMovie: Codable {
    let mediaType: String
    let mediaID: Int
    let favorite: Bool

    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case favorite
    }
}

