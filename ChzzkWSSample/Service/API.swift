//
//  API.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/3/24.
//

import Foundation
import Alamofire

typealias CompletionHandler<T> = (T) -> Void

class API {
    static let shared: API = API()
    var headers = [
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    ]
    
    func getChannelName(streamer id: String, completionHandler: @escaping CompletionHandler<StreamerInfo>) {
        let url = URL(string: "https://api.chzzk.naver.com/service/v1/channels/\(id)")
        let request = AF.request(url!, method: .get)
        
        request.responseDecodable(of: ResponseDTO<StreamerInfo>.self) { response in
            switch response.result {
            case .success(let result):
                print(result.content!)
                completionHandler(result.content)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getChannelInfo(streamer id: String, completionHandler: @escaping CompletionHandler<ChannelInfo?>)  {
        //https://api.chzzk.naver.com/service/v1/channels/554e99695decc451d57788b1fd5d5c07/live-detail
        //https://api.chzzk.naver.com/polling/v2/channels/554e99695decc451d57788b1fd5d5c07/live-status
        let url = URL(string: "https://api.chzzk.naver.com/polling/v2/channels/\(id)/live-status")
        let request = AF.request(url!, method: .get)
        
        request.responseDecodable(of: ResponseDTO<ChannelInfo>.self) { response in
            switch response.result {
            case .success(let result):
                print(result)
                completionHandler(result.content)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAssessToken(chatChannelId id: String, completionHandler: @escaping CompletionHandler<ChatInfo?>) {
        //https://comm-api.game.naver.com/nng_main/v1/chats/access-token?channelId=N18Hwv&chatType=STREAMING
        let url = URL(string: "https://comm-api.game.naver.com/nng_main/v1/chats/access-token?channelId=\(id)&chatType=STREAMING")
        let request = AF.request(url!, method: .get)
        
        request.responseDecodable(of: ResponseDTO<ChatInfo>.self) { response in
            switch response.result {
            case .success(let result):
                print(result)
                completionHandler(result.content)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getStatus(cookies: NIDCookie, completionHandler: @escaping CompletionHandler<UserStatus?>) {
        //https://comm-api.game.naver.com/nng_main/v1/user/getUserStatus
//        {
//            "NID_AUT" : "쿠키값을넣어주세요",
//            "NID_SES" : "쿠키값을넣어주세요"
//        }
        let url = URL(string: "https://comm-api.game.naver.com/nng_main/v1/user/getUserStatus")
        var headers = HTTPHeaders(headers)
        headers.add(name: "Cookie", value: "NID_AUT=" + cookies.NID_AUT + ";NID_SES=" + cookies.NID_SES)
        let request = AF.request(url!, method: .get, headers: headers)
        request.responseDecodable(of: ResponseDTO<UserStatus>.self) { response in
            switch response.result {
            case .success(let result):
                print(result)
                completionHandler(result.content)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
