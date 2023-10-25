//
//  File.swift
//  
//
//  Created by admin on 20.10.2023.
//

import Foundation

struct CocktailFinderMeta: MetaProviderProtocol {
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "\(appName) is a handy mobile application that will help you find the perfect cocktail for any occasion. With its help you can enjoy a wide range of tasty and original cocktails, as well as get access to detailed recipes and recommendations from professional bartenders. One of the main advantages of \(appName) is its user-friendly and intuitive interface. The app is designed in such a way that even newcomers to the world of cocktails can easily navigate and find the information they need. All of the app's features are available in just a few clicks, saving you time and maximising your enjoyment of the app."

        let fullDesc2 = "One of the main features of \(appName) is its simple and intuitive interface. All of the app's features are easily accessible through a user-friendly menu, making it as simple as possible to use even for beginners. You'll be able to quickly find the right cocktail, view its composition and preparation method, and add it to your favourites list for quick access in the future. \(appName) also offers the ability to create your own cocktails. You will be able to experiment with different ingredients and proportions to create your unique cocktail. The app offers the ability to save and share your author's recipes with other users."

        let fullDesc3 = "\(appName) also offers a handy search function that allows you to find cocktails based on various criteria. You can search for cocktails by their name, ingredients, type of alcohol or even by the mood you want to experience. This will help you find the perfect cocktail for any event or mood. \(appName) offers a feature to search for cocktails by ingredient. If you have some specific ingredients you want to use but don't know what kind of cocktail to make, the app will help you find suitable recipes. You will be able to specify all the available ingredients and \(appName) will suggest you the appropriate cocktails."

        let fullDesc4 = "\(appName) offers you the ability to create your own cocktail lists and share them with friends. You can create lists for different events or parties, and add cocktails that you particularly like. This will help you organise your cocktail collection and always have a list of your favourite drinks at hand. \(appName) also offers interesting articles and tips on cocktail selection and preparation. You can learn about the latest trends in the cocktail world and get useful tips from experienced bartenders."

        let fullDesc5 = "\(appName) also offers you the opportunity to access exclusive recipes and tips from professional bartenders. You can learn the secrets of making the most popular and delicious cocktails, as well as get advice on choosing ingredients and serving utensils. This will help you become a real expert in the world of cocktails and delight your friends and family with your skills. \(appName) is the perfect app for all cocktail lovers. It offers a wide range of recipes, personalised recommendations, information about bars and restaurants, a user-friendly interface and many other useful features. With \(appName) you can enjoy delicious and original cocktails anytime and anywhere."

        let fullDesc6 = "\(appName) also offers a synchronisation feature that allows you to save all your data on a cloud server. This means that you will be able to access your cocktail lists and recipes from any internet-connected device. You'll be able to use the app on your smartphone, tablet or even your computer without losing access to your data. \(appName) is a unique and innovative mobile app that will help you find the perfect cocktail for any occasion. Whether it's a party with friends, a romantic dinner or just a relaxing evening after a hard day's work, \(appName) will always be there to help you choose the perfect drink."

        let fullDesc7 = "\(appName) is the perfect app for all cocktail lovers. It offers a wide range of cocktails, a user-friendly interface, a search function, the possibility of creating lists and data synchronisation. With its help you can enjoy delicious drinks, learn new recipes and become a real expert in the world of cocktails. Don't miss the opportunity to try \(appName) and discover new gastronomic experiences! One of the key features of \(appName) is its simple and intuitive interface. All of the app's functions are accessed through a user-friendly menu, making it as easy and convenient to use as possible, even for beginners. You will be able to easily find the desired cocktail, view its composition and method of preparation, and add it to your list of favourites for quick access in the future."

        let fullDesc8 = "\(appName) is a mobile application that will help you find and enjoy the most delicious and original cocktails. With this app you can easily and quickly find the nearest bars and restaurants that prepare cocktails, as well as learn about their range and rating. \(appName) offers a huge selection of delicious and original cocktails. You can enjoy a wide range of drinks including classic cocktails, signature recipes and seasonal specialities. Whether you prefer strong and rich flavours or fresh and fruity, \(appName) will always offer you plenty of options to choose from."

