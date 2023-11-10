//
//  File.swift
//  
//
//  Created by admin on 11/9/23.
//

import Foundation

struct ConverterMeta: MetaProviderProtocol {
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc21 = """
Currency converter is necessary for personal needs,
travel and savings in case
of instability of the exchange rate of the official monetary unit of the country;
Settlements on foreign currency loans
Recalculation of foreign currency deposits;
International settlement services
"""
        
        let fullDesc = [fullDesc21]
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc21 = "Find out the cost of popular currencies"
        
        let shortDesc = [shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
    
}
