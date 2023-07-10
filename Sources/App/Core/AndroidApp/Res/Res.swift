//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct ResDefault {
    static func colorsText() -> String {
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
</resources>
"""
    }
    
    static func stringsText(name: String, appId: String) -> String {
        var advanced = ""
        switch appId {
        case AppIDs.MB_CHECK_IP:
            advanced = """
            <string name="no_data">No data</string>
            <string name="country">Country: %1$s</string>
            <string name="city">City: %1$s</string>
            <string name="timezone">Timezone: %1$s</string>
            <string name="query">Query: %1$s</string>
            <string name="launch">Launch</string>
            <string name="enter_ip">Enter ip</string>
            <string name="main">Main</string>
            <string name="history">History</string>
        """
        case AppIDs.VS_PHONE_INFO_ID:
            advanced = """
            <string name="cancel">Cancel</string>

            <string name="theme_dialog_title">Theme</string>
            <string name="theme_dialog_light">Light</string>
            <string name="theme_dialog_dark">Dark</string>
            <string name="theme_dialog_default">System default</string>

            <string name="settings_theme_choice">Theme</string>
            <string name="init_text">Enter the number and click search</string>
            <string name="nothing_found">Sorry, we found nothing</string>
            <string name="invalid_number">The number is invalid</string>

            <string name="phone_info_country">Country</string>
            <string name="phone_info_region">Region</string>
            <string name="phone_info_timezone">Time zones</string>
            <string name="phone_info_topbar_title">\(name)</string>

            <string name="topbar_back">Back</string>
            <string name="topbar_settings">Settings</string>
            <string name="phone_picker_search">Search</string>
            <string name="settings_dark_mode">Dark Mode</string>
        """
        case AppIDs.MB_CATCHER:
            advanced = """
            <string name="score_counter">Score: %s</string>
            <string name="you_lost">Game Over</string>
            <string name="restart">Restart</string>
            <string name="attempts_remaining">"Attempts remaining: %d"</string>
            <string name="score">"Score: %d"</string>
            <string name="restart_description">Restart</string>
            <string name="loading">Loading…</string>
        """
        default:
            advanced = ""
        }
        return """
<resources>
    <string name="app_name">\(name)</string>
    \(advanced)
</resources>
"""
    }
    
//    static func advancedString
    
    static func themesText(name: String, color: String) -> String {
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
    }
}
