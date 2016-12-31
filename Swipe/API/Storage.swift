//
//  Storage.swift
//  Swipe
//
//  Created by Guowei Mo on 11/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class Storage: NSObject {
  
  static let shared = Storage()
  
  var uid = UIDevice.current.identifierForVendor?.uuidString
  let storage = FIRStorage.storage().reference(forURL: "gs://swipe-3b687.appspot.com")
  
  func uploadProfileImage(withData data: Data, extra: [String: String] ){
    let metadata = FIRStorageMetadata()
    metadata.customMetadata = extra
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    storage.child("images/\(uid!)/profile.png").put(data, metadata: metadata) { metadata, error in
      if (error != nil) {
        print(error.debugDescription)
      } else {
        let _ = metadata!.downloadURL
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    }
  }
  
  func downloadProfileImage(withUID uid: String, completion: @escaping (Data?, Error?) -> Void){
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    storage.child("images/\(uid)/profile.png").data(withMaxSize: 3 * 1024 * 1024, completion: completion)
  }
  
  func getFileMetadata(ofName name: String, withCompletion completion: @escaping ([String: String]?, Error?) -> Void){
    storage.child("images/\(uid!)/\(name).png").metadata { (data, error) in
      completion(data?.customMetadata, error)
    }
  }
}
