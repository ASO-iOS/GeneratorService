//
//  File.swift
//  
//
//  Created by mnats on 15.11.2023.
//

import Foundation

struct ScrambleMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = """
Do you like word search games? \(appName) is a casual word game where you try to solve the word puzzle by unscrambling the given letters to find the correct word.
"""
        return fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "\(appName) is a minimalistic word puzzle game that will test your intellect and vocabulary. "
        return shortDesc1
    }
    
}
