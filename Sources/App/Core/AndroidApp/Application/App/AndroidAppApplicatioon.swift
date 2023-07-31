//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppApplication {
    static func fileContent(packageName: String, applicationName: String, useContext: Bool = false) -> String {
        return """
package \(packageName).application

import android.app.Application
import dagger.hilt.android.HiltAndroidApp
\(useContext ? "import android.content.Context" : "")

@HiltAndroidApp
class \(applicationName) : Application()
\(useContext ? """
 {
    override fun onCreate() {
        super.onCreate()
        context = this
    }

    companion object {
        var context: Context? = null
            private set
    }
}
""" : "")
"""
    }
}
