//
//  File.swift
//  
//
//  Created by admin on 8/23/23.
//

import Foundation

struct QuickWriteerMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a mobile application for quick and easy note-taking. A simple yet powerful text note application, \(appName) is perfect for jotting down ideas, making to-do lists, or jotting down your thoughts. \(appName) Features: • Quick note taking. Take notes quickly and easily with one button app. • Search: Easily sort your notes by date, title, or a convenient color palette."
    
    static let shortDesc21 =  "\(appName) is a mobile note-taking app with a beautiful interface and search."
    
    
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
