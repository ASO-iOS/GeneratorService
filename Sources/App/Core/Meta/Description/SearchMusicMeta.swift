//
//  File.swift
//  
//
//  Created by admin on 11/14/23.
//

import Foundation

struct SearchMusicMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc21 = "Application '\(appName)' is your perfect guide to the world of music. Here you can quickly and conveniently search for music tracks by name, artist or genre. Listen to music anytime, anywhere, just by typing queries into the search. We provide access to a huge library of tracks that will satisfy your musical preferences. Discover new hits or find your favorite songs over and over again. Enjoy music with '\(appName)' and share it with your friends to enrich your music experience."
        
        let fullDesc = [ fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc21 =  "Search for music and enjoy the tracks."
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
