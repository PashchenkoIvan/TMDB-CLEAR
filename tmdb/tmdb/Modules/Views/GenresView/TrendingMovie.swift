//
//  TrendingMovieStruct.swift
//  TMDB
//
//  Created by Пащенко Иван on 25.04.2024.
//

import Foundation


struct TrendingMovieStruct: Codable {
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
