//
//  File.swift
//  
//
//  Created by admin on 10.07.2023.
//

import Foundation

struct LuckyNumberMeta: MetaProviderProtocol {
    
    static var appName = ""
    
    static let fullDesc1 = "\(appName) is a mobile application that will help you increase the level of luck in your life. With this app, you will always have your lucky number at your fingertips, allowing you to attract positive events and achieve success.One of the main features of \(appName) is the ability to find your lucky number. The app offers various techniques and algorithms to help you determine your unique number. You will be able to choose the method that best suits your preferences and beliefs"
    
    static let fullDesc2 = "\(appName) offers many tools and features that will help you use your lucky number in your daily life. You will be able to create task lists, schedule important events, and make decisions based on your lucky number. The app also provides the ability to save and track all your successes and achievements."
    
    static let fullDesc3 = "\(appName) will help you break boundaries and achieve your goals. You will be able to use your lucky number to attract good luck in different areas of life such as career, finance, relationships and health. The app provides guidance and tips to help you utilize your lucky number in the best possible way."
    
    static let fullDesc4 = "\(appName) also offers the ability to share your successes and achievements with other users of the app. You will be able to join a community of people who are also looking to improve their luck. You will be able to share your experiences, ask questions and find inspiration from other users."
    
    static let fullDesc5 = "An important aspect of \(appName) is its ease of use. The app has an intuitive interface that makes it easy to navigate through all of its features. You can quickly customize the app to your needs and start using your lucky number to attract good luck."
    
    static let fullDesc6 = "\(appName) is the perfect app for you. It will help you find your lucky number, use it in your daily life and attract positive events. Don't miss opportunities and achieve your goals with \(appName)!"
    
    static let fullDesc7 = "\(appName) is a mobile app that will help you increase the level of luck in your life. With this app, you will always have your lucky number at your fingertips, allowing you to attract positive events and achieve success."
    
    static let fullDesc8 = "One of the main features of \(appName) is the ability to find your lucky number. The app offers various techniques and algorithms to help you determine your unique number. You will be able to choose the method that best suits your preferences and beliefs."
    
    static let fullDesc9 = "\(appName) offers many tools and features to help you use your lucky number in your daily life. You will be able to create task lists, plan important events and make decisions based on your lucky number. The app also provides the ability to save and track all your successes and achievements."
    
    static let fullDesc10 = "\(appName) will help you break boundaries and achieve your goals. You will be able to use your lucky number to attract good luck in different areas of life such as career, finance, relationships and health. The app provides guidance and tips to help you utilize your lucky number in the best possible way."
    
    static let fullDesc11 = "\(appName) also offers the ability to share your successes and achievements with other users of the app. You will be able to join a community of people who are also looking to improve their luck level. You will be able to share your experiences, ask questions and find inspiration from other users."
    
    static let fullDesc12 = "An important aspect of \(appName) is its ease of use. The app has an intuitive interface that makes it easy to navigate through all of its features. You will be able to quickly customize the app to your needs and start using your lucky number to attract good luck."
    
    static let fullDesc13 = "\(appName) is the perfect app for you. It will help you find your lucky number, use it in your daily life and attract positive events. Don't miss opportunities and achieve your goals with \(appName)!"
    
    static let fullDesc14 = "\(appName) is a mobile app that will help you increase the level of luck in your life. With this app, you will always have your lucky number at your fingertips, allowing you to attract positive events and achieve success."
    
    static let fullDesc15 = "One of the main features of \(appName) is the ability to find your lucky number. The app offers various techniques and algorithms to help you determine your unique number. You will be able to choose the method that best suits your preferences and beliefs."
    
    static let fullDesc16 = "\(appName) offers many tools and features that will help you use your lucky number in your daily life. You will be able to create task lists, schedule important events, and make decisions based on your lucky number. The app also provides the ability to save and track all your successes and achievements."
    
    static let fullDesc17 = "\(appName) will help you break boundaries and achieve your goals. You will be able to use your lucky number to attract good luck in different areas of life such as career, finance, relationships and health. The app provides guidance and tips to help you utilize your lucky number in the best possible way."
    
    static let fullDesc18 = "\(appName) also offers the ability to share your successes and achievements with other users of the app. You will be able to join a community of people who are also looking to improve their luck level. You will be able to share your experiences, ask questions and find inspiration from other users."
    
    static let fullDesc19 = "An important aspect of \(appName) is its ease of use. The app has an intuitive interface that makes it easy to navigate through all of its features. You will be able to quickly customize the app to your needs and start using your lucky number to attract good luck."
    
    static let fullDesc20 = "\(appName) is the perfect app for you. It will help you find your lucky number, use it in your daily life and attract positive events. Don't miss opportunities and achieve your goals with \(appName)!"
    
    
    static let fullDesc21 = "It's very simple, try to guess the name that the computer has conceived! Try your luck to outsmart the computer. You will have 10 attempts to correctly indicate the intended number, no skills, only luck!"
    
    
    static let shortDesc1 = "\(appName) - your lucky number is always at your fingertips!"
    
    static let shortDesc2 = "Increase your luck with \(appName)!"
    
    static let shortDesc3 = "Find your luck with \(appName)!"
    
    static let shortDesc4 = "Improve your life with \(appName)!"
    
    static let shortDesc5 = "Make your dreams come true with \(appName)!"
    
    static let shortDesc6 = "\(appName) is your path to success!"
    
    static let shortDesc7 = "Open the door to luck with \(appName)!"
    
    static let shortDesc8 = "Put luck in your hands with \(appName)!"
    
    static let shortDesc9 = "Never miss an opportunity with \(appName)!"
    
    static let shortDesc10 = "Achieve your goals with \(appName)!"
    
    static let shortDesc11 = "Raise the stakes of your luck with \(appName)!"
    
    static let shortDesc12 = "Open new horizons with \(appName)!"
    
    static let shortDesc13 = "Seize the moment with \(appName)!"
    
    static let shortDesc14 = "Be on top of your luck with \(appName)!"
    
    static let shortDesc15 = "Push your limits with \(appName)!"
    
    static let shortDesc16 = "Discover new opportunities with \(appName)!"
    
    static let shortDesc17 = "Improve your life with one click with \(appName)!"
    
    static let shortDesc18 = "Make the right choices with \(appName)!"
    
    static let shortDesc19 = "Let luck be on your side with \(appName)!"
    
    static let shortDesc20 = "Believe in your luck with \(appName)!"
    
    static let shortDesc21 = "Try your luck"
    
    
    
    static func getFullDesc(appName: String) -> String {
        self.appName = appName
        
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20, fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc1
        
    }
    
    
    
    static func getShortDesc(appName: String) -> String {
        self.appName = appName
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20, shortDesc21]
        
        return shortDesc.randomElement() ?? shortDesc1
        
    }
}
