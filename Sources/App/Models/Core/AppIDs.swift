//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import Foundation

struct AppIDs {
    
    static let ALPHA_PREFIX =       "alpha"
    
    static let VS_PREFIX =           "vs"
    static let VS_STOPWATCH_ID =     "vs-0001"
    static let VS_TORCH_ID =         "vs-0002"
    static let VS_PHONE_INFO_ID =    "vs-0003"
    static let VS_PAIRS_ID =         "0000-0000-0000-0004"
    static let VS_DICTIONARY_ID =    "0000-0000-0000-0005"
    static let VS_CLOCK_ID =         "0000-0000-0000-0006"
    static let VS_AGE_PREDICTOR_ID = "0000-0000-0000-0007"
    
    static let JK_PREFIX =           "jk"
    static let JK_ADVICE_ID =        "0000-0000-0000-0008"
    static let JK_MEMENTO_ID =       "0000-0000-0000-0009"
    static let JK_NOTE_ID =          "0000-0000-0000-0010"
    static let JK_RANDOM_NUMBER_ID = "0000-0000-0000-0011"
    
    static let SK_PREFIX =           "sk"
    static let SK_DOODLE_JUMP_ID =   "0000-0000-0000-0012"
    static let SK_INDIAN_NAMES_ID =  "0000-0000-0000-0013"
    static let SK_TETRIS_ID =        "0000-0000-0000-0014"
    static let SK_VEHICLE_QUIZ_ID =  "0000-0000-0000-0015"
    static let SK_WHO_ARE_YOU_ID =   "0000-0000-0000-0016"
    
    static let MB_PREFIX =           "mb"
    static let MB_STOPWATCH =        "mb-0001"
    static let MB_SPEED_TEST =       "mb-0002"
    static let MB_PING_TEST =        "mb-0003"
    static let MB_ALARM =            "mb-0004"
    static let MB_CHECK_IP =         "mb-0012"
    static let MB_LUCKY_NUMBER =     "mb-0005"
    static let MB_SPACE_FIGHTER =    "mb-0010"
    static let MB_RICK_AND_MORTY =   "mb-0013"
    static let MB_NOTES =            "0000-0000-0000-0026"
    static let MB_RECORDER =         "0000-0000-0000-0027"
    static let MB_CATS_GALLERY =     "0000-0000-0000-0028"
    static let MB_BMI_CALC_ID =      "mb-0011"
    static let MB_TIC_TAC_TOE =      "0000-0000-0000-0030"
    static let MB_WEATHER =          "0000-0000-0000-0031"
    static let MB_NOTEBOOK =         "0000-0000-0000-0032"
    static let MB_QR =               "0000-0000-0000-0033"
    static let MB_TIMER =            "0000-0000-0000-0034"
    static let MB_CAMERA =           "0000-0000-0000-0035"
    static let MB_CATCHER =          "mb-0006"
    static let MB_CLICKER =          "0000-0000-0000-0037"
    static let MB_FACTS =            "mb-0007"
    static let MB_RACE =             "mb-0008"
    static let MB_TORCH =            "mb-0009"
    static let MB_PASS_GEN =         "mb-0014"
    static let MB_DEVICE_INFO =      "mb-0015"
    static let MB_HASH_GEN =         "mb-0016"
    
    static func checkSupportedProject(_ id: String) -> Bool {
        let unsupportedIds = [AppIDs.MB_CHECK_IP]
        if unsupportedIds.contains(id) {
            return false
        } else {
            return true
        }
    }
}
