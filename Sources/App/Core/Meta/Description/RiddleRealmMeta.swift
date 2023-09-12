
//  File.swift
//
//
//  Created by admin on 8/22/23.
//

import Foundation

struct RiddleRealmMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is an exciting application that offers you to solve random riddles. Just open the app and you will be presented with a riddle that you can try to solve. If you need a hint or an answer, click the \"Show answer\" button and you will get the right solution. After that, just move on to the next riddle by clicking on the \"Next Riddle\" button. You will face a variety of puzzles, from easy to more complex, which will allow you to develop logical thinking and creative thinking. Find out how well you do with puzzles and riddles. \(appName) is the perfect entertainment for all ages that will make you think, reflect and enjoy mental challenges."
    
    static let shortDesc21 =  "\(appName): Riddles and Answers."
    
    
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
