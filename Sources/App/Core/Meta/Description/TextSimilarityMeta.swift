//
//  File.swift
//  
//
//  Created by admin on 9/1/23.
//

import Foundation

struct TextSimilarityMeta: MetaProviderProtocol {
    //
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) - this is a convenient application for comparing two texts and determining the degree of their similarity in percentages. Just type or paste two texts, and the application will quickly analyze, showing how similar the texts are to each other. The limit of 5000 characters allows you to work with small texts, which makes the application ideal for checking short phrases, messages or letters. Modern comparison algorithms provide accurate and reliable results, presented as a percentage of similarity. This application can be useful for various scenarios, such as checking the uniqueness of content, determining plagiarism, or comparing variants of text data. \(appName) is your reliable assistant for quick and easy comparison of texts and getting a visual assessment of their similarity."
    
    static let shortDesc21 =  "\(appName): Text comparison."
    
    
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
