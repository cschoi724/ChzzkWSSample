//
//  Decodable+.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/4/24.
//

import Foundation

extension Decodable where Self: Encodable {
    var jsonString: String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
}
