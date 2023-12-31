//
//  File.swift
//  
//
//  Created by admin on 8/20/23.
//

import Foundation

struct FactsAboutDogsMeta: MetaProviderProtocol {
    
    
    
    

    

    
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = " Facts are important because they give us information about the world around us. They can't help us understand how things work, make decisions and learn something new. Facts can be used both to support arguments and to refute false information. They can also be used to create informative and engaging content. Learn new facts about dogs and share them with friends and family"
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 =  "Find out a new fact about dogs!"
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
