//
//  File.swift
//
//
//  Created by admin on 9/7/23.
//

import Foundation

struct HistoricalEventsMeta: MetaProviderProtocol {
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a unique application that allows you to get a variety of historical facts according to your text query. Just enter a query related to the topic or event you are interested in, and the app will provide you with a set of facts related to your query. Whether it's famous personalities, key dates, important events or little-known facts from history, \(appName) will help you delve into the past and expand your erudition. It is an indispensable source of information for students, historians, educational institutions and anyone interested in learning about our past. With the \(appName) app, you will get fast and reliable access to interesting historical events, allowing you to get acquainted with the versatility of the past and expand your knowledge of the world of history."
    
    static let shortDesc21 =  "\(appName): Facts from history."
    
    
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
