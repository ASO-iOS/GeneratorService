//
//  File.swift
//  
//
//  Created by admin on 8/24/23.
//

import Foundation

struct TrySecretMeta: MetaProviderProtocol {
    
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        
        let fullDesc21 = "\(appName) is a secure password generator that creates strong and unique passwords for you. The app generates passwords that are long, random, and difficult to guess. \(appName) also allows you to easily fast copy your new password. "
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "\(appName): A secure password generator that creates strong passwords for you."
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
