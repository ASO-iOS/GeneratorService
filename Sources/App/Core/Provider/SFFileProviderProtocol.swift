//
//  File.swift
//  
//
//  Created by admin on 8/31/23.
//

import Foundation

protocol SFFileProviderProtocol: FileProviderProtocol {
    
    static func mainFragmentCMF(_ mainData: MainData) -> ANDMainFragmentCMF
    
    static func dependencies(_ mainData: MainData) -> ANDData

    static func gradle(_ packageName: String) -> GradleFilesData
}
