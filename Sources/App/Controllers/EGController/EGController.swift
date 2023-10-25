//
//  File.swift
//  
//
//  Created by admin on 03.08.2023.
//

import SwiftUI

struct EGController {
    @ObservedObject var fileHandler: FileHandler
    func boot(id: String, appName: String, path: String, resPath: String, layoutPath: String, valuesPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, designLocation: MetaDesignLocation?, gradlePaths: GradlePaths, xmlPaths: XMLLayoutPaths) {
        switch id {
        case AppIDs.EG_STOPWATCH:
            createStopwatch(appName: appName, path: path, layoutPath: layoutPath, valuesPath: valuesPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_RACE:
            createRace(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_LUCKY_NUMBER:
            createLuckyNumber(appName: appName, path: path, resPath: resPath, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_PHONE_CHECKER:
            createPhoneChecker(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_DICE_ROLLER:
            createDiceRoller(appName: appName, path: path, resPath: resPath, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_WATER_TRACKER:
            createWaterTracker(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_CURRENCY_RATE:
            createCurrencyRate(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_LEARN_SLANG:
            createLearnSlang(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_FLASHLIGHT:
            createFlashlight(appName: appName, path: path, xmlPaths: xmlPaths, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_EXPENSETRACKER:
            createExpenseTracker(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_WHICH_SPF:
            createWhichSpf(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_GET_LYRICS_GEN:
            createGetLyrics(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_PUZZLE_DIGITS:
            createPuzzleDigits(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_COCKTAIL_CRAFT:
            createCocktailCraft(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_LOVE_CALCULATOR:
            createLoveCalculator(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.EG_TIC_TAC_TOE:
            createTicTacToe(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        default:
            print("ATTENTION\nid \(id) not found\nproject would not be created")
            return
        }
    }
}


