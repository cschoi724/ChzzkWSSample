//
//  WebSocket.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/3/24.
//

import Foundation
import Starscream


class StarscreamClient {
    var webSocket: WebSocket!
    var delegate: WebSocketDelegate!
    
    func connect() {
        let rand = Int.random(in: 1...10)
        guard let url = URL(string: "wss://kr-ss\(rand).chat.naver.com/chat") else {
            return
        }
        var request = URLRequest(url: url)
        //request.allHTTPHeaderFields = [:]
        webSocket = WebSocket(request: request)
        
        webSocket.delegate = delegate
        webSocket.connect()
    }
    
    func disconnect() {
        if webSocket != nil {
            webSocket.disconnect()
            webSocket = nil
        }
    }
    
    func write(_ string: String) {
        guard let webSocket = self.webSocket else { return }
        print("send: \(string)")
        webSocket.write(string: string)
    }
    

}
