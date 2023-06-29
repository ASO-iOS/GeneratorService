//
//  File.swift
//  
//
//  Created by admin on 01.06.2023.
//

import Foundation
import ZIPFoundation

class UnzipHandler {
    class func unzip(
        filePath: URL,
        destinationPath: URL,
        completion: @escaping (ZipHandlerState, Error?) -> Void
    ) {
        let fileManager = FileManager()
        do {
            try fileManager.unzipItem(at: filePath, to: destinationPath)
            completion(ZipHandlerState.success, nil)
        } catch {
            completion(ZipHandlerState.failure, error)
        }
    }
    
    class func zip(
        filePath: URL,
        destinationPath: URL,
        completion: @escaping (ZipHandlerState, Error?) -> Void
    ) {
        let fileManager = FileManager()
        do {
            try fileManager.zipItem(at: filePath, to: destinationPath)
            completion(ZipHandlerState.success, nil)
        } catch {
            completion(ZipHandlerState.failure, error)
        }
    }
}

enum ZipHandlerState: String {
    case success, failure
    
    var value: String {
        switch self {
        case .failure:
            return "ZipHandler Failure"
        case .success:
            return "ZipHandler Success"
        }
    }
}
