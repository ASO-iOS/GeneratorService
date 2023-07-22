//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct HashMeta {
    static let fullDesc1 = "Hash Generator is a reliable and efficient application that allows you to create high-quality values in MD5, SHA-1 and other algorithms with fast and reliable performance. This application is designed for those who want to protect their passwords, messages, files and other confidential information. Hash Generator has a simple and intuitive interface that allows you to quickly become familiar with its functionality."
    static let fullDesc2 = "With Hash Generator, you can easily create hashes in multiple algorithms by selecting the desired option from the list of available options. The application provides fast and accurate hash creation, making it an ideal choice for those looking for high efficiency without sacrificing quality. The app also provides a high level of security."
    static let fullDesc3 = "Hash Generator is a simple and easy-to-use application that provides high efficiency and reliability in creating hashes in MD5, SHA-1 and other algorithms. If you are looking for a reliable way to protect your confidential information, this app is a great choice for you. All the data you enter into Hash Generator is protected by encryption and will never be shared with third parties. "
    static let fullDesc4 = "Hash Generator is a unique application that will help you create strong hashes to protect your confidential information. It provides fast and accurate hash creation in multiple algorithms, making it an ideal choice for those looking for high efficiency without sacrificing quality. Hash Generator can be used for both personal and professional purposes."
    static let fullDesc5 = "With Hash Generator, you can create hashes in MD5, SHA-1 and other algorithms by selecting the desired option from the list of available options. This allows you to protect your passwords, messages, files and other confidential information from unauthorized access. Hash Generator provides a high level of security. The application also has a number of additional features that make it even more convenient and functional."
    static let fullDesc6 = "Hash Generator can be used for both personal and professional purposes. It can be used to protect passwords, messages, files and other confidential information, as well as to check the integrity of data. The application also provides fast and accurate hash creation, making it an ideal choice for those looking for high efficiency without sacrificing quality."
    static let fullDesc7 = "Hash Generator is a simple and easy-to-use application that provides high efficiency and reliability in creating hashes in MD5, SHA-1 and other algorithms. If you are looking for a reliable way to protect your confidential information, this application is an excellent choice for you. It provides fast and accurate hash creation, a high level of security, and a simple interface, making it an ideal choice for users of all levels."
    static let fullDesc8 = "Hash Generator provides a high level of security. All data you enter into the application is protected by encryption and will never be shared with third parties. This ensures maximum privacy and security of your information. You can rest assured that your data stays only with you. The app also has a number of additional features that make it even more convenient and functional."
    static let fullDesc9 = "Hash Generator can be used for both personal and professional purposes. It can be used to protect passwords, messages, files and other confidential information, as well as to check the integrity of data. The application allows you to create hashes quickly and reliably, making it an indispensable tool for various tasks. If you are looking for a reliable way to protect your confidential information, then Hash Generator is a great choice for you."
    static let fullDesc10 = "This application will help you protect your passwords, messages, files and other confidential information from unauthorized access. It is an indispensable tool for those who value the security of their data and want to be sure of protecting it.One of the main features of Hash Generator is its simple and intuitive interface. You can easily get used to its functionality even if you have had no previous experience with similar applications. All the controls are located on one screen, which makes working with the application as convenient and efficient as possible."

    static let shortDesc1 = "Create values in MD5, SHA-1, etc. quickly and reliably!"
    static let shortDesc2 = "Create safe and effective values in MD5, SHA-1, etc. with high speed and reliability!"
    static let shortDesc3 = "Create safe and efficient values in MD5, SHA-1, etc. algorithms without compromising the quality!"
    static let shortDesc4 = "Create high quality values in MD5, SHA-1 and other algorithms without compromising their efficiency!"
    static let shortDesc5 = "Create safe and efficient values in MD5, SHA-1 and other algorithms on your mobile device!"
    static let shortDesc6 = "Create high quality values in MD5, SHA-1 and other algorithms with fast and reliable performance, on your mobile device!"
    static let shortDesc7 = "Create safe and efficient values in MD5, SHA-1 and other algorithms with high speed and reliability, without compromising the quality in your mobile device!"
    static let shortDesc8 = "Create high quality values in MD5, SHA-1 and other algorithms on your cell phone without sacrificing performance!"
    static let shortDesc9 = "Quickly and reliably create cell phone values in MD5, SHA-1 etc. algorithms!"
    static let shortDesc10 = "Create high quality values in MD5, SHA-1 and other algorithms on your smartphone with fast and reliable performance without sacrificing efficiency!"
    
    static func getFullDesc() -> String {
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc() -> String {
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
