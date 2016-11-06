//
//  SWActions.swift
//  Swipe
//
//  Created by Guowei Mo on 26/10/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

let db = FIRDatabase.database().reference()
let uid = UIDevice.current.identifierForVendor?.uuidString
let storage = FIRStorage.storage().reference(forURL: "gs://swipe-3b687.appspot.com")

typealias SWCompletion = (Error?, FIRDatabaseReference) -> Void

class SWActions: NSObject {

  class func createCard(withInfo info: [String: String], andCompletion completion: @escaping SWCompletion) {
    db.child("cards").child(uid!).setValue(info, withCompletionBlock: completion)
  }
  
  class func updateCard(withInfo info: [String: String], andCompletion completion: @escaping SWCompletion) {
    db.child("cards").child(uid!).setValue(info, withCompletionBlock: completion)
  }
  
  class func retrieveMyCard(withCompletion completion: @escaping ([String : AnyObject]) -> Void, andError errorBlock: ((Error) -> Void)? ){
    db.child("cards").child(uid!).observe(.value, with: {
      (snapshot) -> Void in
      if let dataDict = snapshot.value as? [String : AnyObject] {
        completion(dataDict)
      }
    }, withCancel: errorBlock)
  }

  class func uploadProfileImage(withData data: Data, name: String, extra: [String: String] ){
    let metadata = FIRStorageMetadata()
    metadata.customMetadata = extra
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    storage.child("images/\(uid!)/\(name).png").put(data, metadata: metadata) { metadata, error in
      if (error != nil) {
        print(error.debugDescription)
      } else {
        let _ = metadata!.downloadURL
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    }
  }
  
  class func downloadProfileImage(withName name: String, completion: @escaping (Data?, Error?) -> Void){
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    storage.child("images/\(uid!)/\(name).png").data(withMaxSize: 5 * 1024 * 1024, completion: completion)
  }
  
  class func getFileMetadata(ofName name: String, withCompletion completion: @escaping (FIRStorageMetadata?, Error?) -> Void){
    storage.child("images/\(uid!)/\(name).png").metadata(completion: completion)
  }
  
}
