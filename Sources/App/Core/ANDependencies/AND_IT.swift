//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesIT(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.IT_STOPWATCH:
            return ITStopwatch.dependencies(mainData)
        case AppIDs.IT_DEVICE_INFO:
            return ITDeviceInfo.dependencies(mainData)
        case AppIDs.IT_QUICK_WRITER:
            return ITQuickWriter.dependencies(mainData)
        case AppIDs.IT_QUICK_CALK:
            return ITQuickCacl.dependencies(mainData)
        case AppIDs.IT_NUMBER_GENERATOR:
            return ITNumberGen.dependencies(mainData)
        case AppIDs.IT_NEXT_PAPER:
            return ITNextPaper.dependencies(mainData)
        case AppIDs.IT_CINEMA_SCOPE:
            return ITCinemaScope.dependencies(mainData)
        case AppIDs.IT_TRY_SECRET:
            return ITTRySecret.dependencies(mainData)
        case AppIDs.IT_HERO_QUEST:
            return ITHeroQuest.dependencies(mainData)
        case AppIDs.IT_WIFI_RATE:
            return ITWifiRate.dependencies(mainData)
        case AppIDs.IT_LEARNING_CATS:
            return ITLearningCats.dependencies(mainData)
        case AppIDs.IT_ONE_MIN_TIMER:
            return ITOneMinTimer.dependencies(mainData)
        case AppIDs.IT_QR_GENERATOR:
            return ITQrGenerator.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
