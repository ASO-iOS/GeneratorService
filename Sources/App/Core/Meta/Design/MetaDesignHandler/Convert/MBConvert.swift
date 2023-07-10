//
//  File.swift
//  
//
//  Created by admin on 10.07.2023.
//

import Foundation

extension MetaDesignProtocolConverter {
    static func mbLuckyNumberConvert(_ protocolId: String) -> MetaDesignProtocol {
        switch protocolId {
        case "MBLuckyNumberMetaDesign1":
            return MBLuckyNumberMetaDesign1()
        default:
            return ErrorDesign()
        }
    }
}
