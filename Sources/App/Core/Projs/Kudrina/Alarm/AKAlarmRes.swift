//
//  File.swift
//  
//
//  Created by admin on 10.08.2023.
//

import Foundation

struct AKAlarmRes {
    static let name = "icon_delete.xml"
    static let content = { (textColorPrimary: String) -> String in
        return """
<vector android:height="60dp" android:tint="#\(textColorPrimary)"
    android:viewportHeight="24" android:viewportWidth="24"
    android:width="60dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <path android:fillColor="@android:color/white" android:pathData="M6,19c0,1.1 0.9,2 2,2h8c1.1,0 2,-0.9 2,-2V7H6v12zM19,4h-3.5l-1,-1h-5l-1,1H5v2h14V4z"/>
</vector>
"""
    }
}
