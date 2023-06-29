//
//  File.swift
//  
//
//  Created by admin on 20.06.2023.
//

import Foundation

struct MBIpCheckerNavigation {
    static let fileName = "main_graph.xml"
    
    static func fileText(packageName: String) -> String {
        return """
<?xml version="1.0" encoding="utf-8"?>
<navigation xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/main_graph"
    app:startDestination="@id/mainFragment">

    <fragment
        android:id="@+id/historyFragment"
        android:name="\(packageName).presentation.fragments.main_fragment.HistoryFragment"
        android:label="fragment_history"
        tools:layout="@layout/fragment_history" />
    <fragment
        android:id="@+id/mainFragment"
        android:name="\(packageName).presentation.fragments.main_fragment.IpCheckerMainFragment"
        android:label="fragment_main"
        tools:layout="@layout/fragment_main" />
</navigation>
"""
    }
}
