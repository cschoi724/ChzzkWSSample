//
//  RequestMessage.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/4/24.
//

import Foundation


struct RequestRecentChat: Codable {
    var cmd: Int
    var tid: String
    var sid: String
  /*  var bdy:
    
    "cmd"   : CHZZK_CHAT_CMD['request_recent_chat'],
    "tid"   : 2,
    
    "sid"   : self.sid,
    "bdy"   : {
        "recentMessageCount" : 50
    }
    */
    
}
