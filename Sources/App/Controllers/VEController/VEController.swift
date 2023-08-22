//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import SwiftUI

struct VEController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, designLocation: MetaDesignLocation?, gradlePaths: GradlePaths, assetsLocation: String) {
        switch id {
        case AppIDs.VE_TYPES_OF_AIRCRAFT:
            createAircraft(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, assetsLocation: assetsLocation)
        case AppIDs.VE_ALARM_MATERIAL:
            createAlarm(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_QUIZ_BOOKS:
            createQuizBooks(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_EVERY_DAY_FACTS:
            createFacts(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_FIND_UNIVERSITY:
            createFindUniversity(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_PASS_GENERATOR:
            createPassGen(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_QUIZ_VIDEOGAMES:
            createQuizVideoGames(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_FACTS_ABOUT_DOGS:
            createFactsAboutDogs(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_LUCKY_SPAN:
            createLuckySpan(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_SOUND_RECORDER:
            createSoundRecorder(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_CALENDAR_EVENTS:
            createCalendarEvents(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_VIGENERE_CHIPHER:
            createVigenereCipher(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_RANDOM_WORD_QUIZ:
            createRandomWordQuiz(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_RECIPES_BOOK:
            createRecipesBook(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.VE_RANDOM_DOGS:
            createRandomDogs(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.VE_ENGLISH_DICTIONARY_HELPER:
            createEnglishDictionaryHelper(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
            

        default:
            return
        }
    }
}
