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
    static let MB_SERIALS =          "mb-0017"
    
    static let BC_PREFIX =           "bc"
    static let BC_NAME_GENERATOR =   "bc-0001"
    
    static let IT_PREFIX =           "it"
    static let IT_QUICK_WRITER =     "it-0001"
    static let IT_STOPWATCH =        "it-0002"
    static let IT_DEVICE_INFO =      "it-0003"
    
    static let VE_PREFIX =           "ve"
    static let VE_TYPES_AIRCRAFT =   "ve-0001"
    static let VE_ALARM =            "ve-0002"
    static let VE_QUIZ_BOOKS =       "ve-0003"
    static let VE_FACTS =            "ve-0004"
    static let VE_FIND_UNIVERSITY =  "ve-0005"
    static let VE_PASS_GEN =         "ve-0006"
    
    static let AK_PREFIX =           "ak"
    static let AK_RICK_AND_MORTY =   "ak-0001"
    static let AK_SHASHLICK_CALCULATOR = "ak-0002"
    static let AK_ALARM =            "ak-0003"
    
    static let KL_PREFIX =           "kl"
    
    static let EG_PREFIX =           "eg"
    static let EG_STOPWATCH =        "eg-0001"
    static let EG_RACE =             "eg-0002"
    static let EG_LUCKY_NUMBER =     "eg-0003"
    static let EG_PHONE_CHECKER =    "eg-0004"
    static let EG_DICE_ROLLER =      "eg-0005"
    static let EG_WATER_TRACKER =    "eg-0006"
    static let EG_CURRENCY_RATE =    "eg-0007"
    static let EG_LEARN_SLANG =      "eg-0008"
    static let EG_FLASHLIGHT =       "eg-0009"
    static let EG_EXPENSETRACKER =   "eg-0010"
    static let EG_WHICH_SPF =        "eg-0011"

    
    static func checkSupportedProject(_ id: String) -> Bool {
        let unsupportedIds = [AppIDs.MB_CHECK_IP]
        if unsupportedIds.contains(id) {
            return false
        } else {
            return true
        }
    }
}

