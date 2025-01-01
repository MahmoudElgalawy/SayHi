//
//  UsersViewModel.swift
//  SayHi
//
//  Created by Mahmoud on 01/01/2025.
//

import Foundation

protocol UsersProtocol {
    func getAllUsers()
    func getUserData(completion: @escaping (_ user:User)-> Void)
    func filterUsers(by searchText: String)
    var users:[User]?{get set}
    var filteredUsers:[User]?{get set}
    var bindUsersToViewController : (()->()) {get set}
}

class UsersViewModel: UsersProtocol{
    var bindUsersToViewController : (()->()) = {}
    let userListener: UserListenerProtocol!
    var users: [User]? = []
    var filteredUsers:[User]?
    
    init(userListener: UserListenerProtocol ) {
        self.userListener = userListener
    }
    func getAllUsers(){
        userListener.downloadAllUsersFromFirestore { [weak self] allUsers in
            //DispatchQueue.main.async {
            self?.users = allUsers
            self?.filteredUsers = allUsers
            self?.bindUsersToViewController()
            // }
        }
    }
    
    func getUserData(completion: @escaping (_ user:User)-> Void) {
        if let user = userListener.currentUser{
            completion(user)
        }
    }
    
    func filterUsers(by searchText: String){
        if searchText.isEmpty {
            users = filteredUsers
        }else{
            users = filteredUsers?.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
        bindUsersToViewController()
    }
}
