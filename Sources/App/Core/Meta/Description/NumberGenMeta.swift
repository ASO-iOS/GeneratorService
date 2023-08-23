//
//  File.swift
//  
//
//  Created by admin on 8/23/23.
//

import Foundation

struct NumberGenMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is the ultimate random number generator app. With \(appName), you can generate random numbers from 1 to 100, or specify your own range. The app is perfect for a variety of tasks, such as: choosing a random number for a game and picking a random winner for a contest."
    
    static let shortDesc21 =  "\(appName), specify your own range and generate random numbers."
    
    
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
