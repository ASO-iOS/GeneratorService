//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct VigenereCipherMeta: MetaProviderProtocol {
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        
        let fullDesc21 = "This simple application created for users, who needs to hide their messages from other. Simple to use, uses Vigenere cipher inside. Encrypt your messages and share with friends and parents, learn cryptography and secure your data."
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "Encrypt your messages and share them wit friends!"
        
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
