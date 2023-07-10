//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct BirdGameMeta {
    static let fullDesc1 = "This is an arcade game about a bird that flies through different locations and avoids obstacles. The player must control the bird by tapping the screen to lift it up or release it to start falling. The levels get progressively more difficult, so you have to react quickly to new obstacles and maneuver cleverly to advance"
    static let fullDesc2 = "This is a fun and addictive game that will suit beginners and experienced gamers alike. This game with great graphics, a great way to pass the time and test your reaction and dexterity. Gameplay is accompanied by pleasant sound design and bright graphics."
    static let fullDesc3 = "This is an addictive arcade game where the main character is a bird. The player has to go through different levels, avoiding obstacles and making his way to the finish line. To control the bird, you have to press the screen to make it go up, and release it to start falling. This is a great way to spend time and test your reaction and dexterity."
    static let fullDesc4 = "Arcade games have always been popular, and Birdgame is no exception. This game has simple gameplay, but at the same time is challenging enough to make the player use all their gaming skills. The levels get harder and harder as the game progresses, so you have to react quickly and constantly improve your skills. The graphics and soundtrack perfectly convey the atmosphere of the game, and the gameplay is enjoyable and dynamic."
    static let fullDesc5 = "It is an addictive arcade game with excellent graphics and addictive gameplay, where the player plays as a bird that flies in different locations, avoiding obstacles and collecting bonuses. To control the bird, press the screen to lift it up, and release it to start falling. The levels in the game gradually become more difficult and the player must react quickly to the emerging obstacles and maneuver to move forward."
    static let fullDesc6 = "This game offers exciting missions and addictive gameplay that will please fans of addictive games. Control the bird by tapping the screen to go up and releasing it to fall. Levels in the game are getting harder and harder, so the player needs to be ready to react quickly to all new obstacles and deftly control the bird. The graphics and soundtrack create a unique atmosphere, and the gameplay thrills with its dynamics."
    static let fullDesc7 = "This is a great game for anyone who wants to spend time in an exciting and addictive gameplay. This is an exciting arcade game about a flying bird that avoids obstacles and collects coins. To control the bird, you have to press the screen to make it go up and release it to start falling. Levels in the game gradually become more difficult, and the player must quickly respond to emerging obstacles and find the right flight path. "
    static let fullDesc8 = "This is a unique, simple and fun way to spend your free time and practice your reaction and motor skills. The levels in the game gradually become more difficult, and the player must quickly react to emerging obstacles and find the right flight paths. The graphics and sound design of the game create a bright and engaging atmosphere that makes the player want to keep playing over and over again."
    static let fullDesc9 = "It is a simple but addictive arcade game in which the player must control a bird flying through different locations and avoiding obstacles. Tapping on the screen causes the bird to rise, and releasing it causes it to fall. The goal of the game is to pass as many levels as possible, collecting coins along the way. "
    static let fullDesc10 = "It is the perfect way to pass the time and have fun, test your skills and beat your score. Levels in Birdgame are getting harder and harder, and to get a high score, you must react quickly to emerging obstacles, maneuver and improve your skills in controlling the bird. Graphics and sound add to the game spirituality and create a bright atmosphere."

    static let shortDesc1 = "Control your bird and avoid logs in Birdgame, an addictive arcade game!"
    static let shortDesc2 = "Control a feathered bird and avoid obstacles in Birdgame!"
    static let shortDesc3 = "Control the winged one and overcome obstacles in Birdgame!"
    static let shortDesc4 = " Control the feathered and fly high in the Birdgame!"
    static let shortDesc5 = "Runner game in which you control a winged creature and overcome obstacles on your way!"
    static let shortDesc6 = "Become a real feathery in this addictive game!"
    static let shortDesc7 = "Go on an exciting feathered journe!"
    static let shortDesc8 = "Only real feathered people can win!"
    static let shortDesc9 = "Last as long as possible, avoiding obstacles and collecting bonuses!"
    static let shortDesc10 = "A fun game that will grab your attention!"
    
    static func getFullDesc() -> String {
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc() -> String {
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
