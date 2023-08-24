//
//  File.swift
//  
//
//  Created by admin on 24.08.2023.
//

import Foundation

struct CocktailCraftMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    static let fullDesc21 = "Find a cocktail by ingredients."
    static let shortDesc21 = "If you are tired of drinking simple drinks or you have various ingredients at home, but you do not know which cocktail you can make from them, then the cocktail craft application will help you. Enter the available ingredients and select the appropriate cocktail. You can also read the cooking instructions."
    
    static func getFullDesc(appName: String) -> String {
        self.appName = appName
        let fullDesc = [fullDesc21]

        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        self.appName = appName
        let shortDesc = [shortDesc21]

        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
