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
    static var apiRequest: String? {
        return ProcessInfo.processInfo.environment["api_request"]
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
    case addRemoveFavoriteMovie(addRemoveMovieParams)
    case searchMovie(searchMovieParams)
}

enum RawBody: Encodable {
    case addRemoveFavoriteMovieRaw(addRemoveFavoriteMovie)
}

class RequestClass {
    
    static func request<T: Codable>(address: Endpoints, params: EndpointParams, rawBody: Parameters? = nil, completion: @escaping (Result<T, Error>) -> ()) {
        var url: String
        var method: HTTPMethod
        var isBody: Bool

        //Selecting the required request
        switch params {
            
        case .addRemoveFavoriteMovie(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)\(param.accountId)/favorite?session_id=\(param.sessionId)"
            method = param.requestType
            isBody = true
            
        case .genresListParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?language=\(param.language)"
            method = param.requestType
            isBody = false
            
        case .getMovieParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)"
            method = param.requestType
            isBody = false
            
        case .getRequestTokenParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)"
            method = param.requestType
            isBody = false
            
        case .createRequestTokenParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?username=\(param.username)&password=\(param.password)&request_token=\(param.requestToken)"
            method = param.requestType
            isBody = false
            
        case .createSessionIdParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?request_token=\(param.requestToken)"
            method = param.requestType
            isBody = false
            
        case .getUserInfoParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?session_id=\(param.sessionId)"
            method = param.requestType
            isBody = false
            
        case .getFavoriteMoviesParam(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)/\(param.accountId)/favorite/movies?language=\(param.language)&page=\(param.page)&sort_by=\(param.sortBy)&session_id=\(param.sessionId)"
            method = param.requestType
            isBody = false
            
        case .getTrendMovies(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?language=\(param.language)"
            method = param.requestType
            isBody = false
            
        case .searchMovie(let param):
            url = "\(DefaultValues.defaultUrl)\(address.rawValue)?query=\(param.query)"
            method = param.requestType
            isBody = false
        }
        
        
        //
        if isBody {
            AF.request(url, method: method, parameters: rawBody, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(DefaultValues.apiRequest! )"])
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        guard let json = value as? [String: Any] else {
                            print("Invalid data format")
                            return
                        }
                        
                        let jsonData = try! JSONSerialization.data(withJSONObject: json)
                        let decoder = JSONDecoder()
                        
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
        } else {
            AF.request(url, method: method, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(DefaultValues.apiRequest!)"])
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        guard let json = value as? [String: Any] else {
                            print("Invalid data format")
                            return
                        }
                        
                        let jsonData = try! JSONSerialization.data(withJSONObject: json)
                        let decoder = JSONDecoder()
                        
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
    
    
    
    //Static request function
    //    static func request<T: Codable>(address: Endpoints, params: EndpointParams, completion: @escaping (Result<T, Error>) -> ()) {
    //        var url:String
    //        var method:HTTPMethod
    //
    //        //Selecting the required request
    //        switch params {
    //
    //            //Preparing query input data to get a list of genres
    //        case .genresListParam(let param):
    //
    //
    ////            let requestBody: [String: Any] = [:]
    //
    //            method = param.requestType
    //
    //            //Preparing query input data to get a list of movies
    //        case .getMovieParam(let param):
    //
    //
    //            //Preparation of request input data to receive a request token
    //        case .getRequestTokenParam(let param):
    //
    //
    //            //Preparation of request input data for request token authentication
    //        case .createRequestTokenParam(let param):
    //
    //
    //            //Preparation of request input data for creating a session token
    //        case .createSessionIdParam(let param):
    //
    //
    //            //Retrieving user information using session ID
    //        case .getUserInfoParam(let param):
    //
    //
    //            //Fetching a user's favorite movies list with pagination and sorting options
    //        case .getFavoriteMoviesParam(let param):
    //
    //
    //            //Getting trending movies based on language preference
    //        case .getTrendMovies(let param):
    //
    //
    //            //Adding or removing a movie from the user's favorites list
    //        case .addFavoriteMovie(let param):
    //
    //
    //            //Searching for movies using a query string
    //        case .searchMovie(let param):
    //
    //
    //        case .removeFavoriteMovie(let param):
    //            url = "\(DefaultValues.defaultUrl)\(address.rawValue)\(param.accountId)/favorite?api_key=\(DefaultValues.apiKey!)&media_type=\(param.mediaType)&media_id=\(param.mediaId)&favorite=false&session_id=\(param.sessionId)"
    //
    ////            requestBody: [String: Any] = [
    ////                "media_type": param.mediaType,
    ////                "media_id": param.mediaId,
    ////                "favorite": false
    ////            ]
    //
    //            method = param.requestType
    //        }
    //
    //    }
}
