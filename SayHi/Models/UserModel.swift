//
//  UserModel.swift
//  BuzzChat
//
//  Created by Mahmoud on 14/12/2024.
//

import Foundation
import FirebaseAuth

struct User: Codable {
    let id : String
    var username: String
    var email: String
    var pushId: String
    var avatarLink: String
    var status: String
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "username": username,
            "email": email,
            "pushId": pushId,
            "avatarLink": avatarLink,
            "status": status
        ]
    }
}






