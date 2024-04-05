//
//  Message.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/4/24.
//

import Foundation

struct Message<Body: Codable>: Codable {
    var ver: String
    var cmd: Int
    var svcid: String
    var cid: String
    var tid: String
    var bdy: Body!
    
    init(ver: String, cmd: Int, svcid: String, cid: String, tid: String, bdy: Body) {
        self.ver = ver
        self.cmd = cmd
        self.svcid = svcid
        self.cid = cid
        self.tid = tid
        self.bdy = bdy
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Message<Body>.CodingKeys> = try decoder.container(keyedBy: Message<Body>.CodingKeys.self)
        self.ver = (try? container.decode(String.self, forKey: Message<Body>.CodingKeys.ver)) ?? ""
        self.cmd = (try? container.decode(Int.self, forKey: Message<Body>.CodingKeys.cmd)) ?? -1
        self.svcid = (try? container.decode(String.self, forKey: Message<Body>.CodingKeys.svcid)) ?? ""
        self.cid = (try? container.decode(String.self, forKey: Message<Body>.CodingKeys.cid)) ?? ""
        self.tid = (try? container.decode(String.self, forKey: Message<Body>.CodingKeys.tid)) ?? ""
        self.bdy = (try? container.decodeIfPresent(Body.self, forKey: Message<Body>.CodingKeys.bdy))
    }
}


 
struct ConnectBody: Codable {
    var uid: String
    var devType: Int
    var accTkn: String
    var auth: String
}

struct RequestRecentChatBody: Codable {
    var uuid: String
    var sid: String
    var accTkn: String
    var auth: String
}

struct PlainMessage: Codable {
    var ver: String
    var cmd: Int
    var retCode: Int
    var retMsg: String
}

