//
//  File.swift
//  
//
//  Created by admin on 10.07.2023.
//

import Foundation

extension MetaDesignProtocolConverter {
    static func vsStopwatchConvert(_ protocolId: String) -> MetaDesignProtocol {
        switch protocolId {
        case "VSStopwatchMetaDesign1":
            return VSStopwatchMetaDesign1()
        case "VSStopwatchMetaDesign2":
            return VSStopwatchMetaDesign2()
        case "VSStopwatchMetaDesign3":
            return VSStopwatchMetaDesign3()
        case "VSStopwatchMetaDesign4":
            return VSStopwatchMetaDesign4()
        case "VSStopwatchMetaDesign5":
            return VSStopwatchMetaDesign5()
        default:
            return ErrorDesign()
        }
    }
    
    static func vsPhoneInfoConvert(_ protocolId: String) -> MetaDesignProtocol {
        switch protocolId {
        case "VSPhoneInfoMetaDesign1":
            return VSPhoneInfoMetaDesign1()
        default:
            
            return ErrorDesign()
        }
    }
}
