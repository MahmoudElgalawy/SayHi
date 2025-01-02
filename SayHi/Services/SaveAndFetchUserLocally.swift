//
//  SaveUserLocally.swift
//  SayHi
//
//  Created by Mahmoud on 23/12/2024.
//

import Foundation
import FirebaseAuth

protocol SaveUserProtocol {
    func saveUserLocally(_ user: User)
}


class SaveAndFetchUserLocally: SaveUserProtocol {
    
    static let shared = SaveAndFetchUserLocally()
    private init(){}
    
    func saveUserLocally(_ user: User){
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(user)
            UserDefaults.standard.setValue(data, forKey: "CurrentUser")
        }catch{
            print("Error saving user to UserDefault: \(error.localizedDescription)")
        }
    }
}
