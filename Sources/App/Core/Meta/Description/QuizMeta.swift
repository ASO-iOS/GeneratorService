//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct QuizMeta: MetaProviderProtocol {
    



    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "\(appName) is not only a great way to test your knowledge, but also a great way to learn something new. In the process of taking the quiz you can learn many interesting facts and sights that you didn't know before. Our app is suitable for all ages and knowledge levels. You can choose a category that interests you and start taking the test. Take several tests and improve your knowledge in different areas."
        let fullDesc2 = "\(appName) is a great way to spend your time with mental benefit. You can play alone or with friends, competing in knowledge. The app is suitable for use both at school and at home. Join the millions of users worldwide who have already tested their knowledge with \(appName). Start taking the quiz now and see how much you know about the world around you."
        let fullDesc3 = "In our app you will find a variety of interesting and diverse questions on a wide range of topics - from history and culture to science and technology. Take the tests, check your knowledge and learn something new! The simple and intuitive interface of the app will allow you to quickly start taking the test. Select the category you are interested in and start answering the questions. Each question has several answer choices from which you must choose the correct one. If you doubt the answer, you can use the hint or skip the question."
        let fullDesc4 = "The \(appName) application offers users a wide range of quizzes on various topics: history, science, sports, movies, music, and much more. You can choose any topic that interests you and test your knowledge in that area. Pass all the quizzes and get the maximum score! Compare your score with other users of the app and find out how well you know the world around you."
        let fullDesc5 = "By taking the tests in \(appName), you can learn a lot about the world around you. You can find out what the first Olympic Games were, who invented the telephone, which countries are members of the United Nations, and much more. All the quizzes in the application are made in such a way that they are interesting and informative for users. You can also choose the level of difficulty of the test that corresponds to your level of knowledge."
        let fullDesc6 = "\(appName) is not only an opportunity to check your knowledge, but also a great way to develop your intelligence. You will be forced to think and analyze information in order to answer test questions. This will help you improve your memory and logical thinking. The \(appName) app is suitable for all ages and knowledge levels. You can start with simple tests and gradually move on to more complex ones."
        let fullDesc7 = "\(appName) is a great way to spend your time. You can play the application anytime and anywhere. It is a great opportunity to have fun and learn something new at the same time. If you want to become a real expert in a certain field, \(appName) will help you to do it. You can take quizzes on a certain topic and learn everything about it. This will help you become a professional in your field and give you answers to any questions."
        let fullDesc8 = "\(appName) is an app that will help you expand your horizons and learn a lot about the world around you. You can play it anytime and anywhere and choose test topics of your choice. Take the tests and become a true expert with \(appName)! If you want to become a real expert in some area, \(appName) will help you do it."
        let fullDesc9 = "\(appName) is an app that will help you expand your knowledge and learn a lot about the world around you. It offers a huge selection of quizzes on various topics, from history to sports to movies. You can choose any topic that interests you and test your knowledge in that area. You can take tests on a particular topic and learn everything about it. This will help you become a professional in your field and give you answers to any questions."
        let fullDesc10 = "\(appName) is not only an opportunity to test your knowledge, but also a great way to develop your intelligence. You will be forced to think and analyze information in order to answer test questions. This will help you improve your memory and logical thinking. \(appName) is an app that will help you expand your horizons and learn a lot about the world around you. You can play it anytime and anywhere, and you can choose test topics of your choice. Take the tests and become a true expert with \(appName)!"
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10]
        return fullDesc.randomElement() ?? fullDesc1
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "Develop your intelligence with \(appName)!"
        let shortDesc2 = "\(appName) is an exciting way to learn new things!"
        let shortDesc3 = " Learn more about the world around you with the \(appName)!"
        let shortDesc4 = "The \(appName) - test your knowledge and learn something new!"
        let shortDesc5 = "Take quizzes and become a real expert with the \(appName)!"
        let shortDesc6 = "\(appName) - A game to help you get smarter!"
        let shortDesc7 = "Learn something new every day with Simple Quize!"
        let shortDesc8 = "\(appName) is the best way to learn interesting facts!"
        let shortDesc9 = "Test your knowledge in different areas with \(appName)!"
        let shortDesc10 = "\(appName) - discover new horizons of knowledge!"
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10]
        return shortDesc.randomElement() ?? shortDesc1
    }
}
