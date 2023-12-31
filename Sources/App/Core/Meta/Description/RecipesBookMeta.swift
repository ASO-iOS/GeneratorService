//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct RecipesBookMeta: MetaProviderProtocol {
    
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        
        let fullDesc21 = "This application allows the user to easily and simply find recipes for dishes on request. After entering the name of the dish, the user will be presented with an extensive list of dishes that have the desired word in their name. Then you can choose the dish you are interested in and see what ingredients are needed for its preparation"
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "Check new recipes here!"
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
