//
//  File.swift
//  
//
//  Created by mnats on 15.11.2023.
//

import Foundation

struct PlanetariumMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = """
Have you ever wondered what’s the weight of the Pluto or what’s the distance between Mercury and Saturn?, but get overwhelmed by the information when you look for answers. \(appName) is one stop center for you.

"""
        return fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = """
\(appName) provides you with vast information about planets in Solar System
"""
        return shortDesc1
    }
    
}
