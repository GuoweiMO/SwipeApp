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
  
  class func uploadProfileImage(withData data: Data, name: String){
    storage.child("images/\(uid!)/\(name).png").put(data, metadata: nil) { metadata, error in
      if (error != nil) {
        print(error.debugDescription)
      } else {
        // Metadata contains file metadata such as size, content-type, and download URL.
        let downloadURL = metadata!.downloadURL
        print(downloadURL)
      }
    }
    
  }
  
  
}
