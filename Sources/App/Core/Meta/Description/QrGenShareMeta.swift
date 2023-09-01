//
//  File.swift
//  
//
//  Created by admin on 9/1/23.
//

import Foundation

struct QrGenShareMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a simple and user-friendly application that allows you to easily create QR codes based on phrases and texts, and then easily share them with others via messengers. Just enter your phrase or text, and the app will instantly generate a QR code that contains your information. Then you can send this QR code to your friends, colleagues or family through any messenger application installed on your device. This convenient solution allows you to exchange information without having to enter text or links manually. \(appName) provides a fast and secure way to share data, and it will become an indispensable assistant in everyday communication and in business meetings. Ease of use and reliability make \(appName) an indispensable tool for generating and distributing QR codes on your device."
    
    static let shortDesc21 =  "\(appName) - Create and send!"
    
    
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
