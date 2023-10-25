//
//  File.swift
//  
//
//  Created by admin on 05.10.2023.
//

import Foundation

struct DodgerMeta: MetaProviderProtocol {
    
    

    
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = "Leap into an exciting and fast-paced gaming experience with \(appName), a thrilling arcade game that will test your reflexes and agility! In this action-packed adventure, you'll take on the role of a nimble hero, determined to dodge a relentless downpour of falling acorns. As the game begins, you'll find yourself in a vibrant and lush forest, surrounded by towering trees. From above, acorns of various sizes and speeds rain down, threatening to hit hero. Your mission is to guide the hero safely through this perilous obstacle course, dodging each acorn with precision and skill."
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 = "Dodge falling acorns."
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
