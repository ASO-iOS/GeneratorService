//
//  File.swift
//  
//
//  Created by admin on 01.09.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesDT(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.DT_NUMBER_FACTS:
            return DTNumberFacts.dependencies(mainData)
            
        case AppIDs.DT_PROGRAMMING_JOKES:
            return DTProgrammingJokes.dependencies(mainData)
            
        case AppIDs.DT_QR_GEN_SHARE:
            return DTQrGenShare.dependencies(mainData)
            
        case AppIDs.DT_ROT13_ENCRYPT:
            return DTRot13Encrypt.dependencies(mainData)
            
        case AppIDs.DT_TEXT_SIMILARITY:
            return DTTextSimilarity.dependencies(mainData)
            
        case AppIDs.DT_RIDDLE_REALM:
            return DTRiddleRealm.dependencies(mainData)
            
        case AppIDs.DT_NUTRITION_FINDER:
            return DTNutritionFinder.dependencies(mainData)
            
        case AppIDs.DT_EMOJI_FINDER:
            return DTEmojiFinder.dependencies(mainData)
            
        case AppIDs.DT_EASY_NOTES:
            return DTEasyNotes.dependencies(mainData)
            
        case AppIDs.DT_EXERCISE_FINDER:
            return DTExerciseFinder.dependencies(mainData)
            
        case AppIDs.DT_PHONE_VALIDATOR:
            return DTPhoneValidator.dependencies(mainData)
            
        case AppIDs.DT_HISTORICAL_EVENTS:
            return DTHistoricalEvents.dependencies(mainData)
            
        case AppIDs.DT_GASTRONOMY_GURU:
            return DTGastronomyGuru.dependencies(mainData)
            
        case AppIDs.DT_WORD_WISE:
            return DTWordWise.dependencies(mainData)
            
        case AppIDs.DT_PASSWORD_GENERATOR:
            return DTPasswordGenerator.dependencies(mainData)
            
        case AppIDs.DT_COCTAIL_FINDER:
            return DTCoctailFinder.dependencies(mainData)
            
        case AppIDs.DT_POPULAR_MOVIES:
            return DTPopularMovies.dependencies(mainData)
            
        case AppIDs.DT_MUSIC_QUIZ:
            return DTMusicQuiz.dependencies(mainData)
            
        case AppIDs.DT_LANGUAGE_IDENTIFIRE:
            return DTLanguageIdentifire.dependencies(mainData)
            
        default:
            return ANDData.empty
        }
    }
}
