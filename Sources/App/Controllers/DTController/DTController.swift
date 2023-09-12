//
//  File.swift
//  
//
//  Created by admin on 8/31/23.
//

import SwiftUI

struct DTController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths, mainData: MainData, maPath: String) {
        switch id {
        case AppIDs.DT_NUMBER_FACTS:
            createNumbersFacts(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData)
            
        case AppIDs.DT_PROGRAMMING_JOKES:
            createProgrammingJokes(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData)
            
        case AppIDs.DT_QR_GEN_SHARE:
            createQrGenShare(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_ROT13_ENCRYPT:
            createRot13Encrypt(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_TEXT_SIMILARITY:
            createTextSimilarity(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_RIDDLE_REALM:
            createRiddleRealm(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_NUTRITION_FINDER:
            createNutritionFinder(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_EMOJI_FINDER:
            createEmojiFinder(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_EASY_NOTES:
            createEasyNotes(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_EXERCISE_FINDER:
            createExerciseFinder(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_PHONE_VALIDATOR:
            createPhoneValidator(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_HISTORICAL_EVENTS:
            createHistoricalEvents(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_GASTRONOMY_GURU:
            createGastronomyGuru(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_WORD_WISE:
            createWordWise(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_PASSWORD_GENERATOR:
            createPasswordGenerator(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_COCTAIL_FINDER:
            createCoctailFinder(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_POPULAR_MOVIES:
            createPopularMovies(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        case AppIDs.DT_MUSIC_QUIZ:
            createMusicQuiz(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths, maPath: maPath)
            
        case AppIDs.DT_LANGUAGE_IDENTIFIRE:
            createLanguageIdentifire(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath, mainData: mainData, xmlPaths: xmlPaths)
            
        default:
            return
        }
        
    }
}
