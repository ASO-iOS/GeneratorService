//
//  File.swift
//  
//
//  Created by admin on 13.06.2023.
//

import Foundation

struct AttackerMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "It’s an arcade shooter where the player has to control a spaceship and defend the earth from invading enemies. The player must skillfully control the ship, shoot the invading enemies, and use tactical tricks and cover-ups to survive this ruthless space battle."
        let fullDesc2 = "This  game with excellent graphics, which allows players to plunge into the exciting space atmosphere and enjoy the exciting action. Attacker offers exciting missions and addictive gameplay that will please fans of arcade shooters."
        let fullDesc3 = "This game is an excellent choice for fans of rich arcade combat atmosphere and vivid visual effects. The player is also able to control his ship using gestures on the smartphone screen, which adds extra convenience to the gameplay."
        let fullDesc4 = "Arcade shooters have always been popular, and Attacker is no exception. This game has simple gameplay, but at the same time is challenging enough to make the player use all his gaming skills. In this game you will be able to plunge into the exciting space atmosphere and enjoy the exciting action."
        let fullDesc5 = "If you are a fan of arcade shooters and you like exciting games, then Attacker is exactly what you need. It is an addictive game with excellent graphics and addictive gameplay. Various difficulty levels can be selected in Attacker to ease the difficulty, allowing beginners to immerse themselves in the gameplay without stress, while more experienced players will be challenged with higher difficulty levels"
        let fullDesc6 = "This game offers exciting missions and addictive gameplay that will please fans of arcade shooters. The game features different types of enemies with different abilities and unique combat tactics, which adds a variety of gameplay and makes the player always stay on the edge of their strengths."
        let fullDesc7 = "This game, which will allow any player to feel like a real space hero and become the savior of earth. You will skillfully control the ship, shoot at the advancing enemies and use tactical tricks and cover-ups to survive in this ruthless space battle."
        let fullDesc8 = "This is an arcade shooter where the player has to control a spaceship and defend Earth from invading enemies. Join the exciting battles in Attacker and become the best in this battle for survival."
        let fullDesc9 = "This game is a combination of classic arcade shooter and modern gameplay experience, which makes the game unique. Players will be able to enjoy exciting graphics, vivid effects and sound special effects as they play."
        let fullDesc10 = "Embark on an exciting \(appName) using a variety of combat tactics, weapons and cover-ups, and become the best defender of Earth in Attacker! Attacker has an easy interface that makes the game simple and easy to use, even for beginners."
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "Immerse yourself in the exciting world of \(appName)!"
        let shortDesc2 = "Join an exciting space game!"
        let shortDesc3 = "Go on an exciting \(appName)!"
        let shortDesc4 = "Become the hero of the universe in this exciting game!"
        let shortDesc5 = "Immerse yourself in the exciting space world!"
        let shortDesc6 = "Become a real hero in this exciting game!"
        let shortDesc7 = "Embark on an exciting space journey!"
        let shortDesc8 = "Only real heroes can win!"
        let shortDesc9 = "Only the strong of spirit can triumph in the vastness of space!"
        let shortDesc10 = "A fascinating space game that will capture your attention!"
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
