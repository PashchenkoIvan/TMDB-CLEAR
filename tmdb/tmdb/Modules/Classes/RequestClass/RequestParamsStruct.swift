//
//  RequestsParamsStructs.swift
//  TMDB
//
//  Created by Пащенко Иван on 19.04.2024.
//

import Foundation
import Alamofire

struct GetGenresListParams {
    let requestType: Alamofire.HTTPMethod
    let language: String
}

struct GetMovieParams {
    let requestType: Alamofire.HTTPMethod
}

struct GetRequestTokenParams {
    let requestType: Alamofire.HTTPMethod
}

struct CreateRequestTokenParams {
    let requestType: Alamofire.HTTPMethod
    let username: String
    let password: String
    let requestToken: String
}

struct CreateSessionIdParams {
    let requestType: Alamofire.HTTPMethod
    let requestToken: String
}

struct GetUserInfoParams {
    let requestType: Alamofire.HTTPMethod
    let sessionId: String
}

struct GetFavoritesParams {
    let requestType: Alamofire.HTTPMethod
    let sessionId: String
    let sort_by: String
    let page: Int
    let language: String
    let account_id: Int
}

struct GetMoviesTrendparams {
    let requestType: Alamofire.HTTPMethod
    let language: String
}

struct AddMovieParams {
    let requestType: Alamofire.HTTPMethod
    let account_id: Int
    let session_id: String
    let media_type: String
    let media_id: Int
    let favorite: Bool
}

struct SearchMovieParams {
    let requestType: Alamofire.HTTPMethod
    let query: String
}
