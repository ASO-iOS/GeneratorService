//
//  File.swift
//  
//
//  Created by admin on 11/14/23.
//

import Foundation

struct RandomTextMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "The '\(appName)' app brings you an endless variety of texts. Just specify the number of lines and the app will generate random text for you. This is convenient for testing design, filling in content, or just for fun. You can use the generated text for any purpose, from training to development. 'Random Text' gives you unlimited access to a variety of strings ready to use. Simplify your tasks with the random text generator and get the data you need quickly and conveniently."
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "\(appName): Generating random strings."
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
