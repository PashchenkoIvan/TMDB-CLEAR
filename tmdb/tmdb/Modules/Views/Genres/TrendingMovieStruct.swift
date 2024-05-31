//
//  TrendingMovieStruct.swift
//  TMDB
//
//  Created by Пащенко Иван on 25.04.2024.
//

import Foundation


struct TrendingMovieStruct: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
