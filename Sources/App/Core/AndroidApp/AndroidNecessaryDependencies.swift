//
//  File.swift
//  
//
//  Created by admin on 27.07.2023.
//

import Foundation

struct AndroidNecesseryDependencies {
    static func dependencies(_ mainData: MainData) -> ANDData {
        switch mainData.appId {
        case AppIDs.VS_STOPWATCH_ID:
            return VSStopwatch.dependencies(mainData)
        case AppIDs.VS_TORCH_ID:
            return VSTorch.dependencies(mainData)
        case AppIDs.VS_PHONE_INFO_ID:
            return VSPhoneInfo.dependencies(mainData)
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
        case AppIDs.BC_NAME_GENERATOR:
            return BCNameGenerator.dependencies(mainData)
        case AppIDs.IT_QUICK_WRITER:
            return ITQuickWriter.dependencies(mainData)
        case AppIDs.VE_TYPES_AIRCRAFT:
            return VETypesOfAircraft.dependencies(mainData)
        case AppIDs.VE_QUIZ_BOOKS:
            return VEQuizBooks.dependencies(mainData)
        case AppIDs.VE_FACTS:
            return VEFacts.dependencies(mainData)
        case AppIDs.VE_FIND_UNIVERSITY:
            return VEFindUniversity.dependencies(mainData)
        case AppIDs.VE_PASS_GEN:
            return VEPassGen.dependencies(mainData)
        case AppIDs.IT_STOPWATCH:
            return ITStopwatch.dependencies(mainData)
        case AppIDs.IT_DEVICE_INFO:
            return ITDeviceInfo.dependencies(mainData)
        case AppIDs.EG_STOPWATCH:
            return EGStopwatch.dependencies(mainData)
        case AppIDs.EG_RACE:
            return EGRace.dependencies(mainData)
        case AppIDs.EG_LUCKY_NUMBER:
            return EGLuckyNumber.dependencies(mainData)
        case AppIDs.EG_DICE_ROLLER:
            return EGDiceRoller.dependencies(mainData)
        case AppIDs.EG_WATER_TRACKER:
            return EGWaterTracker.dependencies(mainData)
        case AppIDs.EG_CURRENCY_RATE:
            return EGCurrencyRate.dependencies(mainData)
        case AppIDs.EG_LEARN_SLANG:
            return EGLearnSlang.dependencies(mainData)
        case AppIDs.EG_FLASHLIGHT:
            return EGFlashlight.dependencies(mainData)
        case AppIDs.AK_RICK_AND_MORTY:
            return AKRickAndMorty.dependencies(mainData)
        case AppIDs.EG_EXPENSETRACKER:
            return EGExpenseTracker.dependencies(mainData)
        case AppIDs.EG_WHICH_SPF:
            return EGWhichSpf.dependencies(mainData)
        case AppIDs.AK_SHASHLICK_CALCULATOR:
            return AKShahlikCalculator.dependencies(mainData)
        case AppIDs.AK_ALARM:
            return AKAlarm.dependencies(mainData)
        case AppIDs.AK_TODO:
            return AKToDo.dependencies(mainData)
        case AppIDs.AK_BOILING_EGG:
            return AKBoilingEgg.dependencies(mainData)
        case AppIDs.AK_COLOR_CONVERTER:
            return AKColorConverter.dependencies(mainData)
        case AppIDs.EG_LOVE_CALCULATOR:
            return EGLoveCalculator.dependencies(mainData)
        default:
            return ANDData.empty
        }
    }
}

struct ANDData {
    let mainFragmentData: ANDMainFragment
    let mainActivityData: ANDMainActivity
    let themesData: ANDThemesData
    let stringsData: ANDStringsData
    let colorsData: ANDColorsData
    var stateViewModelData: String? = ""
    var fragmentStateData: String? = ""
    
    static let empty: ANDData = {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: ""), colorsData: ANDColorsData(additional: ""))
    }()
}

struct ANDMainFragmentCMF {
    let content: String
    let fileName: String
}

struct ANDMainFragment {
    let imports: String
    let content: String
}

struct ANDMainActivity {
    let imports: String
    let extraFunc: String
    let content: String
    var extraStates: String = ""
}

struct ANDThemesData {
    let isDefault: Bool
    let content: String
}

struct ANDStringsData {
    let additional: String
}

struct ANDColorsData {
    let additional: String
}

//struct RandomizeName {
//    static func randomName() -> String {
//        let lettersUp = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
//        var lettersDown: [String]
//        lettersUp.forEach { letter in
//            lettersDown.append(letter.lowercased())
//        }
//        let len = Int.random(in: 5...15)
//        var result = lettersUp.randomElement() ?? lettersUp[0]
//        while result.count <= len {
//            result += Int.random(in: 0...1) == 0 ? lettersUp.randomElement() ?? lettersUp[0] : lettersDown.randomElement() ?? lettersDown[0]
//        }
//        return result
//    }
//}
