//
//  File.swift
//  
//
//  Created by admin on 08.08.2023.
//

import Foundation

struct NameGeneratorMeta: MetaProviderProtocol {


    static func getFullDesc(appName: String) -> String {
        
        let fullDesc1 = "\(appName) is a mobile application that will help you choose a smart, original and personalized name. With its help, you can easily create a unique name that will reflect your personality and be remembered by others. Finding the perfect name can be a difficult and costly process. However, thanks to \(appName), this process will become much easier and more interesting. The application offers a wide range of creative names that can be a source of inspiration for you and your family. One of the main features of \(appName) is its ability to create names that will have a special meaning for you. You will be able to specify keywords or meanings that you would like to see in a name, and the app will offer you options that match your preferences."

        let fullDesc2 = "\(appName) also offers different styles and themes for names. You can choose a classic name, a modern name, a fantasy name, or a name associated with a particular culture or country. This will help you find a name that reflects your personality and interests. The app also offers the ability to turn an ordinary name into an extraordinary work of art. You can play with different combinations of letters, sounds and meanings to create a unique name that will be remembered by those around you. \(appName) will also help you find a name that will inspire you every day. You'll be able to specify your interests, hobbies, or values, and the app will suggest names related to those topics. This will help you find a name that reflects your passion and motivation."

        let fullDesc3 = "One of the biggest challenges in finding a name is availability and uniqueness. \(appName) offers a wide variety of names that are not only unique but also sound beautiful. You will be able to find a name that you will enjoy for a lifetime and leave a mark in people's hearts. \(appName) is also a great helper for parents who are looking for a name for their child. The app offers different categories and name styles that will help you find a name that will be a source of pride for you and your family. Overall, \(appName) is a mobile app that will help you find the perfect name. With its unique features and capabilities, you will be able to create a name that reflects your personality, inspires you, and stays in the minds of those around you. Never worry about finding a name again - \(appName) is here to help you open up a world of possibilities for your name."

        let fullDesc4 = "\(appName) is a mobile application that will help you choose a smart, original and individual name. With its help, you can easily create a unique name that will reflect your personality and be remembered by those around you. Finding the perfect name can be a difficult and costly process. However, thanks to \(appName), this process will become much easier and more interesting. The application offers a wide range of creative names that can be a source of inspiration for you and your family. One of the main features of \(appName) is its ability to create names that will have a special meaning for you. You will be able to specify keywords or meanings that you would like to see in a name, and the app will offer you options that match your preferences."

        let fullDesc5 = "\(appName) also offers different styles and themes for names. You can choose a classic name, a modern name, a fantasy name, or a name associated with a particular culture or country. This will help you find a name that reflects your personality and interests. The app also offers the ability to turn an ordinary name into an extraordinary work of art. You can play with different combinations of letters, sounds and meanings to create a unique name that will be remembered by those around you. \(appName) will also help you find a name that will inspire you every day. You'll be able to specify your interests, hobbies, or values, and the app will suggest names related to those topics. This will help you find a name that reflects your passion and motivation."

        let fullDesc6 = "One of the biggest challenges in finding a name is availability and uniqueness. \(appName) offers a wide variety of names that are not only unique but also sound beautiful. You will be able to find a name that you will enjoy for a lifetime and leave a mark in people's hearts. \(appName) is also a great helper for parents who are looking for a name for their child. The app offers different categories and name styles that will help you find a name that will be a source of pride for you and your family. Overall, \(appName) is a mobile app that will help you find the perfect name. With its unique features and capabilities, you will be able to create a name that reflects your personality, inspires you, and stays in the minds of those around you. Never worry about finding a name again - \(appName) is here to help you open up a world of possibilities for your name."

        let fullDesc7 = "\(appName) is a mobile application that will help you choose a smart, original and individual name. With its help, you can easily create a unique name that will reflect your personality and be remembered by those around you. Finding the perfect name can be a difficult and costly process. However, thanks to \(appName), this process will become much easier and more interesting. The application offers a wide range of creative names that can be a source of inspiration for you and your family. One of the main features of \(appName) is its ability to create names that will have a special meaning for you. You will be able to specify keywords or meanings that you would like to see in a name, and the app will offer you options that match your preferences."

        let fullDesc8 = "\(appName) also offers different styles and themes for names. You can choose a classic name, a modern name, a fantasy name, or a name associated with a particular culture or country. This will help you find a name that reflects your personality and interests. The app also offers the ability to turn an ordinary name into an extraordinary work of art. You can play with different combinations of letters, sounds and meanings to create a unique name that will be remembered by those around you. \(appName) will also help you find a name that will inspire you every day. You'll be able to specify your interests, hobbies, or values, and the app will suggest names related to those topics. This will help you find a name that reflects your passion and motivation."

        let fullDesc9 = "One of the biggest challenges in finding a name is availability and uniqueness. \(appName) offers a wide variety of names that are not only unique but also sound beautiful. You will be able to find a name that you will enjoy for a lifetime and leave a mark in people's hearts. \(appName) is also a great helper for parents who are looking for a name for their child. The app offers different categories and name styles that will help you find a name that will be a source of pride for you and your family. Overall, \(appName) is a mobile app that will help you find the perfect name. With its unique features and capabilities, you will be able to create a name that reflects your personality, inspires you, and stays in the minds of those around you. Never worry about finding a name again - \(appName) is here to help you open up a world of possibilities for your name."

        let fullDesc10 = "\(appName) is a unique mobile application that will help you choose a smart, original and personalized name. Finding the perfect name can be difficult, but thanks to \(appName), this process will become much easier and more fun. One of the main features of \(appName) is its ability to create names that will have special meaning to you. You will be able to specify keywords or meanings that you would like to see in a name, and the app will offer you options that match your preferences. This is a great opportunity to find a name that will not only be beautiful, but also have deep meaning for you."

        let fullDesc11 = "\(appName) also offers different styles and themes for names. You can choose a classic name, a modern name, a fantasy name, or a name related to a particular culture or country. This will help you find a name that reflects your personality and interests. Whether it's a name related to your favorite movie or book, or a name that reflects your nationality or culture, \(appName) will help you find the one name that will be unique and special. The app also offers the possibility to turn an ordinary name into an extraordinary work of art. You can play with different combinations of letters, sounds and meanings to create a unique name that will be remembered by those around you. This is a great opportunity to express your creativity and create a name that reflects your personality."

        let fullDesc12 = "\(appName) will also help you find a name that will inspire you every day. You will be able to specify your interests, hobbies or values and the app will suggest names related to these topics. This will help you find a name that reflects your passion and motivation. Whether you are inspired by sports, art, science or nature, \(appName) will help you find a name that reflects your passion and motivation. One of the biggest challenges in finding a name is availability and uniqueness. \(appName) offers a wide variety of names that are not only unique but also sound beautiful. You will be able to find a name that will delight you for a lifetime and leave a mark in people's hearts. Whether it's a name for your baby, pet or just for yourself, \(appName) will help you find a name that is special and memorable."

        let fullDesc13 = "\(appName) is also a great helper for parents who are looking for a name for their child. The app offers different name categories and styles to help you find a name that will be a source of pride for you and your family. Whether it's a traditional name or a modern name, \(appName) will help you find a name that reflects your love and care for your child. Overall, \(appName) is a mobile app that will help you find the perfect name. With its unique features and capabilities, you will be able to create a name that reflects your personality, inspires you and stays in the minds of those around you. Never worry about finding a name again - \(appName) is here to help you open up a world of possibilities for your name."

        let fullDesc14 = "\(appName) is a unique mobile app that will help you choose a clever, original and personalized name. Finding the perfect name can be difficult, but thanks to \(appName), this process will become much easier and more fun. One of the main features of \(appName) is its ability to create names that will have special meaning to you. You will be able to specify keywords or meanings that you would like to see in a name, and the app will offer you options that match your preferences. This is a great opportunity to find a name that will not only be beautiful, but also have deep meaning for you."

        let fullDesc15 = "\(appName) also offers different styles and themes for names. You can choose a classic name, a modern name, a fantasy name, or a name associated with a particular culture or country. This will help you find a name that reflects your personality and interests. Whether it's a name related to your favorite movie or book, or a name that reflects your nationality or culture, \(appName) will help you find the one name that will be unique and special. The app also offers the possibility to turn an ordinary name into an extraordinary work of art. You can play with different combinations of letters, sounds and meanings to create a unique name that will be remembered by those around you. This is a great opportunity to express your creativity and create a name that reflects your personality."

        let fullDesc16 = "\(appName) will also help you find a name that will inspire you every day. You will be able to specify your interests, hobbies or values and the app will suggest names related to these topics. This will help you find a name that reflects your passion and motivation. Whether you are inspired by sports, art, science or nature, \(appName) will help you find a name that reflects your passion and motivation. One of the biggest challenges in finding a name is availability and uniqueness. \(appName) offers a wide variety of names that are not only unique but also sound beautiful. You will be able to find a name that will delight you for a lifetime and leave a mark in people's hearts. Whether it's a name for your baby, pet or just for yourself, \(appName) will help you find a name that is special and memorable."

        let fullDesc17 = "\(appName) is also a great helper for parents who are looking for a name for their child. The app offers different name categories and styles to help you find a name that will be a source of pride for you and your family. Whether it's a traditional name or a modern name, \(appName) will help you find a name that reflects your love and care for your child. Overall, \(appName) is a mobile app that will help you find the perfect name. With its unique features and capabilities, you will be able to create a name that reflects your personality, inspires you and stays in the minds of those around you. Never worry about finding a name again - \(appName) is here to help you open up a world of possibilities for your name."

        let fullDesc18 = "\(appName) is a unique mobile application that will help you choose a smart, original and personalized name. Finding the perfect name can be difficult, but thanks to \(appName), this process will become much easier and more fun. One of the main features of \(appName) is its ability to create names that will have special meaning to you. You will be able to specify keywords or meanings that you would like to see in a name, and the app will offer you options that match your preferences. This is a great opportunity to find a name that will not only be beautiful, but also have deep meaning to you. \(appName) will also help you find a name that will inspire you every day. You will be able to specify your interests, hobbies, or values and the app will suggest you names related to these topics. This will help you find a name that reflects your passion and motivation. Whether you are inspired by sports, art, science or nature, \(appName) will help you find a name that reflects your passion and motivation."

        let fullDesc19 = "\(appName) also offers different styles and themes for names. You can choose a classic name, a modern name, a fantasy name, or a name associated with a particular culture or country. This will help you find a name that reflects your personality and interests. Whether it's a name associated with your favorite movie or book, or a name that reflects your ethnicity or culture, \(appName) will help you find the one name that is unique and special. \(appName) is also a great helper for parents looking for a name for their child. The app offers different name categories and styles to help you find a name that will be a source of pride for you and your family. Whether it's a traditional name or a modern name, \(appName) will help you find a name that reflects your love and care for your child."

        let fullDesc20 = "The app also offers the possibility to turn an ordinary name into an extraordinary work of art. You can play with different combinations of letters, sounds and meanings to create a unique name that will be remembered by others. This is a great opportunity to express your creativity and create a name that reflects your personality. \(appName) will also help you find a name that will inspire you every day. You will be able to specify your interests, hobbies, or values and the app will suggest names related to these topics. This will help you find a name that reflects your passion and motivation. Whether you are inspired by sports, art, science or nature, \(appName) will help you find a name that reflects your passion and motivation."
        

        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20]

