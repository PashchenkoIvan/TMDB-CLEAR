//
//  ResultUserDataStruct.swift
//  tmdb
//
//  Created by Пащенко Иван on 03.06.2024.
//

import Foundation

struct ReturnUserDataStruct: Encodable, Decodable {
    let sessionId: String
    let userData: UserStruct
}
