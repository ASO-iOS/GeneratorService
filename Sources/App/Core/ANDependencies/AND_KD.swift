//
//  File.swift
//  
//
//  Created by admin on 31.10.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesKD(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.KD_GALLERY: return KDGallery.dependencies(mainData)
        case AppIDs.KD_NAME_GENERATOR: return KDNameGenerator.dependencies(mainData)
        case AppIDs.KD_NEWS: return KDNews.dependencies(mainData)
        case AppIDs.KD_FIND_UNIVERSITY: return KDFindUniversity.dependencies(mainData)
        case AppIDs.KD_ASSATIATIONS: return KDAssotiations.dependencies(mainData)
        case AppIDs.KD_CONVERTER: return KDConverter.dependencies(mainData)
        case AppIDs.KD_CATS: return KDCats.dependencies(mainData)
        case AppIDs.KD_TODO: return KDTodo.dependencies(mainData)
        case AppIDs.KD_AFFIRMATIONS: return KDAffirmations.dependencies(mainData)
        case AppIDs.KD_NOTES: return KDNotes.dependencies(mainData)
        case AppIDs.KD_CALCULATOR: return KDCalculator.dependencies(mainData)
        case AppIDs.KD_CANVAS: return KDCanvas.dependencies(mainData)
        case AppIDs.KD_COMPOSE_QUIZ: return KDComposeQuiz.dependencies(mainData)
        case AppIDs.KD_TOP_FILMS: return KDTopFilms.dependencies(mainData)
        case AppIDs.KD_RANDOM_DOGS: return KDRandomDogs.dependencies(mainData)
        case AppIDs.KD_RANDOM_TEXT: return  KDRandomText.dependencies(mainData)
        case AppIDs.KD_SEARCH_MUSIC: return KDSearchMusic.dependencies(mainData)
        case AppIDs.KD_PEDOMETER: return KDPedometer.dependencies(mainData)
        case AppIDs.KD_EXPENSE_TRACKER: return KDExpenceTracker.dependencies(mainData)
        default: return .empty
        }
    }
}
