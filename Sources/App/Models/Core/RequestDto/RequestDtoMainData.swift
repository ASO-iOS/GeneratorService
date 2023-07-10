//
//  File.swift
//  
//
//  Created by admin on 29.06.2023.
//

import Foundation

struct RequestDtoMainData: Codable {
    
    let appName: String
    let applicationName: String
    let packageName: String
    let manual: Bool
    let uiDesignId: String?
    let prefix: String?
    let appId: String?
    
    
    enum CodingKeys: String, CodingKey {
        case appName = "app_name"
        case applicationName = "application_name"
        case packageName = "package_name"
        case manual = "manual"
        case uiDesignId = "ui_design_id"
        case prefix = "prefix"
        case appId = "app_id"
    }
}
