//
//  File.swift
//  
//
//  Created by admin on 8/25/23.
//

import Foundation

struct OneMinTimerMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a simple and easy-to-use 60-second timer. It's perfect for cooking, working out, or any other task that you need to time. The timer has a clear and concise interface, so you can easily see how much time is left. \(appName) is also completely free to use."
    
    static let shortDesc21 =  "\(appName): A simple and easy-to-use 60-second timer."
    
    
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
