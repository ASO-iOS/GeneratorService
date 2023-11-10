//
//  File.swift
//  
//
//  Created by admin on 11/9/23.
//

import Foundation

struct AssatiationsMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = """
In psychology and philosophy, associations are natural connections between independent events, phenomena, objects and phenomena that are reflected in the consciousness of an individual and fixed in memory.
If there are associative connections between mental phenomena, then certain phenomena naturally arise in consciousness.
\(appName) are connections between mental phenomena, and when one of these phenomena occurs in a person's consciousness, other phenomena arise almost simultaneously.
"""
        
        let fullDesc = [fullDesc21]
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 = "Learn the associations of any word"
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
