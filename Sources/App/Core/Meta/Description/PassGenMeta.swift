//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct PassGeneratorMeta: MetaProviderProtocol {
    static var appName = ""
    static let fullDesc1 = "\(appName) is a mobile application that offers the user a unique and reliable way to generate passwords. Nowadays, with more and more information being stored and transmitted over the Internet, security has become an important issue. One of the main aspects of security is the use of complex and unique passwords for all accounts. However, many people find it difficult to come up with passwords that are both secure and easy to remember. This is where \(appName) comes to the rescue. It is an intuitive and easy-to-use application that generates unique passwords for various accounts and services"
    static let fullDesc2 = "The main function of \(appName) is the generation of passwords. The application prompts the user to select a password length and specify which characters should be included in the password (numbers, upper and lower case letters, special characters). After that, \(appName) creates a random password that matches the specified parameters. Thus, the user can be sure that his or her password will be safe and tamper-proof. In addition, \(appName) offers an auto-complete password function. The application integrates with the user's browser and automatically fills in the password fields on various sites and services. This simplifies the process of logging into accounts and prevents mistakes in password entry"
    static let fullDesc3 = "One of the features of \(appName) is the ability to save the generated passwords in a secure storage. A user can create an account in the application and save all of their passwords in an encrypted form. This not only allows you to access your passwords at any time and from any device, but also ensures their security. All passwords are encrypted and only the user has access to them. Another useful feature of \(appName) is a password security check. The app analyzes the generated passwords and assesses their security. It warns the user if the password is too simple or easily hacked. This helps the user to create passwords that are as secure as possible from intruders"
    static let fullDesc4 = "\(appName) is an indispensable tool for everyone who values the security of their data and wants to have strong passwords for their accounts. The application offers an easy and convenient way to generate passwords, save them in a secure vault and automatically fill them in on various sites. Be sure your data is secure with \(appName)! However, many people face the problem of coming up with passwords that are both secure and easy to remember. This is where \(appName) comes to the rescue. It is an intuitive and easy-to-use application that generates unique passwords for various accounts and services"
    static let fullDesc5 = "\(appName) is a mobile application that offers users a unique and reliable way to generate passwords. Nowadays, with more and more information being stored and transmitted over the Internet, security has become an important issue. One of the main aspects of security is the use of complex and unique passwords for all accounts. In addition, \(appName) offers an auto-complete password feature. The application integrates with the user's browser and automatically fills in password fields on various sites and services. This simplifies the process of logging into accounts and prevents password errors"
    static let fullDesc6 = "One of the features of \(appName) is the ability to save the generated passwords in a secure storage. A user can create an account in the application and save all of their passwords in an encrypted form. This allows you not only to access your passwords at any time and from any device, but also ensures their security. All passwords are encrypted and only the user has access to them. In addition, \(appName) offers an auto-complete password function. The application integrates with the user's browser and automatically fills out password fields on various sites and services. This simplifies the process of logging into accounts and prevents mistakes in password entry."
    static let fullDesc7 = "\(appName) is an indispensable tool for everyone who values the security of their data and wants to have strong passwords for their accounts. The application offers an easy and convenient way to generate passwords, save them in a secure vault and automatically fill them in on various sites. Be sure your data is safe with \(appName)! Another useful function of \(appName) is checking the security of your passwords. The app analyzes the generated passwords and evaluates their security. It warns the user if a password is too simple or too easy to crack. This helps the user to create passwords that are as safe as possible from intruders."
    static let fullDesc8 = "\(appName) is a mobile app that helps you create strong and impenetrable passwords for all your accounts and protect your data in the digital world. Today, when we are more and more dependent on the Internet and use a lot of online services, security becomes extremely important. That's why \(appName) is your reliable companion in the world of digital security. One of the main problems we encounter when using the Internet is poor password security. Many people use simple and easy-to-guess passwords, which makes them vulnerable to hacker attacks. \(appName) solves this problem by offering you the ability to create impenetrable passwords in just one touch"
    static let fullDesc9 = "\(appName) is not just a password generator, it is your personal assistant in creating and managing passwords. You will no longer forget your passwords or use weak character combinations. \(appName) will help you to create and remember all your passwords, ensuring reliable protection of your data. An important feature of \(appName) is its reliability. The application uses advanced encryption algorithms to ensure the security of your passwords and data. All passwords are stored encrypted and only you have access to them. \(appName) also offers a password or fingerprint lock feature to prevent unauthorized access to your passwords."
    static let fullDesc10 = "\(appName) is an app that makes your life easier and safer. No matter how many accounts you have or what data you store, \(appName) is always with you to keep your privacy safe and protected. Don't risk your security and privacy. Download \(appName) now and start creating strong passwords for all your accounts. Your security is in your hands with \(appName), your own personal password generator"

    static let shortDesc1 = "The password generator is your trusted companion in the world of digital security!"
    static let shortDesc2 = "Protect your data with \(appName), your own personal password generator!"
    static let shortDesc3 = "\(appName) - create impenetrable passwords with a single click!"
    static let shortDesc4 = "No more problems with passwords - \(appName) is always with you!"
    static let shortDesc5 = "Make your life easy with \(appName)!"
    static let shortDesc6 = "Protect your privacy with \(appName), the reliable password generator!"
    static let shortDesc7 = "\(appName) is an easy way to create secure passwords for all your accounts!"
    static let shortDesc8 = "Your security is in your hands with \(appName), your personal password generator!"
    static let shortDesc9 = "Secure and handy in one app - \(appName) for your phone!"
    static let shortDesc10 = "Passwords are not a problem anymore - \(appName) will help you to create and remember them all!"
    
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
