//
//  Status.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/3/24.
//

import Foundation

struct UserStatus: Codable {
    var hasProfile: Bool
    var userIdHash: String
    var nickname: String
    var profileImageUrl: String
    var officialNotiAgree: Bool
    var verifiedMark: Bool
    var loggedIn: Bool
}
/*
"hasProfile": true,
    "userIdHash": "59773ffc36d6c55e75e92b7f8169d9aa",
    "nickname": "오늘만사는 초보 9238",
    "profileImageUrl": "https://ssl.pstatic.net/cmstatic/nng/img/img_anonymous_square_gray_opacity2x.png",
    "penalties": [],
    "officialNotiAgree": false,
    "officialNotiAgreeUpdatedDate": null,
    "verifiedMark": false,
    "loggedIn": true
*/
