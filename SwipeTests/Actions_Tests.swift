//
//  Actions_Tests.swift
//  Swipe
//
//  Created by Guowei Mo on 21/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import XCTest
@testable import Swipe

class Actions_Tests: XCTestCase {
  let action = Actions.shared
  let testUIDs = ["test1", "test2", "test3", "test4"]
  var testCards: [SWCard] = []
  override func setUp() {
    super.setUp()
    for i in 1...4 {
      let card = SWCard()
      let dict = DataBuilder.cardDicts(fromFile: "sample_card")!.first!
      card.updateCard(withFullData: dict)
      testCards.append(card)
      Actions.shared.uid = testUIDs[i]
      Actions.shared.createCard(withInfo: dict, andCompletion: { (err, ref) in
        
      })
    }
  }
  
  func testCanRetrieveCard() {
    Actions.shared.retrieveMyCard(withCompletion: { (dict) in
      
    }, andError: nil)
  }
  
}
 