        let fullDesc9 = "One of the main features of \(appName) is its extensive cocktail database. The app contains hundreds of different recipes, ranging from classic cocktails such as Margaritas and Mojitos to modern author's cocktails. You will be able to find out all the necessary ingredients and proportions to make each cocktail, as well as detailed instructions on how to make it. One of the unique features of \(appName) is its search function. You can easily search for cocktails based on various criteria such as name, ingredients, type of alcohol or even the mood you want to experience. This will help you quickly find the perfect cocktail for any event or mood."

        let fullDesc10 = "\(appName) also offers personalised recommendations. It takes into account your alcohol preferences, flavour preferences and even the time of year to suggest the most suitable cocktails for you. You'll be able to create your list of favourite cocktails and share them with friends via social media. \(appName) also offers the ability to create your own cocktail lists and share them with friends. You can create lists for different events or parties, and add cocktails that you particularly like. This will help you organise your cocktail collection and always have a list of your favourite drinks on hand."
        
        let fullDesc11 = "The app also provides information about bars and restaurants where you can try the cocktails you are interested in. You can find out their address, opening hours, contact information and even see reviews from other users. In addition, \(appName) offers a table reservation feature so you can be sure of your seat at your chosen establishment. \(appName) offers access to exclusive recipes and tips from professional bartenders. You can learn the secrets of making the most popular and delicious cocktails, as well as get tips on choosing ingredients and serving utensils. This will help you become a real expert in the world of cocktails and delight your friends and family with your skills."

        let fullDesc12 = "One of the main advantages of \(appName) is its user-friendly and intuitive interface. The app is designed in such a way that even newcomers to the world of cocktails can easily navigate and find the information they need. All of the app's features are available in just a few clicks, saving you time and maximising your enjoyment of the app. \(appName) also offers a synchronisation feature that allows you to save all your data on a cloud server. This means that you will be able to access your cocktail lists and recipes from any internet-connected device. You'll be able to use the app on your smartphone, tablet, or even your computer without losing access to your data."

        let fullDesc13 = "\(appName) also offers the possibility to create your own cocktails. You can experiment with different ingredients and proportions to create your own unique cocktail. The app provides the ability to save and share your own author's recipes with other users. \(appName) is the perfect app for all cocktail lovers. It offers a wide range of drinks, a user-friendly interface, a search function, the ability to create lists and data synchronisation. With its help you can enjoy delicious drinks, learn new recipes and become a real expert in the world of cocktails. Don't miss the opportunity to try \(appName) and discover new gastronomic experiences!"

        let fullDesc14 = "\(appName) offers a function to search for cocktails by ingredients. If you have some specific ingredients you want to use but don't know what kind of cocktail to make, the app will help you find suitable recipes. You will be able to specify all the available ingredients and \(appName) will suggest you the appropriate cocktails. \(appName) is a unique and innovative mobile app that will help you find the perfect cocktail for any occasion. Whether it's a party with friends, a romantic dinner or just a relaxing evening after a hard day's work, \(appName) will always be there to help you choose the perfect drink."

        let fullDesc15 = "\(appName) also offers interesting articles and tips on cocktail selection and preparation. You can learn about the latest trends in the world of cocktails and get useful tips from experienced bartenders. One of the key features of \(appName) is its simple and intuitive interface. All of the app's functions are accessed through a convenient menu, making it as easy and convenient to use as possible, even for beginners. You can easily find the right cocktail, view its composition and preparation method, and add it to your list of favourites for quick access in the future."

