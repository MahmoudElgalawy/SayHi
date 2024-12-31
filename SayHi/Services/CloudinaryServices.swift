//
//  CloudinaryServices.swift
//  SayHi
//
//  Created by Mahmoud on 28/12/2024.
//

import Foundation
import Cloudinary

protocol CloudinaryServiceProtocol {
    func uploadImageToCloudinary(image: Data, completion: @escaping (String?) -> Void)
    func fetchImageFromCloudinary(url: String,completion: @escaping (_ data:Data?)-> Void)
}

class CloudinaryService: CloudinaryServiceProtocol{
    
    private let cloudinary: CLDCloudinary
    
    let cloudinaryConfig = CLDConfiguration(
        cloudName: "dg6uctmhd",
        apiKey: "391162217156563",secure: true
    )
    
    init() {
        self.cloudinary = CLDCloudinary(configuration: cloudinaryConfig)
    }
    
    func uploadImageToCloudinary(image: Data, completion: @escaping (String?) -> Void) {
        //        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        //            completion(nil)
        //            return
        //        }
        
        // رفع الصورة
        cloudinary.createUploader().upload(data: image, uploadPreset: "SayHiPreset", completionHandler:  { result, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
            } else if let result = result {
                print("Image uploaded successfully: \(result.url ?? "")")
                completion(result.url)
            }
        })
    }
    
    // تحميل الصورة من Cloudinary
    func fetchImageFromCloudinary(url: String,completion: @escaping (_ data:Data?)-> Void) {
        let secureURL = url.replacingOccurrences(of: "http://", with: "https://")
        guard let imageURL = URL(string: secureURL) else { return }
        
        // تحميل الصورة
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if error != nil {
                completion(nil)
            }
            if let data = data {
                completion(data)
            }
        }.resume()
    }
}

