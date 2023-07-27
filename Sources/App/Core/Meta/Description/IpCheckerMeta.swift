//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct IpCheckerMeta {
    static var appName = ""
    static let fullDesc1 = "\(appName) is a handy and useful mobile application that allows users to quickly and easily check IP address information. This app provides many useful features for analyzing and researching IP addresses to help users get the most information about them. One of the key features of \"\(appName)\" is the ability to check an IP address for location. Users can enter an IP address and get information about what country, region, and city that IP address is located in. This can be useful for location, activity tracking, or just for curiosity"
    static let fullDesc2 = "The \(appName) app also provides information about the Internet Service Provider associated with the IP address. Users can find out the name of the ISP, its contact information, and other details. This can be useful for checking network reliability and security, as well as for debugging Internet connection problems. Another important feature of \(appName) is the ability to check an IP address for blocking or spam lists. Users can find out if an IP address is blacklisted or has a bad reputation. This can help users determine if an IP address is insecure or suspicious"
    static let fullDesc3 = "The \(appName) app also provides information about the type of connection associated with an IP address. Users can find out whether an IP address is static or dynamic, and get more information about network settings. This can be useful for managing network settings and understanding connection patterns. \"\(appName)\" also provides the user with the ability to scan the ports associated with an IP address. Users can check which ports are open or closed on a particular IP address. This can be useful for checking network security and detecting potential vulnerabilities"
    static let fullDesc4 = "The \(appName) application offers a user-friendly and intuitive interface that makes using the application simple and easy for users of all skill levels. It also provides fast, accurate IP address verification using reliable data sources. In addition, \(appName) provides the ability to store a history of IP address checks so that users can easily track their requests and access previously obtained information. This allows users to save and organize data for future use"
    static let fullDesc5 = "\(appName) is a handy mobile app to help you get information about any IP address. Whether it's the IP address of your own device or the IP address of another host on the network, \(appName) will provide you with all the data and statistics you need. All in all, \"\(appName)\" is a reliable and useful application that helps users to get complete information"
    static let fullDesc6 = "With \(appName), you can find out the location of an IP address. The application uses advanced geolocation technology to pinpoint the geographic location of a host. You will know the country, region, and even city associated with a given IP address. This can be useful, for example, to track the location of your devices or to check where suspicious activity is coming from"
    static let fullDesc7 = "The \(appName) provides information about the type of IP address. You will know whether the IP address is static or dynamic. This can be useful for understanding which devices have permanent IP addresses and which may change over time"
    static let fullDesc8 = "The \(appName) provides information about the ISP associated with the IP address. You will know the name of the ISP, its organizational affiliation, and even contact information. This can be useful if you need to contact the ISP in case of network problems or for more connection information. The app also provides information about when the data was last updated. You will always know how up-to-date the information is in your hands. In addition, \(appName) allows you to save a history of requests so that you can easily track usage history and go back to previous results"
    static let fullDesc9 = "Whether you are a professional network administrator, developer or just a curious user, \(appName) will be an indispensable tool for you. Get complete information about any IP address right on your mobile device and monitor your network with confidence. \(appName) has a simple and intuitive interface that allows you to get the information you need quickly and easily. You'll be able to enter an IP address manually or use the network scanning feature to locate devices on your local network"
    static let fullDesc10 = "\(appName) is a handy mobile application that will help you get information about any IP address. Whether it's the IP address of your own device or the IP address of another host in the network, \(appName) will provide you with all the necessary data and statistics. \(appName) has a simple and intuitive interface that allows you to get the information you need quickly and easily. You will be able to enter the IP address manually or use the network scanning feature to locate devices on your local network"

    static let shortDesc1 = "Know your IP, protect your privacy!"
    static let shortDesc2 = "\(appName): guardian of your digital identity!"
    static let shortDesc3 = "Stay safe with \(appName), your personal IP tracker!"
    static let shortDesc4 = "Track, check and secure your IP with \(appName)!"
    static let shortDesc5 = "\(appName): uncover the secrets of your online presence!"
    static let shortDesc6 = "Discover your IP secrets with \(appName)!"
    static let shortDesc7 = "Keep your IP under control with \(appName), the ultimate tracker!"
    static let shortDesc8 = "\(appName): giving the knowledge of your online identity!"
    static let shortDesc9 = "\(appName): your indispensable tool for monitoring and protecting your IP address!"
    static let shortDesc10 = "Stay informed, stay protected with \(appName)!"
    
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
