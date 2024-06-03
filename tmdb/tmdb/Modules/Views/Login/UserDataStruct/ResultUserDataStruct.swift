//
//  ResultUserDataStruct.swift
//  tmdb
//
//  Created by Пащенко Иван on 03.06.2024.
//

import Foundation

struct ReturnUserDataStruct: Encodable, Decodable {
    let session_id: String
    let user_data: UserStruct
}
