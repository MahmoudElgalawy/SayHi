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
        let names = ["Mohamed", "Ahmed", "Mahmoud", "Aya", "Yasser","Salma","Logy","Ali"]
        
        var imageIndex = 1
        var userIndex = 1
        
        for i in 0..<8 {

            let id = UUID().uuidString
           
            if let image = UIImage(named: "User\(imageIndex)") {
//                FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
//                    // إنشاء كائن المستخدم
//                    let user = User(
//                        id: id,
//                        username: names[i],
//                        email: "user\(userIndex)@mail.com",
//                        pushId: "",
//                        avatarLink: avatarLink ?? "",
//                        status: "No Status"
//                    )
//                    
//                    // حفظ المستخدم في Firestore
//                    FUserListener.shared.saveUserToFirestore(user)
//                    
//                    // زيادة مؤشر المستخدم
//                    userIndex += 1
//                }
                cloudinaryService.uploadImageToCloudinary(image: image.pngData()!) { avatarLink in
                    let user = User(
                        id: id,
                        username: names[i],
                        email: "user\(userIndex)@mail.com",
                        pushId: "",
                        avatarLink: avatarLink ?? "",
                        status: "No Status"
                    )
                    UserListener.saveUserToFirestore(user)
                    userIndex += 1
                }
            } else {
                print("Error: Image user\(imageIndex) not found.")
            }
                      
            if imageIndex < 8 {
                imageIndex += 1
            }
        }
    }

}
