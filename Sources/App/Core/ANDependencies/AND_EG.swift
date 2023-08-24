//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesEG(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.EG_STOPWATCH:
            return EGStopwatch.dependencies(mainData)
        case AppIDs.EG_RACE:
            return EGRace.dependencies(mainData)
        case AppIDs.EG_LUCKY_NUMBER:
            return EGLuckyNumber.dependencies(mainData)
        case AppIDs.EG_DICE_ROLLER:
            return EGDiceRoller.dependencies(mainData)
        case AppIDs.EG_WATER_TRACKER:
            return EGWaterTracker.dependencies(mainData)
        case AppIDs.EG_CURRENCY_RATE:
            return EGCurrencyRate.dependencies(mainData)
        case AppIDs.EG_LEARN_SLANG:
            return EGLearnSlang.dependencies(mainData)
        case AppIDs.EG_FLASHLIGHT:
            return EGFlashlight.dependencies(mainData)
        case AppIDs.AK_RICK_AND_MORTY:
            return AKRickAndMorty.dependencies(mainData)
        case AppIDs.EG_EXPENSETRACKER:
            return EGExpenseTracker.dependencies(mainData)
        case AppIDs.EG_WHICH_SPF:
            return EGWhichSpf.dependencies(mainData)
        case AppIDs.EG_LOVE_CALCULATOR:
            return EGLoveCalculator.dependencies(mainData)
        case AppIDs.EG_GET_LYRICS_GEN:
            return EGGetLyrics.dependencies(mainData)
        case AppIDs.EG_PUZZLE_DIGITS:
            return EGPuzzleDigits.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
