//
//  File.swift
//  
//
//  Created by admin on 8/31/23.
//

import Foundation

struct NumbersFactsMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "Our app provides amazing facts about numbers! Just enter a number, and choose the type of fact: funny or mathematical. Have fun learning the unique properties of numbers from different fields – from fun facts about numbers in history to exciting mathematical characteristics. Discover the world of numbers from a new angle and amaze your friends with fascinating facts. Never knew that a number could be so amazing! Our app is an interactive way to learn something new, expand your knowledge and spend time with benefit and pleasure."
    
    static let shortDesc21 =  "\(appName) - mathematical and funny."
    
    
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
