//
//  ResponseDTO.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/3/24.
//

import Foundation

struct ResponseDTO<Content: Codable>: Codable {
    let code: Int
    let message: String
    let content: Content!
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? -1
        content = (try? values.decode(Content.self, forKey: .content)) ?? nil
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
    }
}
