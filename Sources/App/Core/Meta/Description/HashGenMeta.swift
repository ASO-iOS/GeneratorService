//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct HashMeta: MetaProviderProtocol {
    



    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "\(appName) is a reliable and efficient application that allows you to create high-quality values in MD5, SHA-1 and other algorithms with fast and reliable performance. This application is designed for those who want to protect their passwords, messages, files and other confidential information. \(appName) has a simple and intuitive interface that allows you to quickly become familiar with its functionality."
        let fullDesc2 = "With \(appName), you can easily create hashes in multiple algorithms by selecting the desired option from the list of available options. The application provides fast and accurate hash creation, making it an ideal choice for those looking for high efficiency without sacrificing quality. The app also provides a high level of security."
        let fullDesc3 = "\(appName) is a simple and easy-to-use application that provides high efficiency and reliability in creating hashes in MD5, SHA-1 and other algorithms. If you are looking for a reliable way to protect your confidential information, this app is a great choice for you. All the data you enter into \(appName) is protected by encryption and will never be shared with third parties. "
        let fullDesc4 = "\(appName) is a unique application that will help you create strong hashes to protect your confidential information. It provides fast and accurate hash creation in multiple algorithms, making it an ideal choice for those looking for high efficiency without sacrificing quality. \(appName) can be used for both personal and professional purposes."
        let fullDesc5 = "With \(appName), you can create hashes in MD5, SHA-1 and other algorithms by selecting the desired option from the list of available options. This allows you to protect your passwords, messages, files and other confidential information from unauthorized access. \(appName) provides a high level of security. The application also has a number of additional features that make it even more convenient and functional."
        let fullDesc6 = "\(appName) can be used for both personal and professional purposes. It can be used to protect passwords, messages, files and other confidential information, as well as to check the integrity of data. The application also provides fast and accurate hash creation, making it an ideal choice for those looking for high efficiency without sacrificing quality."
        let fullDesc7 = "\(appName) is a simple and easy-to-use application that provides high efficiency and reliability in creating hashes in MD5, SHA-1 and other algorithms. If you are looking for a reliable way to protect your confidential information, this application is an excellent choice for you. It provides fast and accurate hash creation, a high level of security, and a simple interface, making it an ideal choice for users of all levels."
        let fullDesc8 = "\(appName) provides a high level of security. All data you enter into the application is protected by encryption and will never be shared with third parties. This ensures maximum privacy and security of your information. You can rest assured that your data stays only with you. The app also has a number of additional features that make it even more convenient and functional."
        let fullDesc9 = "\(appName) can be used for both personal and professional purposes. It can be used to protect passwords, messages, files and other confidential information, as well as to check the integrity of data. The application allows you to create hashes quickly and reliably, making it an indispensable tool for various tasks. If you are looking for a reliable way to protect your confidential information, then \(appName) is a great choice for you."
        let fullDesc10 = "This application will help you protect your passwords, messages, files and other confidential information from unauthorized access. It is an indispensable tool for those who value the security of their data and want to be sure of protecting it.One of the main features of \(appName) is its simple and intuitive interface. You can easily get used to its functionality even if you have had no previous experience with similar applications. All the controls are located on one screen, which makes working with the application as convenient and efficient as possible."
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "Create values in MD5, SHA-1, etc. quickly and reliably!"
        let shortDesc2 = "Create safe and effective values in MD5, SHA-1, etc. with high speed and reliability!"
        let shortDesc3 = "Create safe and efficient values in MD5, SHA-1, etc. algorithms without compromising the quality!"
        let shortDesc4 = "Create high quality values in MD5, SHA-1 and other algorithms without compromising their efficiency!"
        let shortDesc5 = "Create safe and efficient values in MD5, SHA-1 and other algorithms on your mobile device!"
        let shortDesc6 = "Create high quality values in MD5, SHA-1 and other algorithms with fast and reliable performance, on your mobile device!"
        let shortDesc7 = "Create safe and efficient values in MD5, SHA-1 and other algorithms with high speed and reliability, without compromising the quality in your mobile device!"
        let shortDesc8 = "Create high quality values in MD5, SHA-1 and other algorithms on your cell phone without sacrificing performance!"
        let shortDesc9 = "Quickly and reliably create cell phone values in MD5, SHA-1 etc. algorithms!"
        let shortDesc10 = "Create high quality values in MD5, SHA-1 and other algorithms on your smartphone with fast and reliable performance without sacrificing efficiency!"
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
