//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct ReactionTestMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a fun and engaging mobile application designed to test and improve your reaction time. With \(appName), you can challenge yourself, compete with friends, and enhance your reflexes in a simple and entertaining way. The app features a sleek and intuitive interface. It measures the time it takes for you to react to visual stimuli and provides instant feedback on your performance."
    
    static let shortDesc21 =  "The app checks your reaction."
    
    
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
