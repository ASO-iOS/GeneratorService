//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct TeaWikiMeta: MetaProviderProtocol {
    
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "Introducing \(appName), your go-to mobile application for all things tea-related. Whether you're a tea lover, a connoisseur, or simply curious about the world of tea, this app is packed with comprehensive information about different kinds of tea. Tea Enthusiast features an intuitive and visually appealing interface that allows you to explore a wide variety of teas from around the world. From popular classics like black, green, and herbal teas, to rare and exotic blends, the app provides in-depth profiles for each type. You'll discover details about origin, flavour profiles, and brewing guidelines, ensuring you can appreciate and enjoy every sip to the fullest."
    
    static let shortDesc21 =  "The app shows you different kinds of tea."
    
    
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
