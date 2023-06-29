//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

enum ScreenOrientationEnum: String {
    case portrait, landscape, full
    
    var name: String {
        switch self {
        case .portrait:
            return "portrait"
        case .landscape:
            return "landscape"
        case .full:
            return "full"
        }
    }
    
    static func getOrientationFromString(_ s: String) -> ScreenOrientationEnum {
        switch s {
        case self.portrait.name:
            return .portrait
        case self.landscape.name:
            return .landscape
        case self.full.name:
            return .full
        default:
            return .full
        }
    }
}
