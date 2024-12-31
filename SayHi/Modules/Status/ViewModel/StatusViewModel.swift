//
//  StatusViewModel.swift
//  SayHi
//
//  Created by Mahmoud on 28/12/2024.
//

import Foundation

protocol StatusProtocol{
    func getUserData(completion: @escaping (_ user:User)-> Void)
    func saveUserLocally(user: User)
    func saveUserToFirestore(_ user: User)
    var statusArr: [String] {get}
}

class StatusViewModel: StatusProtocol {
    var statusArr = ["Available","Busy","At School","In The Cinema","At Work","The Battery Is about To Run Out","At a Meeting","At The Sports Club","sleeping","Emergency Calls Only"]
    let userListener: UserListenerProtocol!
    let saveFetchUser: SaveUserProtocol!
    
    init(userListener: UserListenerProtocol,saveFetchUser: SaveUserProtocol) {
        self.userListener = userListener
        self.saveFetchUser = saveFetchUser
    }
    
    func getUserData(completion: @escaping (_ user:User)-> Void){
        if let user = userListener.currentUser{
            completion(user)
        }
    }
    
    func saveUserLocally(user: User){
        saveFetchUser.saveUserLocally(user)
    }
    
    func saveUserToFirestore(_ user: User){
        userListener.saveUserToFirestore(user)
    }
}
