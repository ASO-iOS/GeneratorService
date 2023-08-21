//
//  File.swift
//  
//
//  Created by admin on 8/20/23.
//


import Foundation

struct QuizVideoGamesMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "This application is designed to assess your knowledge and experience with video games. The questions will cover a variety of topics, including: Different genres of video games Popular video games Video game history Video game development Video game culture The application is intended to be a fun and informative way to learn more about video games. It is also a great way to demonstrate your passion for video games to potential employers or academic institutions."
    
    static let shortDesc21 =  "Check your knowledge about video games!"
    
    
    static func getFullDesc(appName: String) -> String {
        self.appName = appName
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        self.appName = appName
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
