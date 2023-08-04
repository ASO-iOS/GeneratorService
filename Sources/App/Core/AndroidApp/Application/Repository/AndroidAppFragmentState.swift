//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppFragmentState {
    static func fileContent(mainData: MainData) -> String {
        return """
package \(mainData.packageName).repository.state

sealed class FragmentState {
    object MainState : FragmentState()
    \(AndroidNecesseryDependencies.dependencies(mainData).fragmentStateData ?? "")
}
"""
    }
}
