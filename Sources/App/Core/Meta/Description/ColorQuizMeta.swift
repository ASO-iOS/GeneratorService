//
//  File.swift
//  
//
//  Created by mnats on 15.11.2023.
//

import Foundation

struct ColorQuizMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        return """
\(appName) helps kids learn their colors, inspire their artistic creativity, and sharpen motor skills. This coloring app is fun and also helps children develop important skills such as recognize colors, hand-eye coordination, picture comprehension that forms the foundation for early learning success.
Young kids are mesmerized by colors, so what better way to jump-start their education than through our list of coloring apps. Here are the best coloring apps for kids that will spark their imagination and stimulates creativity.
"""
    }
    
    static func getShortDesc(appName: String) -> String {
        return """
Come and have fun with these coloring apps suitable for toddlers, preschool, kindergarten and early elementary kids.
"""
    }
    
    
}
