
//  UserListener.swift
//  BuzzChat
//
//  Created by Mahmoud on 14/12/2024.



import Foundation
import FirebaseAuth

protocol UserListenerProtocol {
    func registerUserWith(email: String, password: String, completion: @escaping (_ error:Error?)-> Void)
    func lohinUserWith(email: String, password: String, completion: @escaping (_ error:Error?,_ isEmailVerfied: Bool)-> Void)
    func resendEmailVerfication(email: String, completion: @escaping (_ error:Error?)-> Void)
    func resetPasswordFor(email: String, completion: @escaping (_ error:Error?)-> Void)
    func logOutCurrentUser(completion: @escaping (_ error:Error?)-> Void)
    func saveUserToFirestore(_ user: User)
    var currentUser: User?{get}
}


class UserListener: UserListenerProtocol{
    let saveUserlocally: SaveUserProtocol!
    static let shared = UserListener()
    private init(){
        saveUserlocally = SaveAndFetchUserLocally.shared
    }
    
    
    var currentUser: User?{
        if Auth.auth().currentUser != nil {
            if let data = UserDefaults.standard.data(forKey: "CurrentUser") {
                let decoder = JSONDecoder ( )
                do {
                    let userObject = try decoder.decode(User.self, from: data)
                    return userObject
                } catch {
                    print("error when fetch Userdata: \(error.localizedDescription)")
                }
            }
        }
        return nil
    }
    
    // Mark:- Login
    
    func lohinUserWith(email: String, password: String, completion: @escaping (_ error:Error?,_ isEmailVerfied: Bool)-> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] (authResult,error)in
            if error == nil && authResult!.user.isEmailVerified{
                completion(error,true)
                self?.downloadUserFromFirestore(userId:  authResult!.user.uid)
            }else{
                completion(error,false)
            }
        }
    }
    
    
    // Mark:- Register
    
    func registerUserWith(email: String, password: String, completion: @escaping (_ error:Error?)-> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] (authResult,error)in
            completion(error)
            if error == nil{
                authResult?.user.sendEmailVerification{ error in
                    completion(error)
                }
            }
            if authResult?.user != nil {
                
                self?.saveUserToFirestore(User(id: authResult!.user.uid, username: email, email: email, pushId: "", avatarLink: "", status: "Hey,Iam use SayHi"))
                
                self?.saveUserlocally.saveUserLocally(User(id: authResult!.user.uid, username: email, email: email, pushId: "", avatarLink: "", status: "Hey,Iam use SayHi"))
            }
        }
    }
    
    // Mark:- Resend Email Verfication
    
    func resendEmailVerfication(email: String, completion: @escaping (_ error:Error?)-> Void) {
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    // Mark:- Reset Password
    
    
    func resetPasswordFor(email: String, completion: @escaping (_ error:Error?)-> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    // Mark:- Log out
    
    func logOutCurrentUser(completion: @escaping (_ error:Error?)-> Void){
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey:"CurrentUser")
            UserDefaults.standard.synchronize()
            completion(nil)
        }catch let error as NSError {
            completion(error)
        }
    }
    
    
    
    func saveUserToFirestore(_ user: User){
        let userDictionary = user.toDictionary()
        
        fireStoreReference(.User).document(user.id).setData(userDictionary){ error in
            if let error = error {
                print("Error saving user to Firestore: \(error.localizedDescription)")
            } else {
                print("User saved successfully to Firestore.")
            }
        }
    }
    
    private func downloadUserFromFirestore(userId: String){
        fireStoreReference(.User).document(userId).getDocument { document, error in
            guard let userDocument = document else{
                print("No Data Found")
                return
            }
            let result = Result{
                try? userDocument.data(as: User.self)
            }
            switch result{
            case .success(let userObject):
                if let user = userObject {
                    self.saveUserlocally.saveUserLocally(user)
                }else{
                    print("Document doesn't excist")
                }
            case .failure(let error):
                print("error decoding user: \(error.localizedDescription)")
            }
        }
    }
}

