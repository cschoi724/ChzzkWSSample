//
//  ChatMessage.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/4/24.
//

import Foundation

struct ChatMessage: Codable {
    var svcid: String
    var cid: String
    var mbrCnt: Int
    var uid: String
    var profile: ChatProfile!
    var msg: String
    var msgTypCode: Int
    var msgStatusType: String
    var extras: Extra!
    
   /* var
    "uid":"8c5d047b4ecf5a49d747ed4bf632aa84",
    "profile":"{\"userIdHash\":\"8c5d047b4ecf5a49d747ed4bf632aa84\",\"nickname\":\"치킨먹는 암살자 9930\",\"profileImageUrl\":\"\",\"userRoleCode\":\"common_user\",\"badge\":null,\"title\":null,\"verifiedMark\":false,\"activityBadges\":[],\"streamingProperty\":{}}",
    "msg":"거 k계열 총기는 안다룹니까 게임",
    "msgTypeCode":1,
    "msgStatusType":"NORMAL",
    "extras":"{\"chatType\":\"STREAMING\",\"emojis\":{},\"osType\":\"AOS\",\"streamingChannelId\":\"55e243bd868e55adf3524c85f8db51b5\",\"extraToken\":\"Wg2Lvea5OzC7bsX9Aq7+OUt5st+bDzTmd4m2H3rgC09eewQcEjbgBWtjdYju0om7yLZA4fJ6dhAShIbUFHco\\/w==\"}",
    "ctime":1712199137274,
    "utime":1712199137274,
    "msgTid":null,
    "session":false,
    "msgTime":1712199137274*/
}

struct ChatProfile: Codable {
    var userIdHash: String
    var nickname: String
    var profileImageUrl: String
}

struct Extra: Codable {
    var chatType: String
    var osType: String
    var streamingChannelId: String
    var extraToken: String
}
