//
//  File.swift
//  
//
//  Created by admin on 02.08.2023.
//

import Foundation

protocol CMFFileProviderProtocol: FileProviderProtocol {


    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF
}
