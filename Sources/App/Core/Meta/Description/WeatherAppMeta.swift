//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct WeatherAppMeta: MetaProviderProtocol {
    
    

    
    static func getFullDesc(appName: String) -> String {
        
        let fullDesc1 = "\(appName) is a mobile application that provides the user with up-to-date weather information. With its help, the user can get a weather forecast for a certain period of time, find out the current temperature, humidity, wind speed and other meteorological data. The application also provides access to historical weather data. You will be able to view past years or months of weather data for any selected location. This is useful, for example, if you are planning a vacation or want to compare the current weather with previous periods."

        let fullDesc2 = "One of the main features of the app is the ability to get a weather forecast for a specific city or region. The user can enter the name of the city or use the location feature to automatically determine the current location and get the corresponding weather forecast. The app provides information about temperature, precipitation, humidity, pressure and other weather parameters for a selected period of time, such as the next few days. \(appName) is designed keeping in mind all user needs and offers various settings that you can customize as per your convenience. You can choose temperature units, customize the interface language and much more."

        let fullDesc3 = "\(appName) also provides the user with the ability to customize weather notifications. The user can set certain conditions under which they would like to receive notifications, such as when the temperature drops below a certain level or when heavy rain is expected. The app will send a notification to the user's device to keep the user updated with the current weather. \(appName) is an indispensable assistant for everyone who wants to be aware of the weather anytime and anywhere. With its features and user-friendly interface, you can always make informed decisions and adapt to the current weather conditions. Don't miss the opportunity to stay ahead of the weather with \(appName)!"

        let fullDesc4 = "One of the unique features of \(appName) is the ability to view animated weather maps. The user can see cloud movement, temperature changes, and other weather changes on an interactive map. This allows you to visualize the current and future weather and better understand its dynamics. \(appName) is a unique mobile application that will help you to be aware of the weather anywhere in the world. No matter where you are or where you are traveling to, \(appName) will provide you with the most accurate and up-to-date information on weather conditions."

        let fullDesc5 = "The application also provides the user with access to historical weather data. The user can view historical or monthly weather data for a specific location. This is useful, for example, for planning a vacation or comparing the current weather with past periods. One of the main features of the \(appName) is its ease of use. The intuitive interface makes the app easy to use even for beginners. You can easily customize the app to get weather information in the format you want. Choose your location or add your favorite places to the list to always be aware of the weather where you need it."

        let fullDesc6 = "\(appName) has a simple and intuitive interface that allows users to quickly get the weather information they need. It also offers various settings that the user can customize to their liking, such as selecting temperature units or customizing the interface language. \(appName) offers a wide range of features to fulfill all your weather tracking needs. Get up-to-date information about temperature, precipitation, wind, humidity and other weather parameters. You will be able to see the current weather and forecast for several days ahead. Moreover, you'll be able to set up weather notifications to stay informed of any changes."

        let fullDesc7 = "\(appName) is a reliable and convenient tool to get up-to-date weather information. It helps the user to keep abreast of weather changes, plan their actions and take appropriate measures. Thanks to its features and user-friendly interface, \(appName) becomes an indispensable assistant for everyone who wants to be aware of the weather anytime and anywhere. One of the key advantages of \(appName) is its accuracy and reliability of data. The app uses advanced technology and reliable sources of information to provide you with the most accurate and up-to-date weather. You can fully trust the information you receive and use it for your needs."

        let fullDesc8 = "\(appName) is a convenient and reliable mobile application that will help you always be aware of the weather anywhere and anytime. With its help, you can get up-to-date information about temperature, precipitation, wind and other weather conditions. \(appName) also offers additional features to help you plan your activities depending on the weather. Find out the best time to go for a walk, sport or picnic. The app also provides air quality information, which can be helpful for people with allergies or breathing problems."

        let fullDesc9 = "\(appName) provides a wide range of features and functions to fulfill all your weather tracking needs. You will be able to find out the current weather at your location or a place of your choice, as well as get a forecast for several days ahead. If you love traveling, \(appName) will be your trusted companion. View the weather in different cities and countries around the world. Add your favorite places to the list and easily switch between them to always be aware of the weather in different regions. No matter where you are, \(appName) will help you plan your activities and be prepared for all weather conditions."

        let fullDesc10 = "One of the main features of \(appName) is its accuracy and reliability of data. The app utilizes advanced technology and reliable sources of information to provide you with the most up-to-date and accurate weather. You can rest assured that the information you receive will be reliable and valid. In addition, \(appName) offers visual graphs and charts to help you better understand weather trends and changes. You will be able to see how temperature, precipitation and other weather parameters change throughout the day or week. This will help you make more informed decisions and plan your actions based on the weather."
        
        let fullDesc11 = "\(appName) also offers a user-friendly and intuitive interface that allows you to get the weather information you need quickly and easily. You will be able to see temperature, precipitation, humidity, wind speed and other weather parameters on the app's home screen. In addition, you will be able to customize weather notifications so that you can always be aware of changing weather conditions. \(appName) also offers the ability to customize the interface and user preferences. You can choose temperature units, time format and other settings to make the app match your preferences. You can also customize the background image or theme of the app to make it more personalized."

        let fullDesc12 = "\(appName) also offers additional features to help you plan your activities based on the weather. You can find out the best time to go for a walk, sport or picnic and whether you need an umbrella or a warm coat. The app also provides air quality information, which can be helpful for people with allergies or breathing problems. Overall, the \(appName) is an indispensable tool for anyone who wants to stay informed about the weather and use that information for their needs. Whether you are planning a vacation, sports or just everyday activities, you can rely on the accuracy and reliability of the data provided by the app. Don't miss out on the opportunity to always stay informed about the weather and download \(appName) today!"

        let fullDesc13 = "\(appName) also offers the ability to view weather in different cities and countries around the world. You can add your favorite places to the list and easily switch between them to always be aware of the weather in different regions. This is especially useful for travelers or people who are interested in weather in different parts of the world. \(appName) is an innovative mobile application that provides users with the most accurate and up-to-date weather information. With its help, you can always be aware of the current weather conditions and properly plan your actions depending on the weather forecast."

        let fullDesc14 = "\(appName) also offers visual graphs and charts that allow you to better understand weather trends and changes. You will be able to see how temperature, precipitation and other weather parameters change throughout the day or week. This will help you make more informed decisions and plan your actions based on the weather. One of the key features of the app is the ability to get a weather forecast for any city or region. With its simple and intuitive interface, you can easily find your desired location and get all the details about the weather in that area. The app provides information about temperature, humidity, wind speed, atmospheric pressure and other important weather parameters. You can also find out the forecast for a few days ahead so that you can plan your things properly."

        let fullDesc15 = "\(appName) also offers the ability to customize the interface and user preferences. You can select temperature units, time format and other settings to make the app match your preferences. You can also customize the background image or theme of the app to make it more personalized. \(appName) also offers customizable weather notifications to the user. You can set certain conditions under which you want to receive notifications, such as when the temperature drops below a certain level or when heavy rain is expected. The app will send you notifications so that you are always aware of the current weather and can take appropriate action."

        let fullDesc16 = "\(appName) is an indispensable tool for anyone who wants to be aware of the weather and use this information for their needs. Whether you are planning a vacation, sports or just everyday activities, you can rely on the accuracy and reliability of the data provided by the app. Don't miss the opportunity to always be aware of the weather and download the \(appName) today! One of the special advantages of \(appName) is the ability to view animated weather maps. You can watch cloud movement, temperature changes, and other weather phenomena on an interactive map. This allows you to visualize current and future weather and better understand its dynamics."

        let fullDesc17 = "\(appName) is an innovative mobile application that provides users with the most accurate and up-to-date weather information. With its help you can always be aware of the current weather conditions and properly plan your actions depending on the weather forecast. The application also provides access to historical weather data. You will be able to view past years or months of weather data for any selected location. This is useful, for example, if you are planning a vacation or want to compare the current weather with previous periods. \(appName) is designed with all user needs in mind and offers various settings that you can customize to your liking. You can choose temperature units, customize the interface language and much more."

        let fullDesc18 = "One of the key features of the app is the ability to get a weather forecast for any city or region. Thanks to the simple and intuitive interface, you can easily find the desired location and learn all the details about the weather in the area. The app provides information about temperature, humidity, wind speed, atmospheric pressure and other important weather parameters. You can also find out the forecast for a few days ahead to plan your things properly. \(appName) is an indispensable assistant for everyone who wants to be aware of the weather anytime and anywhere. With its features and user-friendly interface, you can always make informed decisions and adapt to the current weather conditions. Don't miss the opportunity to stay ahead of the weather with \(appName)!"

        let fullDesc19 = "\(appName) also offers customizable weather notifications to the user. You can set certain conditions under which you want to receive notifications, such as when the temperature drops below a certain level or when heavy rain is expected. The app will send you notifications so that you are always aware of the current weather and can take appropriate action. One of the key benefits of the \(appName) is its accuracy and reliability of data. The app uses advanced technology and reliable sources of information to provide you with the most accurate and up-to-date weather. You can fully trust the information you receive and use it for your needs."

        let fullDesc20 = "One of the special advantages of \(appName) is the ability to view animated weather maps. You will be able to observe cloud movement, temperature changes and other weather phenomena on an interactive map. This allows you to visualize current and future weather and better understand its dynamics. \(appName) offers a wide range of features to fulfill all your weather tracking needs. Get up-to-date information about temperature, precipitation, wind, humidity and other weather parameters. You will be able to see the current weather and forecast for several days ahead. What's more, you'll be able to set up weather notifications to stay informed of any changes."
        
        let fullDesc21 = "\(appName) is a comprehensive and reliable mobile application designed to provide you with accurate and up-to-date weather information. With \(appName), you can plan your day with confidence, stay prepared for any weather conditions, and make informed decisions based on the latest forecasts. The app features a user-friendly interface that displays real-time weather data for your current location or any location worldwide. \(appName) provides detailed information such as temperature, humidity, wind speed and pressure."
        
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20, fullDesc21]

        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        
        let shortDesc1 = "\(appName) - always up to date with the weather!"

        let shortDesc2 = "Be aware of the weather with \(appName)!"

        let shortDesc3 = "\(appName) is your reliable weather companion."

        let shortDesc4 = "Plan your activities with \(appName)."

        let shortDesc5 = "\(appName) is the best way to know the weather."

        let shortDesc6 = "Be prepared for everything with \(appName)."

        let shortDesc7 = "\(appName) - accurate and up-to-date weather information."

        let shortDesc8 = "Weather is always at your fingertips with \(appName)."

        let shortDesc9 = "\(appName) - your personal meteorologist."

        let shortDesc10 = "Plan your life with \(appName)."

        let shortDesc11 = "\(appName) - easily and conveniently find out the weather."

        let shortDesc12 = "Be aware of the weather anywhere in the world with \(appName)."

        let shortDesc13 = "\(appName) - your weather guide."

        let shortDesc14 = "Weather will never surprise you with \(appName)."

        let shortDesc15 = "\(appName) is a reliable planning assistant."

        let shortDesc16 = "Get one-touch weather with \(appName)."

        let shortDesc17 = "\(appName) - always know what to expect outside your window."

        let shortDesc18 = "Stay ahead of the weather with \(appName)."

        let shortDesc19 = "\(appName) - your real-time weather information."

        let shortDesc20 = "Weather is in your hands with \(appName)."
        
        let shortDesc21 =  "The app shows weather in your area."
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20, shortDesc21]

        return shortDesc.randomElement() ?? shortDesc1
    }
    
}
