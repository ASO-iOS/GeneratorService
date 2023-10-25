//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct CalendarEventsMeta: MetaProviderProtocol {
    
    
    
    

    

    
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = "This application is made so that people can easily and structurally record their activities for the day. Plan events for a week or even a month ahead. Events can be changed and deleted, adding new ones is very simple!"
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 =  "Write down your events!"
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
