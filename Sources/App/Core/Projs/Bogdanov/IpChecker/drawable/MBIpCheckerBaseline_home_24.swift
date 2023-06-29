import Foundation

struct MBIpCheckerBaseline_home_24 {
    static let fileName = "baseline_home_24.xml"
    static func fileText(textColor: String) -> String {
        return """
            <vector android:height="24dp" android:tint="#\(textColor)"
        android:viewportHeight="24" android:viewportWidth="24"
        android:width="24dp" xmlns:android="http://schemas.android.com/apk/res/android">
        <path android:fillColor="@android:color/white" android:pathData="M10,20v-6h4v6h5v-8h3L12,3 2,12h3v8z"/>
        </vector>
        
        """
    }
}
