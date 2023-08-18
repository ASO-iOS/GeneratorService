//
//  File.swift
//  
//
//  Created by admin on 8/17/23.
//

import Foundation

struct MetaChecker: Codable {
    let list: [MetaCheckerItem]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

struct MetaCheckerItem: Codable {
    let appId: String
    let hasMeta: Bool
    
    enum CodingKeys: String, CodingKey {
        case appId = "app_id"
        case hasMeta = "has_meta"
    }
}
