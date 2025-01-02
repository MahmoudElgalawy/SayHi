//
//  UserProfileViewModel.swift
//  SayHi
//
//  Created by Mahmoud on 02/01/2025.
//

import Foundation

protocol UserProfileProtocol {
    func getUserData(completion: @escaping (_ user:User)-> Void)
    var user:User!{get set}
}

class UserProfileViewModel:UserProfileProtocol{
    var user:User!
    let userListener: UserListenerProtocol!
    
    init(user: User,userListener: UserListenerProtocol) {
        self.user = user
        self.userListener = userListener
    }
    
    func getUserData(completion: @escaping (_ user:User)-> Void){
        if let user = userListener.currentUser{
            completion(user)
        }
    }
}
