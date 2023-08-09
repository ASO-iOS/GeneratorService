//
//  File.swift
//  
//
//  Created by admin on 09.08.2023.
//

import Foundation

protocol MetaProviderProtocol {
    static var appName: String { get set }
    static func getFullDesc(appName: String) -> String
    static func getShortDesc(appName: String) -> String
}
