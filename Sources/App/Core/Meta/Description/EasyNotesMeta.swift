//
//  File.swift
//
//
//  Created by admin on 9/6/23.
//

import Foundation

struct EasyNotesMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "Our application provides a simple and convenient function for creating notes with titles and descriptions. Organize your thoughts, ideas and important events in a convenient format. Just enter a title, add a description and save your note. With this app, you can easily write down everything you need to remember – from your shopping list to important business notes. Forget about the mess in the records and don't worry about missing something. Our notes are stored in a convenient list, and you can easily view, edit or delete them if necessary. Taking notes has never been so easy and convenient before! Optimize your workflow and personal affairs with our notes app!"
    
    static let shortDesc21 =  "Write down notes with ease!"
    
    
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
