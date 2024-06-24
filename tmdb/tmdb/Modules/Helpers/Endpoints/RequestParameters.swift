//
//  RequestsParamsStructs.swift
//  TMDB
//
//  Created by Пащенко Иван on 19.04.2024.
//

import Foundation
import Alamofire

struct getGenresListParams {
    let requestType: Alamofire.HTTPMethod
    let language: String
}

struct getMovieParams {
    let requestType: Alamofire.HTTPMethod
}

struct getRequestTokenParams {
    let requestType: Alamofire.HTTPMethod
}

struct createRequestTokenParams {
    let requestType: Alamofire.HTTPMethod
    let username: String
    let password: String
    let requestToken: String
}

struct createSessionIdParams {
    let requestType: Alamofire.HTTPMethod
    let requestToken: String
}

struct getUserInfoParams {
    let requestType: Alamofire.HTTPMethod
    let sessionId: String
}

struct getFavoritesParams {
    let requestType: Alamofire.HTTPMethod
    let sessionId: String
    let sortBy: String
    let page: Int
    let language: String
    let accountId: Int
}

struct getMoviesTrendparams {
    let requestType: Alamofire.HTTPMethod
    let language: String
}

struct addMovieParams {
    let requestType: Alamofire.HTTPMethod
    let accountId: Int
    let sessionId: String
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
}

struct searchMovieParams {
    let requestType: Alamofire.HTTPMethod
    let query: String
}
