//
//  DummyUsers.swift
//  SayHi
//
//  Created by Mahmoud on 01/01/2025.
//

import Foundation
import UIKit

struct DummyUsers{
    let cloudinaryService: CloudinaryServiceProtocol
    let UserListener: UserListenerProtocol
     func createDummyUsers() {
        print("Creating dummy users...")
        
        // أسماء المستخدمين الوهميين
        let names = ["Mohamed Ahmed", "Ahmed Alaa", "Mahmoud Abdallah", "Aya Ali", "Yasser Amar","Salma Zyad","Logy Sleem","Fathy Ali"]
        
        var imageIndex = 1
        var userIndex = 1
        
        for i in 0..<8 {

            let id = UUID().uuidString
           
            if let image = UIImage(named: "User\(imageIndex)") {

                cloudinaryService.uploadImageToCloudinary(image: image.pngData()!) { avatarLink in
                    
                    UserListener.saveUserToFirestore(User(
                        id: id,
                        username: names[i],
                        email: "user\(userIndex)@mail.com",
                        pushId: "",
                        avatarLink: avatarLink ?? "",
                        status: "No Status"
                    ))
                    userIndex += 1
                }
            } else {
                print("Error: Image user\(imageIndex) not found.")
            }
                      
            imageIndex += 1
//                    if imageIndex == 8 {
//                        imageIndex = 1
//                    }
        }
    }

}
