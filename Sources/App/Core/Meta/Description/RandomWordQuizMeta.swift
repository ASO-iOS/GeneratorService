//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct RandomWordQuizMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = "Learn new words, remember old ones, strain your head to remember the word. The game is simple, all you have to do is guess the word by letters, you have the opportunity to make a mistake 5 times and the game will end."
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        

        let shortDesc21 =  "Learn new words by game!"
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
}
