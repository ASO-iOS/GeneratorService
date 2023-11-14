//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct Manifest {
    static let fileName = "AndroidManifest.xml"
    static func fileContent(
        appId: String,
        applicationName: String,
        name: String,
        screenOrientation: ScreenOrientationEnum
    ) -> String {
        return """
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET"/>
    \(permsById(appId))

    <application
        android:name=".application.\(applicationName)"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:hardwareAccelerated="true"
        android:largeHeap="true"
        android:theme="@style/Theme.\(name.replace(" ", with: ""))"
        android:usesCleartextTraffic="true">
            
            \(appendService(appId))
        <activity
            android:name=".presentation.main_activity.MainActivity"
            android:exported="true"
            android:theme="@style/Theme.\(name.replace(" ", with: ""))"
            \(screenOrientation == .full ? "android:configChanges=\"orientation|screenSize|keyboardHidden\"" : "")
            \(screenOrientation == .full ? "android:windowSoftInputMode=\"adjustResize\"" : "")
            \(screenOrientation == .portrait ? "android:screenOrientation=\"portrait\"" : "")
            \(screenOrientation == .landscape ? "android:screenOrientation=\"landscape\"" : "")
            >
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
"""
    }
    
    static func permsById(_ id: String) -> String {
        switch id {
        case AppIDs.MB_ALARM, AppIDs.VE_ALARM_MATERIAL, AppIDs.VE_CHARGE_ME:
            return """
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
"""
        case AppIDs.IT_STOPWATCH:
            return """
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
"""
        case AppIDs.KL_WEATHER_APP:
            return """
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
"""
        case AppIDs.VE_SOUND_RECORDER:
            return """
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
"""
        case AppIDs.AK_ALARM:
            return """
    <uses-permission android:name="com.android.alarm.permission.SET_ALARM" />
"""
        case AppIDs.KL_SPEED_TEST:
            return """
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
"""
        case AppIDs.KL_RECORDER:
            return """
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
"""
        case AppIDs.IT_WIFI_RATE:
            return """
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
"""
        case AppIDs.KD_PEDOMETER:
            return """
    <uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
    <uses-permission android:name="com.google.android.gms.permission.ACTIVITY_RECOGNITION"/>
"""
        default:
            return ""
        }
    }
    
    static func appendService(_ id: String) -> String {
        switch id {
        case AppIDs.IT_STOPWATCH:
            return """
        <service
            android:name=".presentation.fragments.main_fragment.StopWatchService"
            android:enabled="true"
            android:exported="false"/>
"""
        case AppIDs.EG_STOPWATCH:
            return """
        <service
            android:name=".presentation.fragments.main_fragment.TimerService"
            android:enabled="true"
            android:exported="false"/>
"""
        default:
            return ""
        }
    }
}
