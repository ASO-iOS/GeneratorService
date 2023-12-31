//
//  File.swift
//  
//
//  Created by admin on 8/24/23.
//

import Foundation

struct HeroQuestMeta: MetaProviderProtocol {
    
    
    
    
    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "\(appName) is the ultimate comic book quiz app for fans of all ages. The app features a variety of question types, including multiple choice, true/false. Whether you're a casual fan or a hardcore comic book nerd, HeroQuest is the perfect app for you. Download it today and start testing your knowledge!"
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "\(appName) is comic book quiz, test your knowledge about favorite characters."
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
}
