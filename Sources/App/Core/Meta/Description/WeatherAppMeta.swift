//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct WeatherAppMeta: MetaProviderProtocol {
    
    static var appName: String = ""
    
    
    static let fullDesc21 = "\(appName) is a comprehensive and reliable mobile application designed to provide you with accurate and up-to-date weather information. With \(appName), you can plan your day with confidence, stay prepared for any weather conditions, and make informed decisions based on the latest forecasts. The app features a user-friendly interface that displays real-time weather data for your current location or any location worldwide. \(appName) provides detailed information such as temperature, humidity, wind speed and pressure."
    
    static let shortDesc21 =  "The app shows weather in your area."
    
    
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
