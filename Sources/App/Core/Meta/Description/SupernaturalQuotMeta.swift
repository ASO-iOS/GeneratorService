//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct SupernaturalQuotMeta: MetaProviderProtocol {
    
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "The \(appName) app is a fun and entertaining tool that allows fans of the popular TV show to relive their favorite moments and quotes. Whether you're a die-hard fan or just someone who enjoys the wit and wisdom of the Winchester brothers, this app provides a delightful platform to explore the vast collection of memorable lines from Supernatural. Upon launching the app, users are greeted with a sleek and user-friendly interface that captures the essence of the show. The app randomly generates quotes from various episodes, ensuring that each experience is unique and exciting. From iconic one-liners to heartfelt conversations, the \(appName) app offers a diverse range of quotes that will make you laugh, cry, and reminisce about the adventures of Sam and Dean Winchester."
    
    static let shortDesc21 =  "The app shows you random quotes from TV Show \"Supernatural\"."
    
    
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
