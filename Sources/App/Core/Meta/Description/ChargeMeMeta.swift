//
//  File.swift
//  
//
//  Created by admin on 23.08.2023.
//

import Foundation

struct ChargeMeMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    static let fullDesc21 = "This simple application was made so that people could always put the phone on charge on time. The user may not hear the standard low battery alert, but he will always hear a long melody that informs about the need to connect the charger!"
    static let shortDesc21 = "Helps you connect your device to charge at time!"
    
    static func getFullDesc(appName: String) -> String {
        self.appName = appName
        let fullDesc = [fullDesc21]
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
            self.appName = appName
            let shortDesc = [shortDesc21]
            return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
