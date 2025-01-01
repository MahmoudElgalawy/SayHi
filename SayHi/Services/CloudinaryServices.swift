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
    static let shared = CloudinaryService()
    
    private init(){
        self.cloudinary = CLDCloudinary(configuration: cloudinaryConfig)
    }
    
    let cloudinaryConfig = CLDConfiguration(
        cloudName: "dg6uctmhd",
        apiKey: "391162217156563",secure: true
    )
    
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
    

    func deleteAllResources() {
        // إعداد بيانات المصادقة
        let cloudName = "dg6uctmhd"
        let apiKey = "391162217156563"
        let apiSecret = "IEtGK_4Q0OybOSCbWXXx9nGdeq8"
        
        // URL لطلب الحذف
        let urlString = "https://api.cloudinary.com/v1_1/\(cloudName)/resources/image"
        guard let url = URL(string: urlString) else { return }
        
        // إعداد طلب HTTP
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let auth = "\(apiKey):\(apiSecret)"
        if let authData = auth.data(using: .utf8) {
            let authBase64 = authData.base64EncodedString()
            request.setValue("Basic \(authBase64)", forHTTPHeaderField: "Authorization")
        }
        
        // إرسال الطلب
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse, let data = data {
                print("Response Code: \(response.statusCode)")
                if let responseData = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseData)")
                }
            }
        }
        task.resume()
    }
}

