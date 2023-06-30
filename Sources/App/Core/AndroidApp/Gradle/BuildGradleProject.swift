//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct BuildGradleProject {
    static let fileName = "build.gradle"
    static func fileContent() -> String {
        return """
import dependencies.Versions
import dependencies.Build

buildscript {
    ext {
        compose_version = Versions.compose
        kotlin_version = Versions.kotlin
    }

    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
    dependencies {
        classpath Build.build_tools
        classpath Build.kotlin_gradle_plugin
        classpath Build.hilt_plugin
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
"""
    }
}
