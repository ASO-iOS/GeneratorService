//
//  File.swift
//  
//
//  Created by admin on 8/25/23.
//

import Foundation

struct QrGeneratorMeta: MetaProviderProtocol {
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        
        let fullDesc21 = "\(appName) is a mobile app that allows you to create QR codes with ease. With \(appName), you can create QR codes for any type of content, including websites, phone numbers, emails, and more. "
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "\(appName): Create QR codes with ease."
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
}
