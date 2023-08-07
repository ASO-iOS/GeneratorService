//
//  File.swift
//  
//
//  Created by admin on 04.08.2023.
//

import Foundation

struct EGLuckyNumberRes {
    static let questName = "ic_question.xml"
    static let questContent = { (buttonColorPrimary: String) -> String in
        return """
<vector android:height="24dp" android:tint="#\(buttonColorPrimary)"
    android:viewportHeight="24" android:viewportWidth="24"
    android:width="24dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <path android:fillColor="#DEFBE7" android:pathData="M11.07,12.85c0.77,-1.39 2.25,-2.21 3.11,-3.44c0.91,-1.29 0.4,-3.7 -2.18,-3.7c-1.69,0 -2.52,1.28 -2.87,2.34L6.54,6.96C7.25,4.83 9.18,3 11.99,3c2.35,0 3.96,1.07 4.78,2.41c0.7,1.15 1.11,3.3 0.03,4.9c-1.2,1.77 -2.35,2.31 -2.97,3.45c-0.25,0.46 -0.35,0.76 -0.35,2.24h-2.89C10.58,15.22 10.46,13.95 11.07,12.85zM14,20c0,1.1 -0.9,2 -2,2s-2,-0.9 -2,-2c0,-1.1 0.9,-2 2,-2S14,18.9 14,20z"/>
</vector>

"""
    }
    static let borderName = "border_icon.xml"
    static let borderContent = """
<?xml version="1.0" encoding="utf-8"?>
<layer-list>
    <item>
        <shape xmlns:android="http://schemas.android.com/apk/res/android"
            android:shape="oval">
            <solid android:color="@color/backColorSecondary" />
            <padding android:left="10dp" android:top="10dp" android:right="10dp"
                android:bottom="10dp" />
        </shape>
    </item>
    <item>
        <shape xmlns:android="http://schemas.android.com/apk/res/android"
            android:shape="oval">
            <solid android:color="@color/backColorSecondary" />
            <stroke android:width="5dp" android:color="@color/backColorPrimary" />
            <padding android:left="10dp" android:top="10dp" android:right="10dp"
                android:bottom="10dp" />
        </shape>
    </item>
</layer-list>
"""
}
