//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct KLMoodTrackerRes {
   static let happyFace = XMLLayoutData(content: """
<vector android:height="64dp" android:viewportHeight="24"
    android:viewportWidth="24" android:width="64dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <path android:fillColor="#FF000000" android:pathData="M12,2c5.514,0 10,4.486 10,10s-4.486,10 -10,10 -10,-4.486 -10,-10 4.486,-10 10,-10zM12,0c-6.627,0 -12,5.373 -12,12s5.373,12 12,12 12,-5.373 12,-12 -5.373,-12 -12,-12zM18,14h-12c0.331,1.465 2.827,4 6.001,4 3.134,0 5.666,-2.521 5.999,-4zM18,10.002l-0.755,0.506s-0.503,-0.948 -1.746,-0.948c-1.207,0 -1.745,0.948 -1.745,0.948l-0.754,-0.506c0.281,-0.748 1.205,-2.002 2.499,-2.002 1.295,0 2.218,1.254 2.501,2.002zM11,10.002l-0.755,0.506s-0.503,-0.948 -1.746,-0.948c-1.207,0 -1.745,0.948 -1.745,0.948l-0.754,-0.506c0.281,-0.748 1.205,-2.002 2.499,-2.002 1.295,0 2.218,1.254 2.501,2.002z"/>
</vector>

""", name: "happy_face.xml")
    
    static let neutalFace = XMLLayoutData(content: """
<vector android:height="64dp" android:viewportHeight="24"
    android:viewportWidth="24" android:width="64dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <path android:fillColor="#FF000000" android:pathData="M12,2c5.514,0 10,4.486 10,10s-4.486,10 -10,10 -10,-4.486 -10,-10 4.486,-10 10,-10zM12,0c-6.627,0 -12,5.373 -12,12s5.373,12 12,12 12,-5.373 12,-12 -5.373,-12 -12,-12zM16,17h-8v-2h8v2zM8.5,8c-0.828,0 -1.5,0.671 -1.5,1.5s0.672,1.5 1.5,1.5 1.5,-0.671 1.5,-1.5 -0.672,-1.5 -1.5,-1.5zM15.5,8c-0.828,0 -1.5,0.671 -1.5,1.5s0.672,1.5 1.5,1.5 1.5,-0.671 1.5,-1.5 -0.672,-1.5 -1.5,-1.5z"/>
</vector>

""", name: "neutral_face.xml")
    
    static let sadFace = XMLLayoutData(content: """
<vector android:height="64dp" android:viewportHeight="24"
    android:viewportWidth="24" android:width="64dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <path android:fillColor="#FF000000" android:pathData="M12,2c5.514,0 10,4.486 10,10s-4.486,10 -10,10 -10,-4.486 -10,-10 4.486,-10 10,-10zM12,0c-6.627,0 -12,5.373 -12,12s5.373,12 12,12 12,-5.373 12,-12 -5.373,-12 -12,-12zM12.001,14c-2.332,0 -4.145,1.636 -5.093,2.797l0.471,0.58c1.286,-0.819 2.732,-1.308 4.622,-1.308s3.336,0.489 4.622,1.308l0.471,-0.58c-0.948,-1.161 -2.761,-2.797 -5.093,-2.797zM8.5,8c-0.828,0 -1.5,0.671 -1.5,1.5s0.672,1.5 1.5,1.5 1.5,-0.671 1.5,-1.5 -0.672,-1.5 -1.5,-1.5zM15.5,8c-0.828,0 -1.5,0.671 -1.5,1.5s0.672,1.5 1.5,1.5 1.5,-0.671 1.5,-1.5 -0.672,-1.5 -1.5,-1.5z"/>
</vector>

""", name: "sad_face.xml")
    
    static let smileFace = XMLLayoutData(content: """
<vector android:height="64dp" android:viewportHeight="24"
    android:viewportWidth="24" android:width="64dp" xmlns:android="http://schemas.android.com/apk/res/android">
    <path android:fillColor="#FF000000" android:pathData="M12,2c5.514,0 10,4.486 10,10s-4.486,10 -10,10 -10,-4.486 -10,-10 4.486,-10 10,-10zM12,0c-6.627,0 -12,5.373 -12,12s5.373,12 12,12 12,-5.373 12,-12 -5.373,-12 -12,-12zM17.508,13.941c-1.513,1.195 -3.174,1.931 -5.507,1.931 -2.335,0 -3.996,-0.736 -5.509,-1.931l-0.492,0.493c1.127,1.72 3.2,3.566 6.001,3.566 2.8,0 4.872,-1.846 5.999,-3.566l-0.492,-0.493zM18,10.002l-0.755,0.506s-0.503,-0.948 -1.746,-0.948c-1.207,0 -1.745,0.948 -1.745,0.948l-0.754,-0.506c0.281,-0.748 1.205,-2.002 2.499,-2.002 1.295,0 2.218,1.254 2.501,2.002zM11,10.002l-0.755,0.506s-0.503,-0.948 -1.746,-0.948c-1.207,0 -1.745,0.948 -1.745,0.948l-0.754,-0.506c0.281,-0.748 1.205,-2.002 2.499,-2.002 1.295,0 2.218,1.254 2.501,2.002z"/>
</vector>

""", name: "smile_face.xml")
}
