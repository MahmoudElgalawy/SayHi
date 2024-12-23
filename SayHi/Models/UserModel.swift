//
//  UserModel.swift
//  BuzzChat
//
//  Created by Mahmoud on 14/12/2024.
//

import Foundation

struct User: Codable {
    let id : String
    let username: String
    let email: String
    let pushId: String
    let avatarLink: String
    let status: String
    
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

