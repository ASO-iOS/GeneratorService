//
//  File.swift
//  
//
//  Created by admin on 8/24/23.
//

import Foundation

struct WifiRateMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is the fastest and most accurate way to test your Wi-Fi speed. With just a few taps, you can see how fast your internet connection is, and where the bottlenecks are. The app uses a variety of methods to test your speed, including downloading and uploading files, as well as ping tests. This gives you a comprehensive picture of your Wi-Fi performance."
    
    static let shortDesc21 =  "\(appName) is the fastest and most accurate way to test your Wi-Fi speed."
    
    
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
