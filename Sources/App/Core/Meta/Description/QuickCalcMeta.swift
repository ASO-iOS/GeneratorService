//
//  File.swift
//  
//
//  Created by admin on 8/23/23.
//

import Foundation

struct QuickCalcMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a simple and easy-to-use calculator that is perfect for everyday calculations. The app has a clean and intuitive interface, making it easy to use even for beginners. \(appName) also supports a variety of calculation functions. "
    
    static let shortDesc21 =  "\(appName): A simple and easy-to-use calculator for everyday calculations."
    
    
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
