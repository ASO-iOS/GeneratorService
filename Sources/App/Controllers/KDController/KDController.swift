//
//  File.swift
//  
//
//  Created by admin on 31.10.2023.
//

import SwiftUI

struct KDController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths, maPath: String, mainData: MainData) {
        switch id {
        case AppIDs.KD_GALLERY:
            createGallery(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_NAME_GENERATOR:
            createNamesGennerator(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.KD_NEWS:
            createNews(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_FIND_UNIVERSITY:
            createFindUniversity(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_ASSATIATIONS:
            createAssatiations(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_CONVERTER:
            createConverter(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_CATS:
            createCats(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_TODO:
            createToDo(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_AFFIRMATIONS:
            createAffirmations(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_NOTES:
            createNotes(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_CALCULATOR:
            createCalculator(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_CANVAS:
            createCanvas(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_COMPOSE_QUIZ:
            createComposeQuiz(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.KD_TOP_FILMS:
            createTopFilms(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_RANDOM_DOGS:
            createRandomDogs(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_RANDOM_TEXT:
            createRandomText(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_SEARCH_MUSIC:
            createSearchMusic(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.KD_PEDOMETER:
            createPedometer(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, maPath: maPath, mainData: mainData)
        case AppIDs.KD_EXPENSE_TRACKER:
            createExpenseTracker(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            print("ATTENTION\nid \(id) not found\nproject would not be created")
            return
        }
    }
}

