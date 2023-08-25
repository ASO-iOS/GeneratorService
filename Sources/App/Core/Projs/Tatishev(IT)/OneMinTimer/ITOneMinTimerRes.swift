//
//  File.swift
//  
//
//  Created by admin on 8/25/23.
//

import Foundation

struct ITOneMinTimerRes {
    static let icon = XMLLayoutData(content: """
<vector android:height="24dp" android:tint="#FF0000"
    android:viewportHeight="24" android:viewportWidth="24"
    android:width="24dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <group
        android:pivotX="12"
        android:pivotY="12"
        android:scaleX="0.5"
        android:scaleY="0.5">
    <path android:fillAlpha="0.3"
        android:fillColor="@android:color/white"
        android:pathData="M12,6c-3.87,0 -7,3.13 -7,7s3.13,7 7,7s7,-3.13 7,-7S15.87,6 12,6zM13,14h-2V8h2V14z" android:strokeAlpha="0.3"/>
    <path android:fillColor="@android:color/white" android:pathData="M9,1h6v2h-6z"/>
    <path android:fillColor="@android:color/white" android:pathData="M19.03,7.39l1.42,-1.42c-0.43,-0.51 -0.9,-0.99 -1.41,-1.41l-1.42,1.42C16.07,4.74 14.12,4 12,4c-4.97,0 -9,4.03 -9,9c0,4.97 4.02,9 9,9s9,-4.03 9,-9C21,10.88 20.26,8.93 19.03,7.39zM12,20c-3.87,0 -7,-3.13 -7,-7s3.13,-7 7,-7s7,3.13 7,7S15.87,20 12,20z"/>
    <path android:fillColor="@android:color/white" android:pathData="M11,8h2v6h-2z"/>
    </group>
</vector>

""", name: "icon_timer.xml")
}
