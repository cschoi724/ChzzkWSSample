//
//  ChatInfo.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/3/24.
//

import Foundation

struct ChatInfo: Codable {
    var accessToken: String
    var extraToken: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = (try? container.decode(String.self, forKey: .accessToken)) ?? ""
        self.extraToken = (try? container.decode(String.self, forKey: .extraToken)) ?? ""
    }
}
