//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesKL(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.KL_BMI_CALCULATOR:
            return KLBMICalculator.dependencies(mainData)
        case AppIDs.KL_CONVERTER:
            return KLMetricsConverter.dependencies(mainData)
        case AppIDs.KL_RECORDER:
            return KLRecorder.dependencies(mainData)
        case AppIDs.KL_SPEED_TEST:
            return KLSpeedTest.dependencies(mainData)
        case AppIDs.KL_RECORDER:
            return KLRecorder.dependencies(mainData)
        case AppIDs.KL_CLICK_FASTER:
            return KLClicker.dependencies(mainData)
        case AppIDs.KL_COLOR_SWATCHER:
            return KLColorSwatcher.dependencies(mainData)
        case AppIDs.KL_DS_WEAPON:
            return KLDSWeapon.dependencies(mainData)
        case AppIDs.KL_REACTION_TEST:
            return KLReactionTest.dependencies(mainData)
        case AppIDs.KL_SUPERNATURAL_QUOTES:
            return KLSupernaturalQuotes.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
