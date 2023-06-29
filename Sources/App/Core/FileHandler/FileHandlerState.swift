//
//  File.swift
//  
//
//  Created by admin on 01.06.2023.
//

import Foundation

enum FileHandlerState: String {
    case processing, success, failure, none
    
    var process: String {
        switch self {
        case .processing:
            return "In Progress"
        case .success:
            return "Success"
        case .failure:
            return "Failure"
        case .none:
            return "None"
        }
    }
}
