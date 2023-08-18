//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct HiddenParisMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "Embark on an exciting journey of memory and concentration with \"\(appName)\" a captivating game where you must put your observation skills to the test and find \(appName)! In this addictive and brain-teasing game, you'll be presented with a grid of face-down dots, each concealing a unique color. Your task is to uncover the dots one by one, remembering their positions, and match them with their identical counterparts."
    
    static let shortDesc21 =  "Match dots with identical color by memorising their position."
    
    
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
