//
//  File.swift
//  
//
//  Created by admin on 8/24/23.
//

import Foundation

struct CinemaScopeMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a mobile app that brings you the best movie reviews from top critics around the world. Read movie reviews from top critics and find your next great film. With \(appName), you can easily find out what the critics are saying about the latest movies, and discover new films that you might not have otherwise heard of."
    
    static let shortDesc21 =  "\(appName): Read topical movie reviews."
    
    
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
