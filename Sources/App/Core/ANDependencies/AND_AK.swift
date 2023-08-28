//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesAK(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.AK_RICK_AND_MORTY:
            return AKRickAndMorty.dependencies(mainData)
        case AppIDs.AK_SHASHLICK_CALCULATOR:
            return AKShahlikCalculator.dependencies(mainData)
        case AppIDs.AK_ALARM:
            return AKAlarm.dependencies(mainData)
        case AppIDs.AK_TODO:
            return AKToDo.dependencies(mainData)
        case AppIDs.AK_BOILING_EGG:
            return AKBoilingEgg.dependencies(mainData)
        case AppIDs.AK_COLOR_CONVERTER:
            return AKColorConverter.dependencies(mainData)
        case AppIDs.AK_NEW_YEAR_COUNTDOWN:
            return AKNewYearCountdowm.dependencies(mainData)
        case AppIDs.AK_UV_PROTECT:
            return AKUVProtect.dependencies(mainData)
        case AppIDs.AK_RGB_CONVERTER:
            return AKRGBConverter.dependencies(mainData)
        case AppIDs.AK_RETROGRADE_MERCURY:
            return AKRetrogradeMercury.dependencies(mainData)
        case AppIDs.AK_RANDOM_JOKE:
            return AKRandomJoke.dependencies(mainData)
        case AppIDs.AK_CARTOON_LOCATIONS:
            return AKCartoonLocations.dependencies(mainData)
        case AppIDs.AK_FRUITS:
            return AKFruits.dependencies(mainData)
        case AppIDs.AK_POKER_CHANCES:
            return AKPokerChances.dependencies(mainData)
        case AppIDs.AK_RANDOM_COFFEE:
            return AKRandomCoffee.dependencies(mainData)
        case AppIDs.AK_CLICKER:
            return AKClicker.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
