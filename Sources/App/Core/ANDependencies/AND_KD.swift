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
        default: return .empty
        }
    }
}
