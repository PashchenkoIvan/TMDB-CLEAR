//
//  StaticMethodsClass.swift
//  tmdb
//
//  Created by Пащенко Иван on 31.05.2024.
//

import Foundation
import UIKit


class StorageService: NSObject {
    public static func getUserData () -> ReturnUserDataStruct? {
        
        var userData: ReturnUserDataStruct?
        
        if let savedData = UserDefaults.standard.object(forKey: "userData") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(ReturnUserDataStruct.self, from: savedData) {
                userData = loadedData
            }
        }
        
        return userData
    }
}
