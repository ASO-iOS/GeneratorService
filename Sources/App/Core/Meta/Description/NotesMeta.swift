//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct NotesMeta {
    static var appName = ""
    static let fullDesc1 = "\(appName) is a simple notepad. It allows you to take notes, reminders, emails, messages, to-do lists, and shopping lists easily and easily. \(appName) is easier to create notes than any other notebook or organizer. This application allows you to create notes quickly and easily, making it an indispensable tool for various tasks."
    static let fullDesc2 = "\(appName) is a handy note taking application that will help you organize your life and not forget important moments. It is a simple notepad that allows you to quickly and easily write notes, reminders, emails, messages, to-do lists and shopping. All the controls are in one screen, which makes working with the application as convenient and efficient as possible."
    static let fullDesc3 = "If you are looking for a simple and convenient way to organize your life and not to forget important moments, \(appName) is a great choice for you. It provides fast and accurate note taking, a high level of security and a simple interface, making it the perfect choice for users of all levels. Whether you are a professional developer or just want to organize your life, \(appName) will help you achieve that goal."
    static let fullDesc4 = "\(appName) can be used for both personal and professional purposes. One of the main features of Note is its simple and intuitive interface. You can easily get used to its functionality even if you have had no previous experience with similar applications. All the controls are located on one screen, which makes working with the application as convenient and efficient as possible."
    static let fullDesc5 = "\(appName) can be used to create notes, reminders, emails, messages, to-do lists and shopping. The application also has a number of additional features that make it even more convenient and functional. You can easily customize the color of your notes to quickly and easily distinguish them. In addition, the app supports multiple languages, allowing you to choose the best option for your particular task."
    static let fullDesc6 = "\(appName) is an application that will be an indispensable assistant in organizing your life. With it you can create notes on any topic, from shopping to important business meetings. \(appName) is a handy notebook that allows you to quickly and easily write down everything you need."
    static let fullDesc7 = "\(appName) can be used for both personal and professional purposes. It can be used to create notes, reminders, emails, messages, to-do lists and shopping. The application allows you to create notes quickly and easily, making it an indispensable tool for various tasks."
    static let fullDesc8 = "If you are looking for an easy and convenient way to organize your life and not to forget important moments, \(appName) is a great choice for you. It provides fast and accurate note taking, a high level of security and a simple interface, making it an ideal choice for users of all levels. Whether you're a professional developer or just want to organize your life, \(appName) will help you achieve that goal."
    static let fullDesc9 = "\(appName) is a simple and easy-to-use note taking application that will help you organize your life and not forget important moments. It provides a high level of security, a simple interface and a number of additional features that make it an ideal choice for users of all levels. If you are looking for a reliable tool to organize your life, \(appName) is a great choice for you."
    static let fullDesc10 = "\(appName) is a handy notebook that allows you to quickly and easily write down everything you need. One of the main features of \(appName) is its simple and intuitive interface. You can easily get the hang of its functionality, even if you have had no previous experience with such applications. All the controls are located on one screen, which makes working with the application as convenient and efficient as possible."

    static let shortDesc1 = "Never forget an important thing with \(appName)!"
    static let shortDesc2 = "Organize your life with \(appName)!"
    static let shortDesc3 = "All the important moments in one place - in \(appName)!"
    static let shortDesc4 = "Write down everything you need in \(appName)!"
    static let shortDesc5 = "\(appName) is your personal assistant for organizing your life!"
    static let shortDesc6 = "Easily and conveniently create notes with \(appName)!"
    static let shortDesc7 = "\(appName) is a reliable tool for organizing your life!"
    static let shortDesc8 = "Never miss an important thing with \(appName)!"
    static let shortDesc9 = "Write down everything you need quickly and easily with \(appName)!"
    static let shortDesc10 = "Stay organized with \(appName)!"
    
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
