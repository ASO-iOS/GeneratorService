//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppFragmentState {
    static func fileText(packageName: String) -> String {
        return """
package \(packageName).repository.state

sealed class FragmentState {
    object MainState : FragmentState()
}
"""
    }
}
