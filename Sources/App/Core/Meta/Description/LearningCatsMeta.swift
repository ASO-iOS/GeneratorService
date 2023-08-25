//
//  File.swift
//  
//
//  Created by admin on 8/25/23.
//

import Foundation

struct LearningCatsMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName): Learn about cats with fun facts."
    
    static let shortDesc21 =  "\(appName) is a fun and educational app that will teach you all about cats. With over 100 facts, you'll learn about everything from cat breeds to cat behavior. \(appName) is the perfect app for cat lovers of all ages."
    
    
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
