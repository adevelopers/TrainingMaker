//
//  Uploader.swift
//  TrainingMaker
//
//  Created by Kirill Khudyakov on 22.07.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import Foundation
import Alamofire

class Uploader {
    
    class func upload(file: URL, to serverUrl: String, fileName: String = "data.txt") {
        let parameters = [
            "action":"add",
            "etalon_id":"1",
            "file_name": "data.txt"
        ]
        
        DispatchQueue.main.async {
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(file, withName: "uploadFile", fileName: fileName, mimeType: "text/plain")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: serverUrl)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                        print("progess: \(progress)")
                    })
                    
                    upload.responseJSON { response in
                        print("response: \(response)")
                    }
                    
                case .failure(let encodingError):
                    print("error: \(encodingError)")
                }
            }
        }
    }
    
}
