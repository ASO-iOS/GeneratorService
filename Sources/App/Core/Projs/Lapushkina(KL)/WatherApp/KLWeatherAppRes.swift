//
//  File.swift
//  
//
//  Created by admin on 8/17/23.
//

import Foundation

struct KLWeatherAppRes {
    static let name = "weather_border.xml"
    static let content = """
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <solid android:color="@color/backColorPrimary"/>
    <stroke android:width="@dimen/border_stroke" android:color="@color/surfaceColor" />
    <corners android:radius="@dimen/card_corner_radius"/>
</shape>
"""
}
