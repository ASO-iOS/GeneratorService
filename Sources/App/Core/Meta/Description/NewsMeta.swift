//
//  File.swift
//  
//
//  Created by admin on 03.11.2023.
//

import Foundation

struct NewsMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = "Daily news about what is happening in Russia, Belarus and the world, stars, sports and kittens. Find the latest news: read articles from different media in one application. View colorful photos"
        let fullDesc = [fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 =  "The app will tell you about the newest and most relevant events."
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
