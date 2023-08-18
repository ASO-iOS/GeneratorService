//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct ClickerMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "The \(appName) app is a simple yet powerful tool designed to accurately count and track the number of clicks made within a 5-second timeframe. Whether you are engaging in a game, conducting research, or simply curious about your clicking speed, this app provides a convenient and user-friendly solution. With its sleek and intuitive interface, the \(appName) app allows users to effortlessly keep track of their clicking activity. As soon as the app is launched, a timer starts counting down from 5 seconds, providing a sense of urgency and excitement. Users can then click on the designated area of the screen as rapidly as possible within this time constraint."
    
    static let shortDesc21 =  "The app tests you to click as more as you can during 5 seconds."
    
    
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
