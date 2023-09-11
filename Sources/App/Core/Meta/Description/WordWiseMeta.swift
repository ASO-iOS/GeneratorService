
//
//  File.swift
//
//
//  Created by admin on 9/8/23.
//
import Foundation

struct WordWiseMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a convenient application for getting the interpretation of English words. Just enter the word you are interested in and the app will provide you with a detailed explanation of its meaning, usage and synonyms. Whether you are a student, a writer, or just interested in the language, \(appName) will help you expand your vocabulary and deepen your understanding of English. You will be able to easily clarify the meanings and meanings of words, improving the quality of your communication and writing. Thanks to the simple and intuitive interface, you will quickly find the necessary interpretations without extra effort. \(appName) is your reliable reference for accurate and useful information about the meanings of English words, making your experience of learning and using the language more productive and satisfying."
    
    static let shortDesc21 =  "\(appName): Interpretation of words."
    
    
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
