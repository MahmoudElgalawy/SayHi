//
//  SaveUserLocally.swift
//  SayHi
//
//  Created by Mahmoud on 23/12/2024.
//

import Foundation

protocol SaveUser {
    func saveUserLocally(_ user: User)
}


class SaveUserLocally: SaveUser {
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
