//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct RememberColorMeta: MetaProviderProtocol {
    



    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "\(appName) is based on scientific studies that show that association with colors can significantly increase the efficiency of remembering information. The app offers you a number of different tasks that require you to remember color combinations and their sequence. You will train your memory, analyze and improve your visualization and association skills. \(appName) is a fun mobile app that will help you develop your memory and improve your color perception."
        let fullDesc2 = "\(appName) is an innovative mobile app that will help you develop and improve your memory using the color association method. This unique app offers a fun and interesting way to train your brain and improve your ability to remember information. Do not miss the opportunity to improve your memory and develop your cognitive skills with \(appName). This app will be your indispensable assistant in memory training and reaching new heights. Download \(appName) now and start your journey to better memory and mental flexibility!"
        let fullDesc3 = "\(appName) offers different game modes so that you can choose the most suitable one for you. In \"Practice\" mode you can practice without limits, improving your skills and increasing your results. In \"Test\" mode, you will face different levels of difficulty, where you will have to memorize and reconstruct color sequences in a limited amount of time. This will allow you to test your skills and compete against other players."
        let fullDesc4 = "\(appName) also offers the ability to create your own training programs. You can choose the number and difficulty of tasks, customize the time and game modes to tailor the app to your needs and goals. This makes the app completely customizable and personalized. The \(appName) app also has the ability to practice color perception. You will be offered different tasks related to identifying the color scheme or finding differences between different shades. This will help you become more attentive to details and improve your perception of color."
        let fullDesc5 = "\(appName) also offers various additional features. You can track your progress and statistics to see your improvements over time. The app also provides many achievements and rewards that motivate you to keep practicing and achieve new results. This app is perfect for all ages and can be used for both entertainment and brain training. In addition, \(appName) offers you the ability to create your own color palettes."
        let fullDesc6 = "\(appName) has an intuitive and attractive interface that makes it accessible to all users, regardless of age or skill level. You can easily operate the app and enjoy its functionality without any hassle. \(appName) also offers you the ability to use the app in offline mode, so you can play or practice anytime and anywhere, even without internet access. This makes the app convenient and portable, and you can always use it whenever it suits you."
        let fullDesc7 = "\(appName) is a great mobile app for developing memory and improving color perception. It offers you various games and drills to help you become better at remembering color information. Thanks to a simple interface and the possibility to play offline, you can enjoy the app anytime and anywhere. Don't miss the opportunity to improve your memory and develop your color perception skills with \(appName)!"
        let fullDesc8 = "\(appName) is a fun mobile app that will help you develop your memory and improve your color perception. This app is ideal for all ages and can be used for both entertainment and brain training. One of the main functions of \(appName) is memory training. The app prompts you to memorize the sequence of colors that will be displayed on the screen. Then you will have to reproduce this sequence by clicking on the colors in the correct order. With each level the difficulty of the game will increase, so you will gradually improve your skills and develop your memory."
        let fullDesc9 = "In the \(appName) application there is also the possibility to train your color perception. You will be offered various tasks connected with the definition of the color scale or with the searching of differences between different shades. It will help you to become more attentive to details and improve your color perception. In addition, \(appName) offers you the opportunity to create your own color palettes. You can choose from a wide range of available colors and create unique combinations that you can save and use in the future. This is a great way for designers, artists or just anyone who is interested in color and wants to experiment with it."
        let fullDesc10 = "\(appName) is a great mobile app for developing memory and improving color perception. It offers you various games and exercises to help you become better at remembering color information. Thanks to a simple interface and the possibility to play offline, you can enjoy the app anytime and anywhere. Don't miss the opportunity to improve your memory and develop your color perception skills with \(appName)! This makes the app convenient and portable, and you can always use it whenever you want."
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "Remember colors with \(appName)!"
        let shortDesc2 = "Improve your color perception with \(appName)!"
        let shortDesc3 = "Develop your memory with \(appName)!"
        let shortDesc4 = "Play and train your brain with \(appName)!"
        let shortDesc5 = "Create your own color palettes with \(appName)!"
        let shortDesc6 = "Become a color master with \(appName)!"
        let shortDesc7 = "Improve your color perception skills with \(appName)!"
        let shortDesc8 = "Play and compete with your friends in \(appName)!"
        let shortDesc9 = "Immerse yourself in the world of colors with \(appName)!"
        let shortDesc10 = "Forget about boring workouts, play \(appName)!"
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
