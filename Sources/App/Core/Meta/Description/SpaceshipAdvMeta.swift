//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct SpaceshipAdventureMeta: MetaProviderProtocol {
    static var appName = ""
    static let fullDesc1 = "\(appName) is an addictive game that allows you to go on an exciting space adventure. In the game you will control a spaceship and explore the unexplored corners of the galaxy. However, along the way you will be threatened by numerous dangers, such as aliens and meteorites. You will fight for survival, using your ship and its weapons to destroy obstacles. Each enemy you destroy earns you points that can be used to improve your ship and its weapons. The game has several levels of difficulty, each one presenting a new challenge to you and your ship."
    static let fullDesc2 = "The \(appName) game has a simple and intuitive interface that makes it easy to control your ship and its weapons. You can use different strategies and tactics to defeat your enemies and reach your goal. One of the main advantages of the game is its variety. In the game, you will have access to different types of ships and weapons that you can improve and upgrade. In addition, the game has many levels and missions that will allow you to explore the galaxy and defeat enemies."
    static let fullDesc3 = "\(appName) is not only a fascinating game, but also a great way to develop your skills and abilities. In the game you will learn how to control your ship, shoot and improve your weapons. In addition, the game will help you develop such qualities as the ability to make decisions and react quickly to changing situations. \(appName) game is a great way to spend your time and enjoy the game. It is suitable for sci-fi adventure lovers and those who want to test their skills in a fascinating game. Download \(appName) now and go on an exciting space adventure!"
    static let fullDesc4 = "\(appName) is an addictive game that will allow you to go on an exciting space adventure and become a real space hero. In the game you will steer the spaceship and explore unknown corners of the galaxy. However, on your way you will be threatened by numerous dangers, such as aliens and meteorites. One of the main advantages of the game is its variety. In the game you will have access to different types of ships and weapons that you can upgrade and upgrade. In addition, the game has many levels and missions that will allow you to explore the galaxy and defeat enemies."
    static let fullDesc5 = "The \(appName) game has a simple and intuitive interface that makes it easy to control your ship and its weapons. You can use different strategies and tactics to defeat enemies and reach your goal. You will fight for survival by using your ship and its weapons to destroy obstacles. Each enemy you destroy earns you points that you can use to improve your ship and its weapons. The game has several levels of difficulty, each one presenting a new challenge to you and your ship."
    static let fullDesc6 = "\(appName) is not only a fun game, but also a great way to develop your skills and abilities. In the game you will learn how to control your ship, shoot and improve your weapons. In addition, the game will help you develop such qualities as the ability to make decisions and quickly respond to the changing situation. \(appName) is not just a game, it is a real space adventure that will make you feel like a real space hero. The game is suitable for fans of sci-fi adventures and those who want to test their skills and abilities in a fascinating game. Download \(appName) now and go on an exciting space adventure!"
    static let fullDesc7 = "\(appName) is an exciting game that offers a unique experience of traveling across the galaxy in a spaceship. In this game you will find yourself in the role of a real space hero, ready to fight against enemies and overcome dangers on your way. You will have to control the spaceship, dodging asteroids and other dangers, as well as fighting with enemies using your skills and weapons. The game has many levels, each with its own challenges and complexities. You can collect power-ups and upgrades to improve your skills and enhance your weapons."
    static let fullDesc8 = "\(appName) is a game for those who love sci-fi adventures and want to test their skills and abilities in an exciting game. Download \(appName) now and go on an incredible space journey, where dangers and adventures await you at every step! Download \(appName) right now and go on an incredible space journey, where dangers and adventures await you at every step! Become a real space hero and show everyone that you are able to perform the most incredible feats in space!"
    static let fullDesc9 = "\(appName) is an exciting game that offers players the unique opportunity to go on an incredible space journey aboard your spaceship. In this game you will find yourself in the role of a brave space pilot, who is ready to fight with enemies and overcome all obstacles on his way. Players will have to control the spaceship, dodging asteroids, meteorites and other dangers that can destroy your ship. You will also fight enemies using your weapons and combat skills. There are many levels in the game, each with its own challenges and difficulties."
    static let fullDesc10 = "\(appName) has a lot of power-ups and upgrades that will help improve your skills and enhance your weapons. You can collect various items and resources to improve your ship and become even more powerful. This game is suitable for those who love sci-fi adventures and want to test their skills and abilities in an addictive game. \(appName) is a game that will allow you to feel like a real space hero and go on an incredible space adventure."

    static let shortDesc1 = "An exciting space adventure with \(appName)!"
    static let shortDesc2 = "Are you ready for a battle for survival? Embark on a journey with \(appName)!"
    static let shortDesc3 = "Travel the galaxy and become a hero with \(appName)!"
    static let shortDesc4 = "Go on a space flight with \(appName) and conquer the dangers!"
    static let shortDesc5 = "Ready for an epic space adventure? \(appName) is waiting for you!"
    static let shortDesc6 = "The dangers of space are not afraid of \(appName)!"
    static let shortDesc7 = "Get ready for an exciting space journey with \(appName)!"
    static let shortDesc8 = "\(appName) - your guide through space in search of adventure!"
    static let shortDesc9 = "Become the captain of your own spaceship with \(appName)!"
    static let shortDesc10 = "Conquer the galaxy with \(appName) and save humanity!"
    
    static func getFullDesc(appName: String) -> String {
        self.appName = appName
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        self.appName = appName
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
