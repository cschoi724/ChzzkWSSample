//
//  Command.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/3/24.
//

import Foundation

enum Command: Int {
    case connect = 100
    case requestRecentChat = 5101
    case ping = 0
    case pong = 10000
    case send_chat = 3101
    case chat = 93101
    case donation = 93102
    case connected = 10100
    case messageList = 15101
}
