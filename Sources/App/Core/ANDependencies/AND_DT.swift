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
            
        default:
            return ANDData.empty
        }
    }
}
