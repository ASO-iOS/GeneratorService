//
//  File.swift
//  
//
//  Created by admin on 8/20/23.
//

import Foundation

struct LuckySpanMeta: MetaProviderProtocol {
    
    
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "This wonderful application allows you to try your luck. Put an interval for the numbers that you think should be happy. By clicking on the button, a random number will drop out and you will check whether you would be right or not"
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "Check your lucky!"
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
