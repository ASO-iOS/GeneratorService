//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct CalendarEventsMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "This application is made so that people can easily and structurally record their activities for the day. Plan events for a week or even a month ahead. Events can be changed and deleted, adding new ones is very simple!"
    
    static let shortDesc21 =  "Write down your events!"
    
    
    static func getFullDesc(appName: String) -> String {
        self.appName = appName
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        self.appName = appName
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
