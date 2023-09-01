//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesBC(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.BC_NAME_GENERATOR: return BCNameGenerator.dependencies(mainData)
        default: return ANDData.empty
        }
    }
}
