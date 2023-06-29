import Foundation

struct MBIpCheckerMy_gradient {
    static let fileName = "my_gradient.xml"
    static func fileText(startColor: String, endColor: String) -> String {
        return """
            <?xml version="1.0" encoding="utf-8"?>
        <shape xmlns:android="http://schemas.android.com/apk/res/android">
        <gradient
        android:type="linear"
        android:angle="270"
        android:startColor="#\(startColor)"
        android:endColor="#\(endColor)" />
        </shape>
        """
    }
}
