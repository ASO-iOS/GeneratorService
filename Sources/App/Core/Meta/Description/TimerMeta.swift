//
//  File.swift
//  
//
//  Created by mnats on 14.11.2023.
//

import Foundation

struct TimerMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = """
Create timer to monitor how long it takes to do your work, how long you make a pause or whatever you have to time. The timer keeps running even when you close the application. So there is no need to keep it open all the time.

Timer can be
- created and removed
- started and paused
- reset to 0
"""
        return fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = """
\(appName) is a simple, easy and accurate app for android that will help you to measure the time of any situation, like sports, cooking, games, education, etc.
"""
        return shortDesc1
    }
    
}
