//
//  File.swift
//  
//
//  Created by admin on 11/10/23.
//

import Foundation

struct CatsMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = """
Cats have an amazing ability to reduce our anxiety and stress.
Thanks to them, people's blood pressure is normalized and cholesterol levels in the blood are reduced. Moreover, experts from the University of Minnesota have found that cats reduce the risk of heart attacks and strokes by 30%.
"""
        
        let fullDesc = [fullDesc21]
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 = "Choose your pet"
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
