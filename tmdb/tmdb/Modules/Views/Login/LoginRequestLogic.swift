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
        
        var sessionId: String = ""
        
        //|GET| Getting request token
        RequestClass.request(address: .getRequestToken, params: .getRequestTokenParam(.init(requestType: .get))) { (FRresponce: Result<RequestTokenStruct, Error>) in
            
            //In case of successful completion request
            switch FRresponce {
            case .success(let result):
                
                //|POST| Authorization token request together with login and password
                RequestClass.request(address: .createRequestToken, params: .createRequestTokenParam(.init(requestType: .post, username: username, password: password, requestToken: result.requestToken))) { (SRresponce: Result<RequestTokenStruct, Error>) in
                    
                    //In case of successful completion request
                    switch SRresponce {
                    case .success(let result):
                        
                        //|POST| Creting session token
                        RequestClass.request(address: .createSessionId, params: .createSessionIdParam(.init(requestType: .post, requestToken: result.requestToken))) { (Sresponce:Result<SessionIdStruct, Error>) in
                            
                            //In case of successful completion request
                            switch Sresponce {
                            case .success(let result):
                                
                                sessionId = result.sessionId
                                
                                //|GET| Getting user information
                                RequestClass.request(address: .getUserInfo, params: .getUserInfoParam(.init(requestType: .get, sessionId: result.sessionId))) { (UIresponce:Result<User, Error>) in
                                    
                                    //In case of successful completion request
                                    switch UIresponce {
                                    case .success(let result):
                                        
                                        completion(.success(ReturnUserDataStruct(sessionId: sessionId, userData: result)))
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
