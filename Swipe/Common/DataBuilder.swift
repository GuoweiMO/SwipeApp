//
//  DataBuilder.swift
//  Swipe
//
//  Created by Guowei Mo on 22/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class DataBuilder: NSObject {
  
  class func stringfied(fromFile fileName: String) -> String
  {
    let path = Bundle(for: DataBuilder.self).path(forResource: fileName, ofType: "txt")!
    let text: String
    do {
      text = try String(contentsOfFile: path)
    } catch {
      text = ""
    }
    return text
  }
  
  class func cardDicts(fromFile fileName: String) -> [[String: Any]]? {
    let string = stringfied(fromFile: fileName)
    if let data = string.data(using: String.Encoding.utf8) {
      do {
        if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
          guard let response = dict["response"] as? [String: Any],
            let body = response["body"] as? [String: Any]
            else {
              return nil
          }
          var games:[[String: Any]] = [[:]]
          if let game = body["drawGame"] {
            games = convertToArray(fromJSON: game)
          }
          return games
        }
      } catch let error as NSError {
        print(error)
      }
    }
    return nil
  }
 
  class func convertToArray(fromJSON obj: Any) -> [[String: Any]] {
    if let dict = obj as? [String: Any] {
      return [dict]
    }
    
    if let array = obj as? [[String: Any]] {
      return array
    }
    return []
  }

}
