//
//  ReturnUserDataStruct.swift
//  TMDB
//
//  Created by Пащенко Иван on 17.04.2024.
//

import Foundation


struct ReturnUserDataStruct: Encodable, Decodable {
    let session_id: String
    let user_data: UserDataStruct
}
