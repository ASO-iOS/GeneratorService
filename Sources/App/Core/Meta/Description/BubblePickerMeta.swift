//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct BubblePickerMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a fun and engaging game that will keep you entertained! In this immersive and colorful world, your objective is to collect bubbles based on the numbers displayed on them as fast as you can. The game supports several complexity modes which determine how many bubbles you need to pop in total."
    
    static let shortDesc21 =  "Collect bubbles as fast as you can."
    
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
