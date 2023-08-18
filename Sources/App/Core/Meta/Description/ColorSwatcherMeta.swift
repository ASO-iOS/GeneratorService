//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct ColorSwatcherMeta: MetaProviderProtocol {
 
    static var appName: String = ""
    
    
    static let fullDesc21 = "The \(appName) app is a creative tool that empowers users to explore the fascinating world of colors. Whether you are an artist, designer, or simply someone who appreciates the beauty of hues, this app offers an intuitive and engaging platform to mix and experiment with different colors. With its user-friendly interface, the Color Swatcher app provides a seamless experience for users of all ages and skill levels. Upon launching the app, you are greeted with a virtual canvas that serves as your artistic playground, where you can add and modify your color swatches."
    
    static let shortDesc21 =  "The app allows you to mix different colors."
    
    
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
