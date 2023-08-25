//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import SwiftUI

struct ITController {
    @ObservedObject var fileHandler: FileHandler
    
    func boot(id: String, appName: String, path: String, resPath: String, packageName: String, uiSettings: UISettings, metaLoc: String, designLocation: MetaDesignLocation?, gradlePaths: GradlePaths) {
        switch id {
        case AppIDs.IT_STOPWATCH:
            createStopwatch(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.IT_DEVICE_INFO:
            createDeviceInfo(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths)
        case AppIDs.IT_QUICK_WRITER:
            createQuickWriter(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_QUICK_CALK:
            createQuickCalc(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_NUMBER_GENERATOR:
            createNumberGen(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_NEXT_PAPER:
            createNextPaper(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_CINEMA_SCOPE:
            createCinemaScope(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_TRY_SECRET:
            createTrySecret(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_HERO_QUEST:
            createHeroQuest(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_WIFI_RATE:
            createWifiRate(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_LEARNING_CATS:
            createLearningCats(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_ONE_MIN_TIMER:
            createOneMinTimer(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        case AppIDs.IT_QR_GENERATOR:
            createQrGenerator(appName: appName, path: path, packageName: packageName, uiSettings: uiSettings, metaLoc: metaLoc, gradlePaths: gradlePaths, resPath: resPath)
        default:
            return
        }
    }
    
}

