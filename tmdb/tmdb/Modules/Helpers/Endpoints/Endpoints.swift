//
//  Endpoints.swift
//  tmdb
//
//  Created by Пащенко Иван on 06.06.2024.
//

import Foundation
import Alamofire

enum DefaultValues {
    static var apiKey: String? {
        return ProcessInfo.processInfo.environment["api_key"]
    }
    static let defaultUrl: String = "https://api.themoviedb.org/3/"
    static let defaultImageUrl: String = "https://image.tmdb.org/t/p/original"
}

//Data type for selecting the request address
enum Endpoints: String {
    case genresList = "genre/movie/list"
    case movieList = "discover/movie"
    case getRequestToken = "authentication/token/new"
    case createRequestToken = "authentication/token/validate_with_login"
    case createSessionId = "authentication/session/new"
    case getUserInfo = "account"
    case getFavoriteMovies = "account/"
    case getTrendMovies = "trending/movie/day"
    case searchMovie = "search/movie"
}

//Data type for selecting the type of request input parameters
enum EndpointParams {
    case genresListParam(getGenresListParams)
    case getMovieParam(getMovieParams)
    case getRequestTokenParam(getRequestTokenParams)
    case createRequestTokenParam(createRequestTokenParams)
    case createSessionIdParam(createSessionIdParams)
    case getUserInfoParam(getUserInfoParams)
    case getFavoriteMoviesParam(getFavoritesParams)
    case getTrendMovies(getMoviesTrendparams)
    case addFavoriteMovie(addMovieParams)
    case searchMovie(searchMovieParams)
}


class RequestClass {
    //Static request function
    static func request<T: Codable>(address: Endpoints, params: EndpointParams, completion: @escaping (Result<T, Error>) -> ()) {
        var url:String
        var method:HTTPMethod
        
        //Selecting the required request
        switch params {
            
            //Preparing query input data to get a list of genres
        case .genresListParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&language=\(param.language)"
            method = param.requestType
            
            //Preparing query input data to get a list of movies
        case .getMovieParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)"
            method = param.requestType
            
            //Preparation of request input data to receive a request token
        case .getRequestTokenParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)"
            method = param.requestType
            
            //Preparation of request input data for request token authentication
        case .createRequestTokenParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&username=\(param.username)&password=\(param.password)&request_token=\(param.requestToken)"
            method = param.requestType
            
            //Preparation of request input data for creating a session token
        case .createSessionIdParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&request_token=\(param.requestToken)"
            method = param.requestType
            
            //Retrieving user information using session ID
        case .getUserInfoParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&session_id=\(param.sessionId)"
            method = param.requestType
            
            //Fetching a user's favorite movies list with pagination and sorting options
        case .getFavoriteMoviesParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)/\(param.accountId)/favorite/movies?api_key=\(DefaultValues.apiKey!)&language=\(param.language)&page=\(param.page)&sort_by=\(param.sortBy)&session_id=\(param.sessionId)"
            method = param.requestType
            
            //Getting trending movies based on language preference
        case .getTrendMovies(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&language=\(param.language)"
            method = param.requestType
            
            //Adding or removing a movie from the user's favorites list
        case .addFavoriteMovie(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)\(param.accountId)/favorite?api_key=\(DefaultValues.apiKey!)&media_type=\(param.mediaType)&media_id=\(param.mediaId)&favorite=\(param.favorite)&session_id=\(param.sessionId)"
            method = param.requestType
            
            //Searching for movies using a query string
        case .searchMovie(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&query=\(param.query)"
            method = param.requestType
        }
        
        //
        AF.request(url, method: method)
            .validate()
            .responseJSON { responce in
                switch responce.result {
                    //
                case .success(let value):
                    guard let json = value as? [String: Any] else {
                        print("Invalid data format")
                        return
                    }
                    
                    //
                    let jsonData = try! JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    
                    //
                    do {
                        let resultData = try decoder.decode(T.self, from: jsonData)
                        completion(.success(resultData))
                    } catch {
                        print("Decode error: \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
}
