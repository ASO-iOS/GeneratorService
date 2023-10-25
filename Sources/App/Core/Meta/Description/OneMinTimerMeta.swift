//
//  File.swift
//  
//
//  Created by admin on 8/25/23.
//

import Foundation

struct OneMinTimerMeta: MetaProviderProtocol {
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "\(appName) is a simple and easy-to-use 60-second timer. It's perfect for cooking, working out, or any other task that you need to time. The timer has a clear and concise interface, so you can easily see how much time is left. \(appName) is also completely free to use."
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "\(appName): A simple and easy-to-use 60-second timer."
        
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
}
