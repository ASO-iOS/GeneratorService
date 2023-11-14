//
//  File.swift
//  
//
//  Created by admin on 10.11.2023.
//

import Foundation

struct PedometerMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fulllDesc21 = """
A mechanical, electromechanical or electronic measuring device for counting the number of steps (or pairs of steps)
taken while walking or running.
Such pedometers count the number of steps using a built-in sensor, do not have GPS and have a long charge.
"""
        
        let fullDesc = [fulllDesc21]
        
        return fullDesc.randomElement() ?? fulllDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 = "This app will help you find out how much you have passed."
        let shortDesc = [shortDesc21]
        
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
