//
//  TestViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 23/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Actions.shared.retrieveMyCard(withCompletion: { (dict) in
      SWCard.myCard.updateCard(withFullData: dict)
    }, andError: nil)
    
    Actions.shared.requestToSendCard(withCompletion: { (cnt, cardDict) in
      if cardDict.count > 0 {
        print("card found")
        cardDict.forEach({ (dict) in
          print(dict![dict!.keys.first!]!.description)
        })
      }
    }, cancelDone: {
      (done) in
      Actions.shared.startQueryMatched(withCompletion: { (cards) in
        if cards.count > 0 {
          print("matched card found")
          cards.forEach({ (card) in
            print(card.dictInfo().description)
          })
        }
      }, cancelDone: { (dict) in
        
      })
    })
    
  }
}
