//
//  File.swift
//  
//
//  Created by admin on 9/1/23.
//

import Foundation

struct ProgrammingJokesMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is an exciting application that will give a smile to every developer! One button that carries an infinite amount of humor and laughter. Tap, and bright and witty jokes from the programming world appear on the screen. From juicy jokes to puns with a code – the choice is huge! This is the perfect application for relaxation after a hard day's work, allowing you to forget about stress and plunge into the pleasant world of IT humor. Surprise your colleagues with wit, or just have fun alone, enjoying every joke."
    
    static let shortDesc21 =  "Jokes from the development world."
    
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
