//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesVS(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.VS_STOPWATCH_ID:
            return VSStopwatch.dependencies(mainData)
        case AppIDs.VS_TORCH_ID:
            return VSTorch.dependencies(mainData)
        case AppIDs.VS_PHONE_INFO_ID:
            return VSPhoneInfo.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
