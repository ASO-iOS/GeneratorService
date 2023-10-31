//
//  File.swift
//  
//
//  Created by admin on 27.07.2023.
//

import Foundation

struct AndroidNecesseryDependencies {
    static func dependencies(_ mainData: MainData) -> ANDData {
        switch mainData.prefix {
        case AppIDs.VS_PREFIX:
            return dependenciesVS(mainData)
        case AppIDs.MB_PREFIX:
            return dependenciesMB(mainData)
        case AppIDs.AK_PREFIX:
            return dependenciesAK(mainData)
        case AppIDs.BC_PREFIX:
            return dependenciesBC(mainData)
        case AppIDs.EG_PREFIX:
            return dependenciesEG(mainData)
        case AppIDs.IT_PREFIX:
            return dependenciesIT(mainData)
        case AppIDs.VE_PREFIX:
            return dependenciesVE(mainData)
        case AppIDs.KL_PREFIX:
            return dependenciesKL(mainData)
        case AppIDs.DT_PREFIX:
            return dependenciesDT(mainData)
        case AppIDs.KD_PREFIX:
            return dependenciesKD(mainData)
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
    var annotation = ""
    var mainScreenAnnotation = ""
}

struct ANDMainActivity {
    let imports: String
    let extraFunc: String
    let content: String
    var extraStates: String = ""
    var onCreateAnnotation = ""
    
    static let empty = ANDMainActivity(imports: "", extraFunc: "", content: "")
}

struct ANDThemesData {
    let isDefault: Bool
    let content: String
    
    static let def = ANDThemesData(isDefault: true, content: "")
}

struct ANDStringsData {
    let additional: String
}

struct ANDColorsData {
    let additional: String
    
    static let empty = ANDColorsData(additional: "")
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
