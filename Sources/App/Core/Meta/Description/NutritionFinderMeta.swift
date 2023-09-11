//
//  File.swift
//  
//
//  Created by admin on 9/6/23.
//

import Foundation

struct NutritionFinderMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is an innovative nutrition analysis app. Just enter your text describing the food you have consumed, and the app will automatically recognize all mentions of food in the text. From proteins and fats to carbohydrates, the app will provide you with detailed information about the caloric and nutritional value of each meal found in the text. Thanks to this tool, you will be able to easily control your diet, understand the composition of the products consumed and make more informed decisions about nutrition. This is not just an app, it is a reliable companion on the way to a healthy and balanced diet. Make your food choices conscious with \(appName)!"
    
    static let shortDesc21 =  "\(appName) - Nutrition analysis."
    
    
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
