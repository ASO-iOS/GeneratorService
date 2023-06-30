//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

class GradleWrapperProperties {
    static let fileName = "gradle-wrapper.properties"
    static func fileContent(gradleWrapper: String) -> String {
        return """
distributionBase=GRADLE_USER_HOME
distributionUrl=https\\://services.gradle.org/distributions/gradle-\(gradleWrapper)-bin.zip
distributionPath=wrapper/dists
zipStorePath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
"""
    }
}
