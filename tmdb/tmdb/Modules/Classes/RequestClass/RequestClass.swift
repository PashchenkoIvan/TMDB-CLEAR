//
//  RequestClass.swift
//  tmdb
//
//  Created by Пащенко Иван on 28.05.2024.
//

import Foundation
import Alamofire

enum DefaultValues {
    static var apiKey: String? {
        return ProcessInfo.processInfo.environment["api_key"]
    }
    static let defaultUrl: String = "https://api.themoviedb.org/3/"
}

//Data type for selecting the request address
enum Address: String {
    case GenresList = "genre/movie/list"
    case MovieList = "discover/movie"
    case GetRequestToken = "authentication/token/new"
    case CreateRequestToken = "authentication/token/validate_with_login"
    case CreateSessionId = "authentication/session/new"
    case GetUserInfo = "account"
    case GetFavoriteMovies = "account/"
    case GetTrendMovies = "trending/movie/day"
    case searchMovie = "search/movie"
}

//Data type for selecting the type of request input parameters
enum Params {
    case GenresListParam(GetGenresListParams)
    case GetMovieParam(GetMovieParams)
    case GetRequestTokenParam(GetRequestTokenParams)
    case CreateRequestTokenParam(CreateRequestTokenParams)
    case CreateSessionIdParam(CreateSessionIdParams)
    case GetUserInfoParam(GetUserInfoParams)
    case GetFavoriteMoviesParam(GetFavoritesParams)
    case GetTrendMovies(GetMoviesTrendparams)
    case AddFavoriteMovie(AddMovieParams)
    case searchMovie(SearchMovieParams)
}

class RequestClass {
    
    //Static request function
    static func request<T: Codable>(address: Address, params: Params, completion: @escaping (Result<T, Error>) -> ()) {
        var url:String
        var method:HTTPMethod
        
        //Selecting the required request
        switch params {
            
        //Preparing query input data to get a list of genres
        case .GenresListParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&language=\(param.language)"
            method = param.requestType
            
        //Preparing query input data to get a list of movies
        case .GetMovieParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)"
            method = param.requestType
            
        //Preparation of request input data to receive a request token
        case .GetRequestTokenParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)"
            method = param.requestType
            
        //Preparation of request input data for request token authentication
        case .CreateRequestTokenParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&username=\(param.username)&password=\(param.password)&request_token=\(param.requestToken)"
            method = param.requestType
            
        //Preparation of request input data for creating a session token
        case .CreateSessionIdParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&request_token=\(param.requestToken)"
            method = param.requestType
            
        //Retrieving user information using session ID
        case .GetUserInfoParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&session_id=\(param.sessionId)"
            method = param.requestType
            
        //Fetching a user's favorite movies list with pagination and sorting options
        case .GetFavoriteMoviesParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)/\(param.account_id)/favorite/movies?api_key=\(DefaultValues.apiKey!)&language=\(param.language)&page=\(param.page)&sort_by=\(param.sort_by)&session_id=\(param.sessionId)"
            method = param.requestType
            
        //Getting trending movies based on language preference
        case .GetTrendMovies(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?api_key=\(DefaultValues.apiKey!)&language=\(param.language)"
            method = param.requestType
            
        //Adding or removing a movie from the user's favorites list
        case .AddFavoriteMovie(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)\(param.account_id)/favorite?api_key=\(DefaultValues.apiKey!)&media_type=\(param.media_type)&media_id=\(param.media_id)&favorite=\(param.favorite)&session_id=\(param.session_id)"
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

