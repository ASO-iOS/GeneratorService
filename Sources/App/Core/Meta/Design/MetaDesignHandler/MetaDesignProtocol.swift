//
//  File.swift
//  
//
//  Created by admin on 10.07.2023.
//

import Foundation

protocol MetaDesignProtocol {
    var backColorPrimary: String? { get set }
    var backColorSecondary: String? { get set }
    var surfaceColor: String? { get set }
    var onSurfaceColor: String? { get set }
    var primaryColor: String? { get set }
    var onPrimaryColor: String? { get set }
    var errorColor: String? { get set }
    var textColorPrimary: String? { get set }
    var textColorSecondary: String? { get set }
    var buttonColorPrimary: String? { get set }
    var buttonColorSecondary: String? { get set }
    var buttonTextColorPrimary: String? { get set }
    var buttonTextColorSecondary: String? { get set }
    var paddingPrimary: Int? { get set }
    var paddingSecondary: Int? { get set }
    var textSizePrimary: Int? { get set }
    var textSizeSecondary: Int? { get set }
    var iconLocation: String { get set }
    var bannerLocation: String { get set }
    var screen1Location: String { get set }
    var screen2Location: String { get set }
    var screen3Location: String { get set }
}

