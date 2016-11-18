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

  class func createCard(withInfo info: [String: Any], andCompletion completion: @escaping SWCompletion) {
    db.child("cards").child(uid!).setValue(info, withCompletionBlock: completion)
  }
  
  class func updateCard(withInfo info: [String: Any], andCompletion completion: @escaping SWCompletion) {
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
  
  class func requestToSendCard(withToken token: String, andCompletion completion: @escaping SWCompletion) {
    SWCard.myCard.token = token
    SWCard.myCard.status = .Sending
    db.child("cards").child(uid!).setValue(SWCard.myCard.dictInfo(), withCompletionBlock: completion)
  }
  
  class func sendCardTimeExpires(andCompletion completion: @escaping SWCompletion) {
    SWCard.myCard.token = ""
    SWCard.myCard.status = .Normal
    db.child("cards").child(uid!).setValue(SWCard.myCard.dictInfo(), withCompletionBlock: completion)
  }
  
  class func requestToReceiveCard(withToken token: String, senderFoundCompletion completion: @escaping ([String : AnyObject]) -> Void, andError errorBlock: ((Error) -> Void)?) {
    SWCard.myCard.token = token
    SWCard.myCard.status = .Receiving
    db.child("cards").child(uid!).setValue(SWCard.myCard.dictInfo(), withCompletionBlock: {
      (err, ref) -> Void in
      queryForSender(withToken: token, withCompletion: completion, andError: errorBlock)
    })
  }
  
  class func queryForSender(withToken token: String, withCompletion completion: @escaping ([String : AnyObject]) -> Void, andError errorBlock: ((Error) -> Void)?) {
    db.child("cards").queryOrdered(byChild: "token")
                     .queryEqual(toValue: token)
                     .observe(.value, with: {
                      (snapshot) -> Void in
                        if let results = snapshot.value as? [[String : AnyObject]] {
                          if let senderDict = results.filter({ (dict) -> Bool in
                            return (dict["status"] as? String) == CardStatus.Sending.rawValue
                          }).first {
                            completion(senderDict)
                          } else {
                            print("sender not found")
                          }
                        }
                     }, withCancel: errorBlock )
  }
  
  class func updateContactsWhenCardReceived(fromSender sender: String) {
    let contactsRef = db.child("cards").child("\(uid!)/contacts")
    contactsRef.observe(.value, with: {
      (snapshot) -> Void in
      var contacts = snapshot.value as? [String]
      if contacts != nil {
        contacts!.append(sender)
        print(contacts!)
        contactsRef.setValue(contacts!)
      }
    })
  }
  
  class func retrieveContactList(withCompletion completion:@escaping ([String]) -> Void) {
    let contactsRef = db.child("cards").child("\(uid!)/contacts")
    contactsRef.observe(.value, with: {
      (snapshot) -> Void in
      if let contacts = snapshot.value as? [String] {
        completion(contacts)
      }
    })
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
  
  class func getFileMetadata(ofName name: String, withCompletion completion: @escaping ([String: String]?, Error?) -> Void){
    storage.child("images/\(uid!)/\(name).png").metadata { (data, error) in
      completion(data?.customMetadata, error)
    }
  }
  
}
