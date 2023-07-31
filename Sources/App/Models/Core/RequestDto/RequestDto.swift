//
//  File.swift
//  
//
//  Created by admin on 23.06.2023.
//

import Foundation

struct RequestDto: Codable {

    let mainData: RequestDtoMainData
    let ui: RequestDtoUI?
    
    enum CodingKeys: String, CodingKey {
        case mainData = "main_data"
        case ui = "ui"
    }
}







