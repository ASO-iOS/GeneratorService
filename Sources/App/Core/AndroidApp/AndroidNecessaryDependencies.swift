//
//  File.swift
//  
//
//  Created by admin on 27.07.2023.
//

import Foundation

struct AndroidNecesseryDependencies {
    static func dependencies(appId: String, packageName: String) -> ANDData {
        switch appId {
        case AppIDs.VS_STOPWATCH_ID:
            return VSStopwatch.dependencies(packageName)
        case AppIDs.VS_TORCH_ID:
            return VSTorch.dependencies(packageName)
        case AppIDs.VS_PHONE_INFO_ID:
            return VSPhoneInfo.dependencies(packageName)
        case AppIDs.MB_STOPWATCH:
            return MBStopwatch.dependencies(packageName)
        case AppIDs.MB_SPEED_TEST:
            return MBSpeedTest.dependencies(packageName)
        case AppIDs.MB_PING_TEST:
            return MBPingTest.dependencies(packageName)
        case AppIDs.MB_ALARM:
            return MBAlarm.dependencies(packageName)
        case AppIDs.MB_CHECK_IP:
            return MBIpChecker.dependencies(packageName)
        case AppIDs.MB_LUCKY_NUMBER:
            return MBLuckyNumber.dependencies(packageName)
        case AppIDs.MB_SPACE_FIGHTER:
            return MBSpaceFighter.dependencies(packageName)
        case AppIDs.MB_RICK_AND_MORTY:
            return MBRickNMorty.dependencies(packageName)
        case AppIDs.MB_BMI_CALC_ID:
            return MBBmi.dependencies(packageName)
        case AppIDs.MB_CATCHER:
            return MBCatcher.dependencies(packageName)
        case AppIDs.MB_FACTS:
            return MBFacts.dependencies(packageName)
        case AppIDs.MB_RACE:
            return MBRace.dependencies(packageName)
        case AppIDs.MB_TORCH:
            return MBTorch.dependencies(packageName)
        case AppIDs.MB_PASS_GEN:
            return MBPassGen.dependencies(packageName)
        case AppIDs.MB_DEVICE_INFO:
            return MBDeviceInfo.dependencies(packageName)
        case AppIDs.MB_HASH_GEN:
            return MBHashGen.dependencies(packageName)
        case AppIDs.MB_SERIALS:
            return MBSerials.dependencies(packageName)
        default:
            return ANDData.empty
        }
    }
}

struct ANDData {
    let mainFragmentData: ANDMainFragment
    let mainActivityData: ANDMainActivity
    let buildGradleData: ANDBuildGradle
    
    static let empty: ANDData = {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), buildGradleData: ANDBuildGradle(obfuscation: true, dependencies: ""))
    }()
}

struct ANDMainFragment {
    let imports: String
    let content: String
}

struct ANDMainActivity {
    let imports: String
    let extraFunc: String
    let content: String
}

struct ANDBuildGradle {
    let obfuscation: Bool
    let dependencies: String
}
