//
//  File.swift
//  
//
//  Created by mnats on 13.11.2023.
//

import Foundation

struct ReminderMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = """
\(appName) is your personal planner. From New Year's to-do list to project planner. \(appName) can help you stay on track and improve your productivity.
With the \(appName) app in your pocket, you can easily create to-do lists. Take notes, add alerts/alarms, prioritise and mark the most important items. With built-in filters and calendar view, you can see what's most important and complete tasks.
"""
        return fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "\(appName) is beautiful free and simple notification service."
        return shortDesc1
    }
    
}
