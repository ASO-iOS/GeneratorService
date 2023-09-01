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
        default: return ANDData.empty
        }
    }
}
