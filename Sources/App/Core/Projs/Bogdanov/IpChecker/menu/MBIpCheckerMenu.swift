//
//  File.swift
//  
//
//  Created by admin on 20.06.2023.
//

import Foundation

struct MBIpCheckerMenu {
    static let fileName = "bottom_navigation_menu.xml"
    
    static func fileText() -> String {
        return """
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android">

    <item
        android:title="@string/main"
        android:id="@+id/itemID"
        android:icon="@drawable/baseline_home_24"
        android:enabled="true"/>

    <item
        android:title="@string/history"
        android:id="@+id/itemHistory"
        android:icon="@drawable/baseline_history_24"
        android:enabled="true"/>

</menu>
"""
    }
}
