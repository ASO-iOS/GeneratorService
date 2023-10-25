//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct MoodTrackerMeta: MetaProviderProtocol {
    
    
   
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "Introducing \"\(appName)\" the ultimate app designed to help you understand and manage your emotions effectively. With this powerful tool, you can track your moods, identify patterns, and gain valuable insights into your emotional well-being. Whether you're seeking to improve your mental health, monitor your mood swings, or simply gain a better understanding of yourself, \"\(appName)\" is here to support you every step of the way."
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
         let shortDesc21 =  "The app helps you to track your mood during the week."
         
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
