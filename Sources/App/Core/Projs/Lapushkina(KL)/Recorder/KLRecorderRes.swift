//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct KLRecorderRes {
    static func res() -> [XMLLayoutData] {
        let delete = XMLLayoutData(content: """
    <vector android:height="32dp"
        android:viewportHeight="24" android:viewportWidth="24"
        android:width="32dp" xmlns:android="http://schemas.android.com/apk/res/android">
        <path android:fillColor="@color/enabled_button_color" android:pathData="M18.3,5.71c-0.39,-0.39 -1.02,-0.39 -1.41,0L12,10.59 7.11,5.7c-0.39,-0.39 -1.02,-0.39 -1.41,0 -0.39,0.39 -0.39,1.02 0,1.41L10.59,12 5.7,16.89c-0.39,0.39 -0.39,1.02 0,1.41 0.39,0.39 1.02,0.39 1.41,0L12,13.41l4.89,4.89c0.39,0.39 1.02,0.39 1.41,0 0.39,-0.39 0.39,-1.02 0,-1.41L13.41,12l4.89,-4.89c0.38,-0.38 0.38,-1.02 0,-1.4z"/>
    </vector>
    """, name: "ic_delete.xml")
        let deleteDisabled = XMLLayoutData(content: """
    <vector android:height="32dp"
        android:viewportHeight="24" android:viewportWidth="24"
        android:width="32dp" xmlns:android="http://schemas.android.com/apk/res/android">
        <path android:fillColor="@color/disabled_button_color" android:pathData="M18.3,5.71c-0.39,-0.39 -1.02,-0.39 -1.41,0L12,10.59 7.11,5.7c-0.39,-0.39 -1.02,-0.39 -1.41,0 -0.39,0.39 -0.39,1.02 0,1.41L10.59,12 5.7,16.89c-0.39,0.39 -0.39,1.02 0,1.41 0.39,0.39 1.02,0.39 1.41,0L12,13.41l4.89,4.89c0.39,0.39 1.02,0.39 1.41,0 0.39,-0.39 0.39,-1.02 0,-1.41L13.41,12l4.89,-4.89c0.38,-0.38 0.38,-1.02 0,-1.4z"/>
    </vector>
    """, name: "ic_delete_disabled.xml")
        let record = XMLLayoutData(content: """
    <?xml version="1.0" encoding="utf-8"?>
    <ripple xmlns:android="http://schemas.android.com/apk/res/android"
        android:color="?rippleColor">
        <item>
            <shape android:shape="oval">
                <solid android:color="@color/buttonColorPrimary"/>
            </shape>
        </item>
    </ripple>
    """, name: "ic_record.xml")
        let recordList = XMLLayoutData(content: """
    <vector android:height="32dp"
        android:viewportHeight="24" android:viewportWidth="24"
        android:width="32dp" xmlns:android="http://schemas.android.com/apk/res/android">
        <path android:fillColor="@color/enabled_button_color" android:pathData="M4,18h16c0.55,0 1,-0.45 1,-1s-0.45,-1 -1,-1L4,16c-0.55,0 -1,0.45 -1,1s0.45,1 1,1zM4,13h16c0.55,0 1,-0.45 1,-1s-0.45,-1 -1,-1L4,11c-0.55,0 -1,0.45 -1,1s0.45,1 1,1zM3,7c0,0.55 0.45,1 1,1h16c0.55,0 1,-0.45 1,-1s-0.45,-1 -1,-1L4,6c-0.55,0 -1,0.45 -1,1z"/>
    </vector>

    """, name: "ic_record_list.xml")
        let ripple = XMLLayoutData(content: """
    <?xml version="1.0" encoding="utf-8"?>
    <ripple xmlns:android="http://schemas.android.com/apk/res/android"
        android:color="?rippleColor">
        <item>
            <shape android:shape="oval">
                <solid android:color="@color/buttonColorSecondary"/>
            </shape>
        </item>
    </ripple>
    """, name: "ic_ripple.xml")
        let rippleItem = XMLLayoutData(content: """
    <?xml version="1.0" encoding="utf-8"?>
    <ripple xmlns:android="http://schemas.android.com/apk/res/android"
        android:color="?rippleColor">
        <item>
            <shape android:shape="rectangle">
                <solid android:color="@color/surfaceColor"/>
            </shape>
        </item>
    </ripple>
    """, name: "ic_ripple_item.xml")
        let stop = XMLLayoutData(content: """
    <vector android:height="32dp" android:tint="#FFFFFF"
        android:viewportHeight="24" android:viewportWidth="24"
        android:width="32dp" xmlns:android="http://schemas.android.com/apk/res/android">
        <path android:fillColor="@android:color/white" android:pathData="M8,6h8c1.1,0 2,0.9 2,2v8c0,1.1 -0.9,2 -2,2H8c-1.1,0 -2,-0.9 -2,-2V8c0,-1.1 0.9,-2 2,-2z"/>
    </vector>

    """, name: "ic_stop.xml")
        return [delete, deleteDisabled, record, recordList, ripple, rippleItem, stop]
    }
}
