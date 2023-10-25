//
//  File.swift
//  
//
//  Created by admin on 9/8/23.
//
import Foundation

struct GastronomyGuruMeta: MetaProviderProtocol {
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "\(appName) is a convenient application for searching recipes by name. Just enter the name of the dish or ingredient, and the app will provide you with a variety of recipes that match your request. Whether you are looking for recipes for everyday cooking or special occasions, \(appName) will help you find inspiration and variety in culinary experiments. From classic to modern dishes, you can choose from a variety of recipes presented with detailed instructions and a list of ingredients. \(appName) is your reliable assistant in the kitchen, who will help you create delicious and unique dishes, raising your culinary skills to a new level."
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        
        let shortDesc21 =  "\(appName): Look for recipes!"
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
