//
//  SWAPI.swift
//  Swipe
//
//  Created by Guowei Mo on 20/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
let db = FIRDatabase.database().reference()
typealias ReceiversCompletion = (Int, [[String : [String : Any]]?]) -> Void
typealias MatchedCompletion = ([SWCard]) -> Void

class Actions: NSObject {
  static let shared = Actions()
  
  func requestToSendCard(withCompletion completion: @escaping ReceiversCompletion, cancelDone cancelled: @escaping (Bool) -> Void ){
    SWCard.myCard.status = .Sending
    db.child("cards").child("\(uid!)/status").setValue(CardStatus.Sending.rawValue, withCompletionBlock: {
      (err, ref) -> Void in
      self.startQuery(withCompletion: completion, cancelDone: cancelled) // repeat query every 5 seconds
    })
  }
  
  func startQuery(withCompletion completion: @escaping ReceiversCompletion, cancelDone cancelled: @escaping (Bool) -> Void ){
    for counter in 0...10 {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(counter) * 3.0 ) {
        print("fired \(counter) times")
        if counter < 10 {
         self.requestReceivers(withCounter: counter, andCompletion: completion)
        } else {
          self.cancelSending(completion: cancelled)
        }
      }
    }
  }
  
  func requestReceivers(withCounter counter: Int,andCompletion completion: @escaping ReceiversCompletion){
    db.child("cards")
      .queryOrdered(byChild: "status")
      .queryEqual(toValue: CardStatus.Sending.rawValue)
      .observe(.value, with: {
        (snapshot) -> Void in
        if let result = snapshot.value as? [String : AnyObject] {
          // [k : [k : v]]
          var outputs: [[String : [String : Any]]] = []
          result.forEach({ (k, v) in
            if let v = v as? [String: Any] {
              if let locString = v["location"] as? String {
                let locs = locString.components(separatedBy: ",")
                guard locs.count == 2 else { return }
                let vLoc = Location(longitude: Double(locs[0])!, latitude: Double(locs[1])!)
                if Locations.shared.isMyLocationInRange(withLocation: vLoc) {
                  outputs.append([k : v])
                }
              }
            }
          })
          completion(counter, outputs) // when counter = 1, counting 30s to like any receiver
        }
      }, withCancel: nil )
  }
  
  func cancelSending(completion done: @escaping (Bool) -> Void) {
    SWCard.myCard.status = .Normal
    db.child("cards").child("\(uid!)/status").setValue(CardStatus.Normal.rawValue, withCompletionBlock: {
      (err, ref) -> Void in
       done(err == nil)
    })
  }
  
  func requestToUpdateLikes() {
    db.child("cards").child("\(uid!)/likes").setValue(SWCard.myCard.likes, withCompletionBlock: {
      (err, ref) -> Void in
    })
  }

  func requestToUpdateContacts() {
    db.child("cards").child("\(uid!)/contacts").setValue(SWCard.myCard.contacts, withCompletionBlock: {
      (err, ref) -> Void in
    })
  }
  
  func startQueryMatched(withCompletion completion: @escaping MatchedCompletion, cancelDone cancelled: @escaping (Bool) -> Void ){
    for counter in 0...10 {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(counter) * 3.0 ) {
        print("fired \(counter) times")
        if counter < 10 {
          self.findReceiverILikedWhoLikesMe(withCounter: counter, andCompletion: completion)
        } else {
          self.cancelSending(completion: cancelled)
        }
      }
    }
  }

  func findReceiverILikedWhoLikesMe(withCounter counter: Int, andCompletion completion: @escaping MatchedCompletion){
    var matchedCards: [SWCard] = []
    SWCard.myCard.likes?.forEach({ (id) in
      db.child("cards").child(id).observe(.value, with: {
        (snapshot) -> Void in
        if let dataDict = snapshot.value as? [String : Any] {
          if let likes = dataDict["likes"] as? [String], likes.contains(uid!) {
            // exchange card with card id
            
            SWCard.myCard.contacts.append(id)
            self.requestToUpdateContacts()
            
            //remove id in likes
            SWCard.myCard.likes!.remove(at: SWCard.myCard.likes!.index(of: id)!)
            self.requestToUpdateLikes()
            
            // create card instance and add it to card array
            let matchedCard = SWCard()
            matchedCard.updateCard(withFullData: dataDict)
            matchedCards.append(matchedCard)
            
          } else {
            // card id still stays in my likes array!
          }
        }
      }, withCancel: nil)
    })
    
    completion(matchedCards) //show the card you have exchanged!!!!!
  }
}