        return fullDesc.randomElement() ?? fullDesc1

    }



    static func getShortDesc(appName: String) -> String {
        
        let shortDesc1 = "\(appName) - a selection of clever and original names!"

        let shortDesc2 = "\(appName) - an assistant in finding the perfect name!"

        let shortDesc3 = "\(appName) - create a unique name with ease!"

        let shortDesc4 = "\(appName) - your way to creative names!"

        let shortDesc5 = "\(appName) - find a name that reflects your personality!"

        let shortDesc6 = "\(appName) - a tool to create names that will be remembered!"

        let shortDesc7 = "\(appName) - putting creativity into a name!"

        let shortDesc8 = "\(appName) - never worry about finding a name again!"

        let shortDesc9 = "\(appName) - open up a world of possibilities for your name!"

        let shortDesc10 = "\(appName) - give your name a special meaning!"

        let shortDesc11 = "\(appName) - find a name that inspires you every day!"

        let shortDesc12 = "\(appName) - create a name that sounds like music!"

        let shortDesc13 = "\(appName) - turn an ordinary name into an extraordinary work of art!"

        let shortDesc14 = "\(appName) - your name, your story!"

        let shortDesc15 = "\(appName) - find a name that will delight you all your life!"

        let shortDesc16 = "\(appName) - names that will leave a mark in people's hearts!"

        let shortDesc17 = "\(appName) - help you find a name that suits your needs!"

        let shortDesc18 = "\(appName) - your name, your destiny!"

        let shortDesc19 = "\(appName) - open new horizons for your name!"

        let shortDesc20 = "\(appName) - create a name that will be a pride for you and your loved ones!"



        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20]

        return shortDesc.randomElement() ?? shortDesc1

    }
}
