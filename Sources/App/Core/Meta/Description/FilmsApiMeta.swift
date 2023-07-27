//
//  File.swift
//  
//
//  Created by admin on 30.06.2023.
//

import Foundation

struct FilmsAPIMeta {
    
    static var appName = ""
    static let fullDesc1 = "It's an app that helps you find movies according to your preferences and mood. With Movie Generator, you can get recommendations for movies you like and find new movies to watch. The Movie Generator has many features to help you find movies for your interests. You can choose the genre of the movie, the year of release, the rating, and more. You can also choose the mood you want to convey from watching a movie, from drama and thriller to comedy and romance."
    static let fullDesc2 = "The movie generator also provides information about the movies you've selected. You can find out the movie description, cast, rating, reviews, and more. This helps you choose a movie you really like. If you don't know what to watch, the movie generator can choose the movie for you. You can select the \"Random Choice\" feature, and the movie generator will offer you a random movie from its database. It's a great way to find something new and unexpected."
    static let fullDesc3 = "The movie generator can be useful for those who like to watch movies but don't know what to watch. It can also be useful for those who are looking for new movies to watch. You can use it to find movies that suit you and satisfy your mood. All in all, Movie Generator is a simple and easy-to-use application that will help you find movies according to your preferences and mood. You can use it to find new movies to watch or choose a movie you really like."
    static let fullDesc4 = "This is an app that will help users choose a movie to watch for the evening. This app provides the user with a wide selection of movies grouped by genre, actor, director, year of release and rating. The user can select any genre they are interested in and the app will show them a list of movies that meet their request. One of the main features of the app is the ability to select a movie by mood. The user can select his mood and the app will offer him a list of movies appropriate for that mood. For example, if the user selects a \"romantic\" mood, the app will offer him a list of romantic movies."
    static let fullDesc5 = "Another handy feature of the app is the ability to select a movie at random. If the user doesn't know what to watch, he can use this feature to choose a movie he wasn't expecting. This feature helps to avoid agonizing choices while searching for the perfect movie. The app also provides detailed information about each movie. The user can find out the film's description, actors, director, year of release, rating, and critics' reviews. This will help the user to make a more informed choice and choose a movie that they will really like."
    static let fullDesc6 = "In addition, the app provides the user with the ability to save movies to favorites. This allows the user to collect a list of movies he or she likes and return to them at any time to watch them. The Movie Generator app has a user-friendly and intuitive interface that allows the user to quickly and easily find the desired movie. This application is suitable both for movie lovers and for those who just want to spend an evening watching a good movie."
    static let fullDesc7 = "It is an application that will help you choose a movie to watch for the evening. With its help, you can quickly and easily find a movie that matches your interests and mood. One of the main features of the app is the ability to select a movie according to your mood. You can select the mood that is closest to you, and the app will suggest a list of movies that fit that mood. For example, if you're in the mood for romance, the app will offer you a list of romantic movies. If you're in the mood for adventure, science fiction, or drama, the app will select movies that fit your mood."
    static let fullDesc8 = "The \(appName) app has a user-friendly and intuitive interface that allows you to quickly and easily find the movie you want. You can select a movie by genre, actor, director, year and rating. The app provides a wide selection of movies grouped by genre, actor, director, year of release, and rating. You can select any genre you're interested in and the app will show you a list of movies that match your query. In addition, the app provides the ability to view movie trailers. This allows you to get an idea of the movie before you watch it and decide if it's right for you or not."
    static let fullDesc9 = "The \(appName) app has a user-friendly and intuitive interface that allows you to quickly and easily find the movie you want. You can select a movie by genre, actor, director, year and rating. The app provides a wide selection of movies grouped by genre, actor, director, year of release, and rating. You can select any genre you're interested in and the app will show you a list of movies that match your query. In addition, the app provides the ability to view movie trailers. This allows you to get an idea of the movie before you watch it and decide if it's right for you or not."
    static let fullDesc10 = "One of the main features of the app is the ability to select a movie according to your mood. You can select the mood you are most in tune with, and the app will suggest a list of movies that are appropriate for that mood. For example, if you're in the mood for romance, the app will offer you a list of romantic movies. If you're in the mood for adventure, science fiction, or drama, the app will select movies that fit your desires. Another handy feature of the app is the ability to select a movie at random. If you don't know what to watch, you can use this feature to choose a movie you weren't expecting. This feature helps you avoid painful choices when searching for the perfect movie."

    static let shortDesc1 = "Never waste time searching for a movie with \(appName)!"
    static let shortDesc2 = "Never miss a movie you'll love with \(appName)!"
    static let shortDesc3 = "Never be uncertain about your movie choices with \(appName)!"
    static let shortDesc4 = "Make your evening better with \(appName)!"
    static let shortDesc5 = "Never be afraid to choose a movie with \(appName) again!"
    static let shortDesc6 = "Feel like a film critic with the \(appName)!"
    static let shortDesc7 = "Never miss a new movie with \(appName)!"
    static let shortDesc8 = "Make your movie selection easier with the \(appName)!"
    static let shortDesc9 = "Never stop at one movie with \(appName)!"
    static let shortDesc10 = "Learn more about the movies you love with the \(appName)!"
    
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
