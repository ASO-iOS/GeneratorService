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
        default:
            return ANDData.empty
        }
    }
}
