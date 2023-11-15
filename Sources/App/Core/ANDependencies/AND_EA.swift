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
        case AppIDs.EA_CLOCK:
            return EAClock.dependencies(mainData)
        case AppIDs.EA_PASSGEN:
            return EAPassGen.dependencies(mainData)
        case AppIDs.EA_COLORQUIZ:
            return EAColorQuiz.dependencies(mainData)
        case AppIDs.EA_DEVICEINFO:
            return EADeviceInfo.dependencies(mainData)
        case AppIDs.EA_SCRAMBLE:
            return EAScramble.dependencies(mainData)
        case AppIDs.EA_PLANETARIUM:
            return EAPlanetarium.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
