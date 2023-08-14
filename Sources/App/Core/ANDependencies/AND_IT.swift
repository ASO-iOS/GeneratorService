//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesIT(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.IT_STOPWATCH:
            return ITStopwatch.dependencies(mainData)
        case AppIDs.IT_DEVICE_INFO:
            return ITDeviceInfo.dependencies(mainData)
        case AppIDs.IT_QUICK_WRITER:
            return ITQuickWriter.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
