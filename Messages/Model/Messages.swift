//
//  Messages.swift
//  Messages
//
//  Created by Robin He on 11/24/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import Firebase
class Messages : NSObject{
    
    var fromId : String?
    var sendText : String?
    var timeStamp : NSNumber?
    var toId : String?
    
    func getPartnerId() -> String?{
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
}
