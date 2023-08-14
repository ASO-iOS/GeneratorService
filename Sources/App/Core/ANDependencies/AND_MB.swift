//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

extension AndroidNecesseryDependencies {
    static func dependenciesMB(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.MB_STOPWATCH:
            return MBStopwatch.dependencies(mainData)
        case AppIDs.MB_SPEED_TEST:
            return MBSpeedTest.dependencies(mainData)
        case AppIDs.MB_PING_TEST:
            return MBPingTest.dependencies(mainData)
        case AppIDs.MB_ALARM:
            return MBAlarm.dependencies(mainData)
        case AppIDs.MB_CHECK_IP:
            return MBIpChecker.dependencies(mainData)
        case AppIDs.MB_LUCKY_NUMBER:
            return MBLuckyNumber.dependencies(mainData)
        case AppIDs.MB_SPACE_FIGHTER:
            return MBSpaceFighter.dependencies(mainData)
        case AppIDs.MB_RICK_AND_MORTY:
            return MBRickNMorty.dependencies(mainData)
        case AppIDs.MB_BMI_CALC_ID:
            return MBBmi.dependencies(mainData)
        case AppIDs.MB_CATCHER:
            return MBCatcher.dependencies(mainData)
        case AppIDs.MB_FACTS:
            return MBFacts.dependencies(mainData)
        case AppIDs.MB_RACE:
            return MBRace.dependencies(mainData)
        case AppIDs.MB_TORCH:
            return MBTorch.dependencies(mainData)
        case AppIDs.MB_PASS_GEN:
            return MBPassGen.dependencies(mainData)
        case AppIDs.MB_DEVICE_INFO:
            return MBDeviceInfo.dependencies(mainData)
        case AppIDs.MB_HASH_GEN:
            return MBHashGen.dependencies(mainData)
        case AppIDs.MB_SERIALS:
            return MBSerials.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}
