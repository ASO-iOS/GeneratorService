//
//  File.swift
//  
//
//  Created by admin on 8/22/23.
//

import Foundation

struct RandomDogsMeta: MetaProviderProtocol {
    
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        
        let fullDesc21 = "This simple application is made to study new breeds of dogs, it contains more than 20 breeds and all the sub-breeds! You will be presented with a list of breeds to choose from and clicking on one of them will show random pictures of dogs of the selected breed"
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "Check dogs breeds!"
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
}
