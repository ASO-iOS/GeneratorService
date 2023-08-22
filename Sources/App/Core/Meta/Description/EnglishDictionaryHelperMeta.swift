//
//  File.swift
//  
//
//  Created by admin on 8/22/23.
//

import Foundation

struct EnglishDictionaryHelperMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "The \(appName) application is designed to find new definitions for famous words! And you can also find out the meanings of unknown words, enter a word in the search bar and click the search button - done, you will see a list of uses of this word"
    
    static let shortDesc21 =  "Search definitions for your word!"
    
    
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
