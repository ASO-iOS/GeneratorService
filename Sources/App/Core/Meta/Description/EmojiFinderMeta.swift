//
//  File.swift
//  
//
//  Created by admin on 9/7/23.
//


import Foundation

struct EmojiFinderMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName)  is a convenient application for finding emoticons by their name. Just enter a keyword or phrase associated with a smiley face, and the application will provide you with a suitable smiley face, its description and a unique unicode. Thanks to \(appName), you can easily and quickly find the emoticons you need to enrich your communication and express emotions. Supporting a wide range of categories and themes, the app will allow you to easily find emoticons that match any situation - from joy and laughter to sadness and surprise. Regardless of whether you use them in text messages, social networks or email, \(appName) will make the process of finding and adding emoticons fast and convenient. Embody your emotions in bright and expressive emoticons with \(appName)!"
    
    static let shortDesc21 =  "\(appName) - Search for emoticons."
    
    
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
