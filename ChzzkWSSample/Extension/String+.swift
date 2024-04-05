//
//  String+.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/4/24.
//

import Foundation

extension String {
    func decoded<T: Codable>() -> T? {
        if let data = self.data(using: .utf8),
           let object = try? JSONDecoder().decode(T.self, from: data) {
            return object
        } else {
            return nil
        }
    }
    
    var json: [String: Any]? {
        if let data = self.data(using: .utf8),
           let object = try? JSONSerialization.jsonObject(with: data) {
            return object as? [String: Any]
        } else {
            return nil
        }
    }
}
