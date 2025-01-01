//
//  EditProfileViewModel.swift
//  SayHi
//
//  Created by Mahmoud on 26/12/2024.
//

import Foundation
import Cloudinary

protocol EditProfileProtocol {
    func getUserData(completion: @escaping (_ user:User)-> Void)
    func saveUserLocally(user: User)
    func saveUserToFirestore(_ user: User)
    // func saveImage(image: Data?)
    //    func getImage() -> Data?
    func uploadImage(image:Data, completion: @escaping (_ success: Bool) -> Void)
    func getImage(url: String,completion: @escaping (_ data:Data?)-> Void)
}

class EditProfileViewModel:EditProfileProtocol{
    let saveFetchUser: SaveUserProtocol!
    let userListener: UserListenerProtocol!
    let cloudinary:CloudinaryServiceProtocol!
    
    init(saveFetchUser: SaveUserProtocol,userListener: UserListenerProtocol,cloudinary: CloudinaryServiceProtocol) {
        self.saveFetchUser = saveFetchUser
        self.userListener = userListener
        self.cloudinary = cloudinary
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
    
    //    func saveImage(image: Data?){
    //        if let image = image {
    //                UserDefaults.standard.set(image, forKey: "storedImage")
    //        }
    //    }
    
    //    func getImage() -> Data?{
    //        guard let imageData = UserDefaults.standard.data(forKey: "storedImage") else{return nil}
    //        return imageData
    //    }
    
    func getImage(url: String,completion: @escaping (_ data:Data?)-> Void){
        cloudinary.fetchImageFromCloudinary(url: url) { data in
            completion(data)
        }
    }
    
    func uploadImage(image:Data, completion: @escaping (_ success: Bool) -> Void){
        let dispatchGroup = DispatchGroup()
        var uploadSuccess = false
        dispatchGroup.enter()
        cloudinary.uploadImageToCloudinary(image: image) { [weak self] url in
            guard let url = url else {
                       dispatchGroup.leave()
                       return
                   }
            if var user = self?.userListener.currentUser{
                user.avatarLink = url
                self?.saveUserLocally(user: user)
                self?.saveUserToFirestore(user)
                uploadSuccess = true
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
                completion(uploadSuccess)
            }
    }
}
