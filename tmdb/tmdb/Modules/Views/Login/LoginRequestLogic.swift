//
//  RequestsStaticClass.swift
//  TMDB
//
//  Created by Пащенко Иван on 11.04.2024.
//

import Foundation
import Alamofire

//Class with complex query logics
class RequestsStaticClass {
    
    //Static function for user authorization using login and password
    static func loginUser(username: String, password: String, completion: @escaping (Result<ReturnUserDataStruct, Error>) -> ()) {
        
        var session_id: String = ""
        
        //|GET| Getting request token
        RequestClass.request(address: .GetRequestToken, params: .GetRequestTokenParam(.init(requestType: .get))) { (FRresponce: Result<RequestTokenStruct, Error>) in
            
            //In case of successful completion request
            switch FRresponce {
            case .success(let result):
                
                //|POST| Authorization token request together with login and password
                RequestClass.request(address: .CreateRequestToken, params: .CreateRequestTokenParam(.init(requestType: .post, username: username, password: password, requestToken: result.request_token))) { (SRresponce: Result<RequestTokenStruct, Error>) in
                    
                    //In case of successful completion request
                    switch SRresponce {
                    case .success(let result):
                        
                        //|POST| Creting session token
                        RequestClass.request(address: .CreateSessionId, params: .CreateSessionIdParam(.init(requestType: .post, requestToken: result.request_token))) { (Sresponce:Result<SessionIdStruct, Error>) in
                            
                            //In case of successful completion request
                            switch Sresponce {
                            case .success(let result):
                                
                                session_id = result.session_id
                                
                                //|GET| Getting user information
                                RequestClass.request(address: .GetUserInfo, params: .GetUserInfoParam(.init(requestType: .get, sessionId: result.session_id))) { (UIresponce:Result<UserDataStruct, Error>) in
                                    
                                    //In case of successful completion request
                                    switch UIresponce {
                                    case .success(let result):
                                        
                                        completion(.success(ReturnUserDataStruct(session_id: session_id, user_data: result)))
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            case.failure(let error):
                                print(error)
                            }
                        }
                    case.failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
