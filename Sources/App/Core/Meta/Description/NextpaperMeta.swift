//
//  File.swift
//  
//
//  Created by admin on 8/23/23.
//

import Foundation

struct NextpaperMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a mobile app that brings you the latest breaking news from around the world. With \(appName), you can stay up-to-date on the latest events, and get the most important news stories as they happen. "
    
    static let shortDesc21 =  "Breaking news from different sources."
    
    
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
