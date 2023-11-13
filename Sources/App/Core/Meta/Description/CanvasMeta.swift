//
//  File.swift
//  
//
//  Created by admin on 11/13/23.
//

import Foundation

struct CanvasMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = """
The \(appName) game is a creative and entertaining application where you can arrange and draw shapes in 2D space. Bring your ideas to life by creating unique compositions and pictures on a virtual canvas. Choose from a variety of tools and colors to bring your artwork to life. This is the perfect game to develop your creativity and visual imagination. Share your creations with friends or save them for future use. 'Canvas' is your place for experimentation and art in the 2D world.
"""
        
        let fullDesc = [fullDesc21]
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 = "Draw and play on a 2D Canvas."
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
}
