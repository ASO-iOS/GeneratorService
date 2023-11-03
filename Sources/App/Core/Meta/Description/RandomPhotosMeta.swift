//
//  File.swift
//  
//
//  Created by admin on 31.10.2023.
//

import Foundation

struct RandomPhotosMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = "The \(appName) app is a simple, modern, light and fast photo viewing app. Refer to the works of other photographers, focusing on their unique style and interpreting it in your own way. Look for works by artists whose creative direction coincides with your own, and create new approaches based on their work."
        
        let fullDesc = [fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 = "You can enjoy beautiful photos from all over the world"
        
        let shortDesc = [shortDesc21]
        
        return shortDesc.randomElement() ?? shortDesc21
    }
}
