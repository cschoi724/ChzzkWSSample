//
//  Dictionary.swift
//  ChzzkWSSample
//
//  Created by cschoi on 4/4/24.
//

import Foundation

extension Dictionary {
    func decoded<T: Codable>() -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return try? JSONDecoder().decode(T.self, from: jsonData)
        } else {
            return nil
        }
    }
    
    var jsonString: String? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String(bytes: jsonData, encoding: String.Encoding.utf8)
        } else {
            return nil
        }
    }
}

extension Dictionary {
    
    /// - Description
    ///   - The function will return a value on given keypath
    ///   - if Dictionary is ["team": ["name": "KNR"]]  the to fetch team name pass keypath: team.name
    ///   - If you will pass "team" in keypath it will return  team object
    /// - Parameter keyPath: keys joined using '.'  such as "key1.key2.key3"
    func valueForKeyPath <T> (_ keyPath: String) -> T? {
        let array = keyPath.components(separatedBy: ".")
        return value(array, self) as? T
        
    }
    
    /// - Description:"
    ///   - The function will return a value on given keypath. It keep calling recursively until reach to the keypath. Here are few sample:
    ///   - if Dictionary is ["team": ["name": "KNR"]]  the to fetch team name pass keypath: team.name
    ///   - If you will pass "team" in keypath it will return  team object
    /// - Parameters:
    ///   - keys: array of keys in a keypath
    ///   - dictionary: The dictionary in which value need to find
    private func value(_ keys: [String], _ dictionary: Any?) -> Any? {
        guard let dictionary = dictionary as? [String: Any],  !keys.isEmpty else {
            return nil
        }
        if keys.count == 1 {
            return dictionary[keys[0]]
        }
        return value(Array(keys.suffix(keys.count - 1)), dictionary[keys[0]])
    }
}
