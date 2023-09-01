//
//  File.swift
//  
//
//  Created by admin on 9/1/23.
//

import Foundation

struct ROT13EncryptMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a convenient and fast application for encrypting text using the ROT13 method. Just enter your text, and the application will instantly encrypt it using the ROT13 algorithm, which replaces each letter with a letter located 13 positions after it in the alphabet. This is a simple and reliable encryption method that is suitable for protecting small messages from accidental glances. The encrypted text can be easily copied and sent to friends via messengers or email. The application also provides a function to decrypt the text back to its original state. \(appName) is ideal for those who want to exchange encrypted messages and at the same time not bother with complex encryption methods. Protect your communication with \(appName) - easy to protect information!"
    
    static let shortDesc21 =  "\(appName): Fast encryption!"
    
    
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
