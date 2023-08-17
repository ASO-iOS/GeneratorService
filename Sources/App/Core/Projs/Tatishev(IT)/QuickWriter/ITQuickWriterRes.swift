//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import SwiftUI

struct ITQuickWriterRes {
    static let noteIconName = "icon_note.xml"
    static func noteIconContent(buttonTextColor: String) -> String {
        return """
<vector android:height="24dp"
    android:viewportHeight="24" android:viewportWidth="24"
    android:width="24dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <group
        android:pivotX="12"
        android:pivotY="12"
        android:scaleX="0.5"
        android:scaleY="0.5">
    <path android:fillColor="#\(buttonTextColor)" android:pathData="M19,3H4.99C3.89,3 3,3.9 3,5l0.01,14c0,1.1 0.89,2 1.99,2h10l6,-6V5C21,3.9 20.1,3 19,3zM7,8h10v2H7V8zM12,14H7v-2h5V14zM14,19.5V14h5.5L14,19.5z"/>
    </group>
</vector>
"""
    }
}