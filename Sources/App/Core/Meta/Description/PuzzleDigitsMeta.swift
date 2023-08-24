//
//  File.swift
//  
//
//  Created by admin on 24.08.2023.
//

import Foundation

struct PuzzleDigitsMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    static let fullDesc21 = "This is a classic puzzle game where you need to move the numbers to restore order. You can try to complete the game on different difficulty levels by choosing a different size of the playing field. Train your brain with the \(appName) app."
    static let shortDesc21 = "Train your brain with the Puzzle Digits app."
    
    static func getFullDesc(appName: String) -> String {
        self.appName = appName
        let fullDesc = [fullDesc21]

        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        self.appName = appName
        let shortDesc = [shortDesc21]

        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
