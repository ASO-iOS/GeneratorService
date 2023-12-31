//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesKL(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.KL_BMI_CALCULATOR: return KLBMICalculator.dependencies(mainData)
        case AppIDs.KL_CONVERTER: return KLMetricsConverter.dependencies(mainData)
        case AppIDs.KL_RECORDER: return KLRecorder.dependencies(mainData)
        case AppIDs.KL_SPEED_TEST: return KLSpeedTest.dependencies(mainData)
        case AppIDs.KL_RECORDER: return KLRecorder.dependencies(mainData)
        case AppIDs.KL_CLICK_FASTER: return KLClickFaster.dependencies(mainData)
        case AppIDs.KL_COLOR_SWATCHER: return KLColorSwatcher.dependencies(mainData)
        case AppIDs.KL_DS_WEAPON: return KLDSWeapon.dependencies(mainData)
        case AppIDs.KL_REACTION_TEST: return KLReactionTest.dependencies(mainData)
        case AppIDs.KL_SUPERNATURAL_QUOTES: return KLSupernaturalQuotes.dependencies(mainData)
        case AppIDs.KL_TEA_WIKI: return KLTeaWiki.dependencies(mainData)
        case AppIDs.KL_WEATHER_APP: return KLWeatherApp.dependencies(mainData)
        case AppIDs.KL_BODY_TYPE_CACLULATOR: return KLBodyTypeCalculator.dependencies(mainData)
        case AppIDs.KL_HIDDEN_PARIS: return KLHiddenParis.dependencies(mainData)
        case AppIDs.KL_BUBBLE_PICKER: return KLBubblePicker.dependencies(mainData)
        case AppIDs.KL_MOOD_TRACKER: return KLMoodTracker.dependencies(mainData)
        case AppIDs.KL_DOT_CROSS_GAME: return KLDotCrossGame.dependencies(mainData)
        case AppIDs.KL_FLASHCARD_MAKER: return KLFlashcardMaker.dependencies(mainData)
        case AppIDs.KL_WORD_FINDER: return KLWordFinder.dependencies(mainData)
        case AppIDs.KL_DODGER: return KLDodger.dependencies(mainData)
        case AppIDs.KL_STOPWATCH: return KLStopwatch.dependencies(mainData)
        default: return ANDData.empty
        }
    }
}
