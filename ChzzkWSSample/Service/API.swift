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
    let cookie = JsonLoader.load(type: NIDCookie.self, fileName: "Cookie")!
    lazy var headers: HTTPHeaders = {
        var headers = HTTPHeaders()
        headers.add(name: "Cookie", value: "NID_AUT=" + cookie.NID_AUT + ";NID_SES=" + cookie.NID_SES)
        return headers
    }()
    
    func getChannelName(streamer id: String, completionHandler: @escaping CompletionHandler<StreamerInfo>) {
        let url = URL(string: "https://api.chzzk.naver.com/service/v1/channels/\(id)")
        let request = AF.request(url!, method: .get, headers: headers)
        
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
        let request = AF.request(url!, method: .get, headers: headers)
        
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
        let request = AF.request(url!, method: .get, headers: headers)
        
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
    
    func getStatus(completionHandler: @escaping CompletionHandler<UserStatus?>) {
        //https://comm-api.game.naver.com/nng_main/v1/user/getUserStatus
//        {
//            "NID_AUT" : "쿠키값을넣어주세요",
//            "NID_SES" : "쿠키값을넣어주세요"
//        }
        let url = URL(string: "https://comm-api.game.naver.com/nng_main/v1/user/getUserStatus")
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
