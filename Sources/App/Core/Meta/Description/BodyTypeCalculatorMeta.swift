//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct BodyTypeCalculatorMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) app is a comprehensive tool designed to help individuals determine their body type based on specific measurements and characteristics. Whether you are looking to gain muscle, lose weight, or simply understand your body better, this app provides accurate and personalized results. With a user-friendly interface, \(appName) app allows users to input various measurements such as bust size, waist size, high hip size and hip size. You also get some style advice according to your calculated body type."
    
    static let shortDesc21 =  "The app helps you to determine your body type."
    
    
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
