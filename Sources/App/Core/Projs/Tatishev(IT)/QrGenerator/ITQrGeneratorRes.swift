//
//  File.swift
//  
//
//  Created by admin on 8/25/23.
//

import Foundation

struct ITQrGeneratorRes {
    static let icon = XMLLayoutData(content: """
<vector android:height="24dp" android:tint="#000000"
    android:viewportHeight="24" android:viewportWidth="24"
    android:width="24dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <group
        android:pivotX="12"
        android:pivotY="12"
        android:scaleX="0.5"
        android:scaleY="0.5">
    <path android:fillColor="@android:color/white" android:pathData="M3,11h8V3H3V11zM5,5h4v4H5V5z"/>
    <path android:fillColor="@android:color/white" android:pathData="M3,21h8v-8H3V21zM5,15h4v4H5V15z"/>
    <path android:fillColor="@android:color/white" android:pathData="M13,3v8h8V3H13zM19,9h-4V5h4V9z"/>
    <path android:fillColor="@android:color/white" android:pathData="M19,19h2v2h-2z"/>
    <path android:fillColor="@android:color/white" android:pathData="M13,13h2v2h-2z"/>
    <path android:fillColor="@android:color/white" android:pathData="M15,15h2v2h-2z"/>
    <path android:fillColor="@android:color/white" android:pathData="M13,17h2v2h-2z"/>
    <path android:fillColor="@android:color/white" android:pathData="M15,19h2v2h-2z"/>
    <path android:fillColor="@android:color/white" android:pathData="M17,17h2v2h-2z"/>
    <path android:fillColor="@android:color/white" android:pathData="M17,13h2v2h-2z"/>
    <path android:fillColor="@android:color/white" android:pathData="M19,15h2v2h-2z"/>
    </group>
</vector>

""", name: "icon_qr.xml")
}
