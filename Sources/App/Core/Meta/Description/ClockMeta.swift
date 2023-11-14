//
//  File.swift
//  
//
//  Created by mnats on 14.11.2023.
//

import Foundation

struct ClockMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = """
Manage your time with ease using the \(appName). \(appName) combines all of the functionality you need into one simple, beautiful package.
"""
        return fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "\(appName) shows time."
        return shortDesc1
    }
}
