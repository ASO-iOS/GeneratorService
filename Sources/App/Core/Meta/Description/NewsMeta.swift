//
//  File.swift
//  
//
//  Created by admin on 03.11.2023.
//

import Foundation

struct NewsMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "\(appName) is a mobile application designed to get up-to-date news from all over the world. With the help of this application users will be able to keep up to date with all the latest events happening in various fields: politics, economy, sports, science, culture and much more. \(appName) is a wide range of news sources. Users are able to choose the publications they are most interested in and receive news only from them. This allows each user to customise the application to their needs and receive only the information they are really interested in."

        let fullDesc2 = "One of the main features of \(appName) is its user-friendly and intuitive interface. Users will be able to easily navigate through the app thanks to its simple and clear design. All news is divided into categories, which allows you to quickly find the information you are interested in. \(appName) offers a unique feature of personalising the news feed. Users can choose the topics they are interested in and the app will select news that corresponds to these topics. Thus, each user can receive only the information that is really important and interesting for him/her."

        let fullDesc3 = "The \(appName) app offers a wide range of news sources. Users will be able to select the publications they are most interested in and receive news only from them. Thanks to this functionality, each user will be able to customise the application to their needs and receive only the information they are interested in. Another useful feature of \(appName) is the ability to save interesting news for later reading. Users can add news to their favourites and read them later when they have free time. This is especially convenient for those who can't always read all the news of interest instantly."

        let fullDesc4 = "\(appName) offers a feature to personalise the news feed. Users can select topics that they are interested in and the app will pick news relevant to those topics. In this way, each user can receive only the information that is really important to them. \(appName) also offers a handy notification feature. Users can configure the app so that they receive notifications about the most important news. This way, no important information will pass by the user."

        let fullDesc5 = "Another useful feature of \(appName) is the ability to save news of interest for later reading. Users can add news to their favourites and read them later when they have free time. This is especially convenient for those who can't always read all the news they are interested in instantly. \(appName) offers the ability to share news with friends and family. Users can send news via various messaging platforms or social media to share interesting information with others."

        let fullDesc6 = "\(appName) also offers a notification feature. Users can customise the app so that they are notified about the most important news. This way, no important information will pass by the user. \(appName) ensures the security of the users. All news sources are vetted for credibility and reliability to provide users with only reliable information. Users can rest assured that they are getting true news and are not being exposed to fraudulent sites."

        let fullDesc7 = "\(appName) offers the ability to share news with friends and family. Users can send news via various messaging platforms or social networks to share interesting information with other people. \(appName) is a unique and useful application for getting up-to-date news. With a wide range of news sources, personalisation of the news feed and the ability to save news of interest, users will be able to keep up to date with all the latest happenings in the world. In addition, notification features and the ability to share news make the app even more convenient and functional. \(appName) is an indispensable assistant for those who want to keep up to date with all the news and keep up to date with the world."

        let fullDesc8 = "\(appName) ensures the safety of users. All news sources are checked for validity and reliability to provide users with only reliable information. Users can rest assured that they are getting true news and are not being exposed to fraudulent sites. \(appName) is a unique and innovative mobile application that offers users convenient and quick access to the most relevant news from different fields. Thanks to the wide range of information provided by the app, users can keep up to date with the latest events and news in real time."

        let fullDesc9 = "\(appName) is a convenient and useful application for getting up-to-date news. With a wide range of news sources, personalisation of the news feed and the ability to save news of interest, users can keep up to date with all the latest events in the world. In addition, notification features and the ability to share news make the app even more convenient and functional. \(appName) is an indispensable assistant for those who want to stay up to date with all the news and keep up to date with the events in the world. One of the main features of the \(appName) app is its intuitive and simple interface. This allows users to easily find the information they are interested in and quickly switch between different news categories. The interface of the application is designed in such a way that the user can use all the functions of the application as comfortably as possible and find the necessary information without unnecessary effort."

        let fullDesc10 = "The \(appName) mobile app is a convenient and feature-rich news source that offers users a wide range of information from various fields. With this app, users can keep up to date with the latest events and news in real time. The \(appName) app offers a wide range of news categories including politics, economy, sports, science, culture, entertainment and many more. Users can select the categories they are interested in and get up-to-date news from these areas. With such a variety of categories, every user will be able to find information that interests them."

        let fullDesc11 = "One of the main features of the \(appName) app is its simple and intuitive interface. This allows users to easily find the information they are interested in and quickly switch between different news categories. One of the key features of the app is the ability to set up a personalised news stream. Users can select the topics and keywords that interest them most, and the app will automatically select news that matches these preferences. This allows users to receive only the news that really matters to them and not waste time reading uninteresting information."

        let fullDesc12 = "The \(appName) app offers a wide range of news categories including politics, economy, sports, science, culture, entertainment and more. Users can select the categories they are interested in and receive up-to-date news from these areas. Another useful feature of the \(appName) app is the ability to save interesting articles and news for later reading. Users can bookmark and organise their personal news library so that they can access them anytime and anywhere. This is especially handy for those who want to refer back to the information they have read or save it for future reference."

        let fullDesc13 = "One of the main features of the app is the ability to set up a personalised news stream. Users can choose the topics and keywords that interest them most, and the app will automatically select news that matches these preferences. This allows users to receive only the news that really matters to them. The \(appName) app also offers a notifications feature. Users can set up notifications for the latest news in selected categories or by keywords. This allows you to stay up to date even when the app is not open. Notifications can be customised to the user's liking so that important information is not missed."

        let fullDesc14 = "\"\(appName)\" offers the ability to save interesting articles and news for later reading. Users can bookmark and organise their personal news library to access them anytime and anywhere. One of the main advantages of the \(appName) app is its fast speed and optimised performance. The app loads and updates quickly, allowing the user to get up-to-date news in real time. This is especially important for those who want to stay up to date and don't want to waste time waiting for information to download."

        let fullDesc15 = "The \(appName) app also has a notifications feature. Users can set up notifications for the latest news in selected categories or by keywords. This allows you to stay up-to-date even when the app is not open. \(appName) offers a news search feature. Users can search for news by keyword, author or category to find information that interests them. This allows you to quickly find the information you need and stay up to date."

        let fullDesc16 = "One of the main advantages of the \(appName) app is its fast performance and optimised operation. The app loads and updates quickly, allowing the user to get up-to-date news in real time. \(appName) is a convenient and useful tool for getting up-to-date news. Thanks to its versatility and user-friendly interface, users can keep up to date with the latest events and information of interest anytime and anywhere. It offers a wide range of news categories, personalised news stream, save and notifications feature, making it an indispensable tool for anyone who wants to keep up to date with what's happening in the world."

        let fullDesc17 = "\"\(appName)\" offers a news search function. Users can search for news by keyword, author or category to find information that interests them. \(appName) is a unique mobile application that offers users convenient and quick access to the most relevant news from around the world. With this innovative app, users can make sure that they are always up to date with all important events in various areas of life, including politics, economy, sports, science, culture and much more."

        let fullDesc18 = "\"\(appName)\" is a convenient and useful tool for getting up-to-date news. Thanks to its multifunctionality, users can keep up to date with the latest events and information of interest anytime and anywhere. It offers a wide range of news categories, personalised news stream, save and notifications feature, making it an indispensable tool for anyone who wants to keep up to date with what's happening in the world. One of the main features of \(appName) is its simple and intuitive interface. Users can easily navigate through the application and quickly find the information they are interested in. All the news is categorised, which makes it convenient to navigate through different topics."

        let fullDesc19 = "\(appName) is an innovative mobile application that offers users a unique opportunity to keep up to date with all the current news from around the world. Thanks to this app, users can be sure that they will not miss any important events in different areas of life such as politics, economy, sports, science, culture and many more. \(appName) is a wide selection of news sources. Users can choose the publications they are most interested in and receive news only from them. This allows each user to customise the application to their needs and receive only the information they are really interested in."

        let fullDesc20 = "The main feature of \(appName) is its intuitive and user-friendly interface, which allows users to easily navigate through the application. The simple and clear design allows you to quickly find the information you are interested in, as all news is categorised. \(appName) offers a unique feature of personalising the news feed. Users can select the topics they are interested in, and the application will select the news that corresponds to these topics. Thus, each user will be able to receive only the information that is really important and interesting for him/her."
        
        let fullDesc21 = "Daily news about what is happening in Russia, Belarus and the world, stars, sports and kittens. Find the latest news: read articles from different media in one application. View colorful photos"
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20, fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 =  "\(appName) is your source for up-to-date news!"

        let shortDesc2 =  "Stay up to date with \(appName)!"

        let shortDesc3 =  "\(appName) - always be the first to know the top news!"

        let shortDesc4 =  "The \(appName) app is your trusted guide to the world of news!"

        let shortDesc5 =  "Quick and easy access to news with \(appName)!"

        let shortDesc6 =  "\(appName) - your personal information assistant!"

        let shortDesc7 =  "Stay up to date with \(appName)!"

        let shortDesc8 =  "\(appName) is your key to the world of breaking news!"

        let shortDesc9 =  "Get only the information you are interested in with \(appName)!"

        let shortDesc10 =  "\(appName) is your indispensable source of information!"

        let shortDesc11 =  "Be at the centre of what's happening with \(appName)!"

        let shortDesc12 =  "Never miss important news with \(appName)!"

        let shortDesc13 =  "\(appName) is your main information partner!"

        let shortDesc14 =  "Personalise your news feed with \(appName)!"

        let shortDesc15 =  "Stay up to date with \(appName)!"

        let shortDesc16 =  "\(appName) is your trusted guide to the world of news!"

        let shortDesc17 =  "Get the latest news with \(appName)!"

        let shortDesc18 =  "Stay ahead of the curve with \(appName)!"

        let shortDesc19 =  "\(appName) is your link to up-to-date information!"

        let shortDesc20 =  "Never miss an important moment with \(appName)!"
        
        let shortDesc21 =  "The app will tell you about the newest and most relevant events."
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20, shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
    
}
