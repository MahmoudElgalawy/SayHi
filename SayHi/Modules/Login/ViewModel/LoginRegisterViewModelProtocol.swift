//
//  LoginViewModel.swift
//  SayHi
//
//  Created by Mahmoud on 23/12/2024.
//

import Foundation

protocol LoginRegisterViewModelProtocol {
    func register(email: String, password: String, completion: @escaping (_ error:Error?)-> Void)
    func login(email: String, password: String, completion: @escaping (_ error:Error?,_ isEmailVerfied: Bool)-> Void)
    func resendVerficationEmail(email: String, completion: @escaping (_ error:Error?)-> Void)
    func resetPasswordFor(email: String, completion: @escaping (_ error:Error?)-> Void)
}

class LoginRegisterViewModel: LoginRegisterViewModelProtocol {
    let userListener: FUserListener!
    
    init(userListener: FUserListener) {
        self.userListener = userListener
    }
    
    func register(email: String, password: String, completion: @escaping (_ error:Error?)-> Void){
        userListener.registerUserWith(email: email, password: password) {  error in
                completion(error)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (_ error:Error?,_ isEmailVerfied: Bool)-> Void){
        userListener.lohinUserWith(email: email, password: password) { error, isEmailVerfied in
            completion(error,isEmailVerfied)
        }
    }
    
    func resendVerficationEmail(email: String, completion: @escaping (_ error:Error?)-> Void){
        userListener.resendEmailVerfication(email: email) { error in
            completion(error)
        }
    }
    
    func resetPasswordFor(email: String, completion: @escaping (_ error:Error?)-> Void){
        userListener.resetPasswordFor(email: email) { error in
            completion(error)
        }
    }
}
