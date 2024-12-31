//
//  SettingViewModel.swift
//  SayHi
//
//  Created by Mahmoud on 25/12/2024.
//

import Foundation

protocol SettingProtocol {
    func getUserData(completion: @escaping (_ user:User)-> Void)
    func logOut(completion: @escaping (_ error:Error?)-> Void)
}


class SettingViewModel: SettingProtocol {
    
    let userListener: UserListenerProtocol!
  //  let saveFetchUser: SaveUserProtocol!
    
    init(userListener: UserListenerProtocol ) {
        self.userListener = userListener
       // self.saveFetchUser = saveFetchUser
    }
    
    func getUserData(completion: @escaping (_ user:User)-> Void) {
        if let user = userListener.currentUser{
            completion(user)
        }
    }
    
    func logOut(completion: @escaping (_ error:Error?)-> Void) {
        userListener.logOutCurrentUser { error in
            if error == nil {
                completion(error)
            }else{
                print("can not log out: \(error?.localizedDescription ?? "something is wrong")")
            }
        }
    }
}
