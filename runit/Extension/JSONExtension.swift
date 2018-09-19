//
//  JSONExtension.swift
//  runit
//
//  Created by Denise NGUYEN on 12/11/2017.
//  Copyright © 2017 Denise NGUYEN. All rights reserved.
//

protocol JSONRepresentable {
    var JSONRepresentation: AnyObject { get }
}

protocol JSONSerializable: JSONRepresentable {
}


extension JSONSerializable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            return String(data: data, encoding: String.Encoding.utf8)
        } catch {
            return nil
        }
    }
}
//
//extension Encodable {
//    subscript(key: String) -> Any? {
//        return dictionary[key]
//    }
//    var data: Data {
//        return try! JSONEncoder().encode(self)
//    }
//    var dictionary: [String: Any] {
//        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]
//    }
//}