        let fullDesc16 = "\(appName) is the perfect app for all cocktail lovers. It offers a wide range of recipes, personalised recommendations, bar and restaurant information, a user-friendly interface and many other useful features. With \(appName) you can enjoy delicious and original cocktails anytime and anywhere. \(appName) offers a huge selection of tasty and original cocktails. You can enjoy a rich range of drinks including classic cocktails, signature recipes and seasonal specialities. Whether you prefer strong and rich flavours or fresh and fruity, \(appName) will always offer you plenty of options to choose from."

        let fullDesc17 = "\(appName) is an innovative mobile application that will become your indispensable assistant in finding and enjoying the most exquisite and unique cocktails. With its help you can easily and quickly find the nearest cocktail establishments and learn all about their variety and rating. One of the unique features of \(appName) is its search function. You can easily search for cocktails based on various criteria such as name, ingredients, type of alcohol or even the mood you want to experience. This will help you quickly find the perfect cocktail for any event or mood."

        let fullDesc18 = "One of the main features of \(appName) is its extensive cocktail database. The app features hundreds of different recipes, ranging from classic cocktails like Margaritas and Mojitos to modern signature cocktails. You can find out all the necessary ingredients and proportions to make each cocktail, as well as detailed instructions on how to make it. \(appName) also offers the ability to create your own cocktail lists and share them with friends. You can create lists for different events or parties, and add cocktails that you particularly like. This will help you organise your cocktail collection and always have a list of your favourite drinks on hand."

        let fullDesc19 = "\(appName) also offers personalised recommendations, taking into account your alcohol preferences, taste preferences and even the time of year. Thanks to this, the app offers you the most suitable and personalised cocktails. You will be able to create your list of favourite cocktails and share them with friends via popular social networks. \(appName) offers access to exclusive recipes and recommendations from professional bartenders. You can learn the secrets of making the most popular and delicious cocktails, as well as get tips on choosing ingredients and serving utensils. This will help you become a real expert in the world of cocktails and please your friends and family with your skills."

        let fullDesc20 = "The app also provides full information about bars and restaurants where you can try the cocktails you are interested in. You can find out their address, opening hours, contact information and even read reviews from other users. In addition, \(appName) offers a table booking feature so you can be sure of your seat at your chosen establishment. \(appName) also offers a synchronisation feature that allows you to save all your data on a cloud server. This means you'll be able to access your cocktail lists and recipes from any internet-connected device. You'll be able to use the app on your smartphone, tablet, or even your computer without losing access to your data."
        
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20]

        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "Find your perfect cocktail with \(appName)!"

        let shortDesc2 = "discover the world of cocktails with \(appName)!"

        let shortDesc3 = "All the best cocktails in one place - \(appName)!"

        let shortDesc4 = "Satisfy your cocktail cravings with \(appName)!"

        let shortDesc5 = "Enjoy exquisite cocktails with \(appName)!"

        let shortDesc6 = "Find your cocktail paradise with \(appName)!"

        let shortDesc7 = "Prepare the most delicious cocktails with \(appName)!"

        let shortDesc8 = "Discover new flavour facets with \(appName)!"

        let shortDesc9 = "Never get lost in the world of cocktails with \(appName)!"

        let shortDesc10 = "Find your favourite cocktail combination with \(appName)!"

        let shortDesc11 = "Make cocktails like a pro with \(appName)!"

        let shortDesc12 = "Dive into the world of exclusive cocktails with \(appName)!"

        let shortDesc13 = "Enjoy unique cocktails with \(appName)!"

        let shortDesc14 = "Discover new cocktail flavours with \(appName)!"

        let shortDesc15 = "Unlimited possibilities for your cocktail experiments with \(appName)!"

        let shortDesc16 = "Find your cocktail inspiration with \(appName)!"

        let shortDesc17 = "Create your own cocktail recipe with \(appName)!"

        let shortDesc18 = "Learn all about cocktails and bars with \(appName)!"

        let shortDesc19 = "Never miss the best cocktail establishments with \(appName)!"

        let shortDesc20 = "Discover the world of cocktails with \(appName)!"
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20]

        return shortDesc.randomElement() ?? shortDesc1
    }
    
    
}
