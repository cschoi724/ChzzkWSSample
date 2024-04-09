//
//  ChatClient.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/4/24.
//

import UIKit
import Starscream
import Alamofire

protocol ChatClientDelegate {
    func client(_ client: ChatClient, receive: ChatMessage)
    func client(_ client: ChatClient, receive: [ChatMessage])
}

class ChatClient {
    var streamerID: String
    var chatInfo: ChatInfo!
    var channelInfo: ChannelInfo!
    var userStatus: UserStatus!
    var client: StarscreamClient
    var delegate: ChatClientDelegate!
    var sid: String = ""
    
    init(
        streamerID: String
    ) {
        self.streamerID = streamerID
        self.client = StarscreamClient()
        self.client.delegate = self
        self.setup()
    }
    
    func setup() {
        API.shared.getStatus() { userStatus in
            self.userStatus = userStatus
        }
        
        API.shared.getChannelInfo(streamer: streamerID) { info in
            self.channelInfo = info
            guard let info = info else { return }
            API.shared.getAssessToken(
                chatChannelId: info.chatChannelId,
                completionHandler: { info in
                    self.chatInfo = info
                }
            )
        }
    }
    
    func connect() {
        client.connect()
    }
    
    func join() {
        let request: [String: Any] = [
            "ver": "2",
            "cmd": Command.connect.rawValue,
            "svcid": "game",
            "cid": channelInfo.chatChannelId,
            "tid": 1,
            "bdy": [
                "uid": userStatus.userIdHash,
                "devType": 2001,
                "accTkn": chatInfo.accessToken,
                "auth": userStatus.userIdHash.isEmpty ? "READ" : "SEND"
            ]
        ]
        if let string = request.jsonString {
            client.write(string)
        }
    }
    
    func requestRecentChat(sid: String) {
        let request: [String: Any] = [
            "ver"   : "2",
            "svcid" : "game",
            "cid"   : channelInfo.chatChannelId,
            "cmd": Command.requestRecentChat.rawValue,
            "tid": "2",
            "sid": sid,
            "bdy": [
                "recentMessageCount": 50
            ]
        ]
        if let string = request.jsonString {
            client.write(string)
        }
    }
    
    func ping() {
        let request: [String: Any] = [
            "ver"   : "2",
            "cmd": Command.ping.rawValue
        ]
        if let string = request.jsonString {
            client.write(string)
        }
    }
    
    func pong() {
        let request: [String: Any] = [
            "ver"   : "2",
            "cmd": Command.pong.rawValue
        ]
        if let string = request.jsonString {
            client.write(string)
        }
    }
    
    func sendChat(_ msg: String) {
        let request: [String: Any] = [
            "ver"   : "2",
            "svcid" : "game",
            "cmd": Command.send_chat.rawValue,
            "cid"   : channelInfo.chatChannelId,
            "tid"   : 3,
            "retry" : false,
            "sid"   : sid,
            "bdy"   : [
                //"uid" : userStatus.userIdHash,
                "msg"           : msg,
                "msgTypeCode"   : 1,
                "extras"        : [
                    "chatType"          : "STREAMING",
                    "emojis"            : "",
                    "osType"            : "PC",
                    "extraToken"        : chatInfo.extraToken,
                    "streamingChannelId": channelInfo.chatChannelId
                ],
                "msgTime"       : Int(Date().timeIntervalSince1970)
            ]
        ]

        if let string = request.jsonString {
            client.write(string)
        }
    }
    
    func receiveChat() {
        
    }
}

extension ChatClient: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected:
            join()
            print("connected")
        case .disconnected:
            print("disconnected")
        case .text(let string):
            print("text: \(string)")
            guard let dic = string.json,
                  let cmd = dic["cmd"] as? Int else {
                return
            }
            
            let command = Command(rawValue: cmd)
            switch command {
            case .connected:
                if let sid: String = dic.valueForKeyPath("bdy.sid") {
                    self.sid = sid
                    print(sid)
                    //requestRecentChat(sid: sid)
                }
            case .messageList:
                break
            case .ping:
                pong()
            case .pong:
                ping()
            case .send_chat:
                break
            case .chat:
                if let dto: ChatDTO = string.decoded() {
                    delegate.client(self, receive: dto.domain)
                }
            case .donation:
                break
            default:
                break
            }
        case .error(let error):
            if let error = error {
                print("error: \(error)")
            }
        default:
            break
        }
    }
}
