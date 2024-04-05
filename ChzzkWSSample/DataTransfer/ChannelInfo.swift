//
//  ChannelInfo.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/3/24.
//

import Foundation

struct ChannelInfo: Codable {
    var chatChannelId: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chatChannelId = (try? container.decode(String.self, forKey: .chatChannelId)) ?? "없음"
    }
}

/*
 "liveTitle": "[4관 65시간+@] 카드팩 왜안팜?? ",
         "status": "OPEN",
         "concurrentUserCount": 1270,
         "accumulateCount": 6322,
         "paidPromotion": false,
         "adult": false,
         "chatChannelId": "N18M8n",
         "categoryType": "GAME",
         "liveCategory": "Lost_Ark",
         "liveCategoryValue": "로스트아크",
         "livePollingStatusJson": "{\"status\": \"STARTED\", \"isPublishing\": true, \"playableStatus\": \"PLAYABLE\", \"trafficThrottling\": -1, \"callPeriodMilliSecond\": 10000}",
         "faultStatus": null,
         "userAdultStatus": "NOT_LOGIN_USER",
         "chatActive": true,
         "chatAvailableGroup": "ALL",
         "chatAvailableCondition": "NONE",
         "minFollowerMinute": 0,
         "chatDonationRankingExposure": false
 */
