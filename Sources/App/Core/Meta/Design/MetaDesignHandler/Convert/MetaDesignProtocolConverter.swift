//
//  File.swift
//  
//
//  Created by admin on 10.07.2023.
//

import Foundation

struct MetaDesignProtocolConverter {
    static func convert(prefix: String, protocolId: String, appId: String) -> MetaDesignProtocol {
        switch prefix {
        case AppIDs.VS_PREFIX:
            switch appId {
            case AppIDs.VS_STOPWATCH_ID:
                return vsStopwatchConvert(protocolId)
            case AppIDs.VS_PHONE_INFO_ID:
                return vsPhoneInfoConvert(protocolId)
            default:
                return ErrorDesign()
            }
        case AppIDs.MB_PREFIX:
            switch appId {
            case AppIDs.MB_LUCKY_NUMBER:
                return mbLuckyNumberConvert(protocolId)
            default:
                return ErrorDesign()
            }
        default:
            return ErrorDesign()
        }
    }
}
