//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct SoundRecorderMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is an application created for high-quality sound recording, works like a voice recorder. After recording, all sounds are saved to the application folder, from where you can easily get them and listen to them in a convenient way. You can also view the list of recorded sounds directly in the app!"
    
    static let shortDesc21 =  "Record your sounds!"
    
    
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
