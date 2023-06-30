//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppApplication {
    static func fileContent(packageName: String, applicationName: String) -> String {
        return """
package \(packageName).application

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class \(applicationName) : Application()
"""
    }
}
