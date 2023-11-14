//
//  File.swift
//  
//
//  Created by mnats on 13.11.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesEA(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.EA_REMINDER:
            return EAReminder.dependencies(mainData)
        case AppIDs.EA_TIMER:
            return EATimer.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
