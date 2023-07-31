//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct ResDefault {
    static func colorsText(mainData: MainData) -> String {
        return """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="purple_200">#FFBB86FC</color>
    <color name="purple_500">#FF6200EE</color>
    <color name="purple_700">#FF3700B3</color>
    <color name="teal_200">#FF03DAC5</color>
    <color name="teal_700">#FF018786</color>
    <color name="black">#FF000000</color>
    <color name="white">#FFFFFFFF</color>
\(AndroidNecesseryDependencies.dependencies(mainData).colorsData.additional)
</resources>
"""
    }
    
    static func stringsText(name: String, mainData: MainData) -> String {
        return """
<resources>
    <string name="app_name">\(name)</string>
\(AndroidNecesseryDependencies.dependencies(mainData).stringsData.additional)
</resources>
"""
    }
    
//    static func advancedString
    
    static func themesText(name: String, color: String, mainData: MainData) -> String {
        if AndroidNecesseryDependencies.dependencies(mainData).themesData.isDefault {
            return """
    <?xml version="1.0" encoding="utf-8"?>
    <resources>

        <style name="Theme.\(name.replace(" ", with: ""))" parent="Theme.MaterialComponents.DayNight.DarkActionBar">
            <item name="android:statusBarColor">#\(color)</item>
            <item name="windowActionBar">false</item>
            <item name="windowNoTitle">true</item>
        </style>
    </resources>
    """
        } else {
            return AndroidNecesseryDependencies.dependencies(mainData).themesData.content
        }
    }
}
