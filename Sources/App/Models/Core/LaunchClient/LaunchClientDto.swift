//
//  File.swift
//  
//
//  Created by admin on 25.08.2023.
//

import Foundation

struct LaunchClientDto: Codable {
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}
