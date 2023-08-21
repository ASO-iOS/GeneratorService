//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesVE(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.VE_TYPES_OF_AIRCRAFT:
            return VETypesOfAircraft.dependencies(mainData)
        case AppIDs.VE_ALARM_MATERIAL:
            return VEAlarm.dependencies(mainData)
        case AppIDs.VE_QUIZ_BOOKS:
            return VEQuizBooks.dependencies(mainData)
        case AppIDs.VE_EVERY_DAY_FACTS:
            return VEFacts.dependencies(mainData)
        case AppIDs.VE_FIND_UNIVERSITY:
            return VEFindUniversity.dependencies(mainData)
        case AppIDs.VE_PASS_GENERATOR:
            return VEPassGen.dependencies(mainData)
        case AppIDs.VE_QUIZ_VIDEOGAMES:
            return VEQuizVideoGames.dependencies(mainData)
        case AppIDs.VE_FACTS_ABOUT_DOGS:
            return VEFactsAboutDogs.dependencies(mainData)
        case AppIDs.VE_LUCKY_SPAN:
            return VELuckySpan.dependencies(mainData)
        case AppIDs.VE_SOUND_RECORDER:
            return VESoundRecorder.dependencies(mainData)
        case AppIDs.VE_CALENDAR_EVENTS:
            return VECalendarEvents.dependencies(mainData)
        case AppIDs.VE_VIGENERE_CHIPHER:
            return VEVigenereCipher.dependencies(mainData)
        case AppIDs.VE_RANDOM_WORD_QUIZ:
            return VERandomWordQuiz.dependencies(mainData)
        case AppIDs.VE_RECIPES_BOOK:
            return VERecipesBook.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
