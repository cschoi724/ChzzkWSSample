//
//  ChatDTO.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/5/24.
//

import Foundation

struct ChatDTO: Codable {
    var ver: String
    var cmd: Int
    var svcid: String
    var cid: String
    var tid: String
    var bdy: [ChatBody]
    
    init(ver: String, cmd: Int, svcid: String, cid: String, tid: String, bdy: [ChatBody]) {
        self.ver = ver
        self.cmd = cmd
        self.svcid = svcid
        self.cid = cid
        self.tid = tid
        self.bdy = bdy
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ver = (try? container.decode(String.self, forKey: .ver)) ?? ""
        self.cmd = (try? container.decode(Int.self, forKey: .cmd)) ?? 0
        self.svcid = (try? container.decode(String.self, forKey: .svcid)) ?? ""
        self.cid = (try? container.decode(String.self, forKey: .cid)) ?? ""
        self.tid = (try? container.decode(String.self, forKey: .tid)) ?? ""
        self.bdy = (try? container.decodeIfPresent([ChatBody].self, forKey: .bdy)) ?? []
    }
}

extension ChatDTO {
    var domain: ChatMessage {
        let chatBody = bdy.first!
        return ChatMessage(
            svcid: chatBody.svcid,
            cid: chatBody.cid,
            mbrCnt: chatBody.mbrCnt,
            uid: chatBody.uid,
            profile: chatBody.profile.decoded(),
            msg: chatBody.msg,
            msgTypCode: chatBody.msgTypCode,
            msgStatusType: chatBody.msgStatusType,
            extras: chatBody.extras.decoded()
        )
    }
}

struct ChatBody: Codable {
    var svcid: String
    var cid: String
    var mbrCnt: Int
    var uid: String
    var profile: String
    var msg: String
    var msgTypCode: Int
    var msgStatusType: String
    var extras: String
    var ctime: Int
    var utime: Int
    var msgTid: String
    var session: Bool
    var msgTime: Int
    
    init(svcid: String, cid: String, mbrCnt: Int, uid: String, profile: String, msg: String, msgTypCode: Int, msgStatusType: String, extras: String, ctime: Int, utime: Int, msgTid: String, session: Bool, msgTime: Int) {
        self.svcid = svcid
        self.cid = cid
        self.mbrCnt = mbrCnt
        self.uid = uid
        self.profile = profile
        self.msg = msg
        self.msgTypCode = msgTypCode
        self.msgStatusType = msgStatusType
        self.extras = extras
        self.ctime = ctime
        self.utime = utime
        self.msgTid = msgTid
        self.session = session
        self.msgTime = msgTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.svcid = (try? container.decode(String.self, forKey: .svcid)) ?? ""
        self.cid = (try? container.decode(String.self, forKey: .cid)) ?? ""
        self.mbrCnt = (try? container.decode(Int.self, forKey: .mbrCnt)) ?? 0
        self.uid = (try? container.decode(String.self, forKey: .uid)) ?? ""
        self.profile = (try? container.decode(String.self, forKey: .profile)) ?? ""
        self.msg = (try? container.decode(String.self, forKey: .msg)) ?? ""
        self.msgTypCode = (try? container.decode(Int.self, forKey: .msgTypCode)) ?? 0
        self.msgStatusType = (try? container.decode(String.self, forKey: .msgStatusType)) ?? ""
        self.extras = (try? container.decode(String.self, forKey: .extras)) ?? ""
        self.ctime = (try? container.decode(Int.self, forKey: .ctime)) ?? 0
        self.utime = (try? container.decode(Int.self, forKey: .utime)) ?? 0
        self.msgTid = (try? container.decode(String.self, forKey: .msgTid)) ?? ""
        self.session = (try? container.decode(Bool.self, forKey: .session)) ?? false
        self.msgTime = (try? container.decode(Int.self, forKey: .msgTime)) ?? 0
    }
}
