//
//  File.swift
//  
//
//  Created by admin on 9/12/23.
//

import Foundation

struct LanguageIdentifireMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a convenient application that allows you to quickly and accurately determine the language of the entered text. Just enter the text, and the application will instantly determine which language the text is written in. Regardless of whether it is a message, an article or a document, \(appName) will help you quickly understand what language the text is composed in. It is a valuable tool for communication, translation and analysis of texts in different languages. Thanks to \(appName), you will be able to efficiently process and evaluate multilingual data, which makes it an indispensable assistant in the modern information world. Get instant and accurate results with \(appName), simplifying your work with multilingual texts and improving the quality of language information analysis."
    
    static let shortDesc21 =  "\(appName): Identify the language."
    
    
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
