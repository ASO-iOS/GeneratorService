//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

class GradleSettings {
    static func gradleSettings(appName: String) -> String {
        return """
pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "\(appName)"
include(":app")
"""
    }
}
