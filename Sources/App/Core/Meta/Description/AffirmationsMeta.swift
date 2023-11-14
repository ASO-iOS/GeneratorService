//
//  File.swift
//  
//
//  Created by admin on 11/13/23.
//

import Foundation

struct AffirmationsMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = """
The affirmation of the day is a moment that helps you start the morning with positive intentions and confidence. Every new day brings opportunities for growth and achievements. Our unique affirmations are designed to inspire you, lift your spirits and fill you with confidence. They are created especially for you to help you overcome challenges and look at life with optimism. Let each affirmation of the day be your daily metered inspiration to achieve your goals and happiness.
"""
        
        let fullDesc = [fullDesc21]
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 = "Lift your spirits and inspire yourself every day."
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
}
