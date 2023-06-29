//
//  File.swift
//  
//
//  Created by admin on 20.06.2023.
//

import Foundation

struct MBIpCheckerLayout {
    
    static let mainFName = "fragment_main.xml"
    
    static func mainFText(textColor: String, buttonTextColor: String, buttonColor: String) -> String {
        return """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/my_gradient"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    tools:context=".presentation.fragments.main_fragment.IpCheckerMainFragment">

    <androidx.core.widget.ContentLoadingProgressBar
        android:id="@+id/loading_progress_bar"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:visibility="gone"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        style="?android:attr/progressBarStyleLarge" />

    <LinearLayout
        android:id="@+id/ll_geo_data"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:gravity="center"
        android:orientation="vertical"
        android:layout_marginBottom="20dp"
        android:padding="3dp"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintBottom_toTopOf="@+id/text_input_layout_id">

        <TextView
            android:id="@+id/tv_country"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_margin="5dp"
            android:layout_marginStart="20dp"
            android:textSize="18sp"
            android:textColor="#\(textColor)"
            android:padding="3dp"/>

        <TextView
            android:id="@+id/tv_city"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_margin="5dp"
            android:layout_marginStart="20dp"
            android:textSize="18sp"
            android:textColor="#\(textColor)"
            android:padding="3dp"/>

        <TextView
            android:id="@+id/tv_timezone"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_margin="5dp"
            android:layout_marginStart="20dp"
            android:textSize="18sp"
            android:textColor="#\(textColor)"
            android:padding="3dp"/>

        <TextView
            android:id="@+id/tv_query"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_margin="8dp"
            android:layout_marginStart="20dp"
            android:textSize="18sp"
            android:textColor="#\(textColor)"
            android:padding="3dp"/>

    </LinearLayout>

    <TextView
        android:id="@+id/tv_error_message"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:layout_gravity="center|top"
        android:visibility="gone"
        android:gravity="center"
        android:textColor="#\(textColor)"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintBottom_toTopOf="@+id/text_input_layout_id"/>

    <androidx.constraintlayout.widget.Barrier
        android:id="@+id/barrier"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        app:barrierDirection="bottom"
        app:constraint_referenced_ids="ll_geo_data, tv_error_message"/>

    <com.google.android.material.textfield.TextInputLayout
        android:id="@+id/text_input_layout_id"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center"
        android:layout_marginTop="10dp"
        android:minWidth="150dp"
        android:layout_marginBottom="20dp"
        android:hint="@string/enter_ip"
        android:padding="3dp"
        app:startIconDrawable="@drawable/baseline_auto_awesome_24"
        style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox"
        app:layout_constraintBottom_toTopOf="@id/b_get_data"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/barrier">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/et_ip"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:inputType="phone" />

    </com.google.android.material.textfield.TextInputLayout>

    <Button
        android:id="@+id/b_get_data"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/launch"
        android:padding="3dp"
        android:backgroundTint="#\(buttonColor)"
        android:textColor="#\(buttonTextColor)"
        android:layout_gravity="bottom|center"
        android:layout_marginBottom="40dp"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/text_input_layout_id"/>



</androidx.constraintlayout.widget.ConstraintLayout>
"""
    }
    
    static let mainAName = "activity_main.xml"
    
    static func mainAFile() -> String {
        return """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".presentation.main_activity.MainActivity">

    <fragment
        android:id="@+id/nav_host_fragment"
        android:name="androidx.navigation.fragment.NavHostFragment"
        android:layout_width="0dp"
        android:layout_height="0dp"
        app:defaultNavHost="true"
        app:navGraph="@navigation/main_graph"
        app:layout_constraintBottom_toTopOf="@+id/bottom_navigation"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintTop_toTopOf="parent"/>

    <com.google.android.material.bottomnavigation.BottomNavigationView
        android:id="@+id/bottom_navigation"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginBottom="3dp"
        android:layout_marginEnd="5dp"
        android:layout_marginStart="5dp"
        app:menu="@menu/bottom_navigation_menu"
        app:layout_constraintTop_toBottomOf="@+id/nav_host_fragment"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
"""
    }
    
    static let histFName = "fragment_history.xml"
    
    static func histFFile() -> String {
        return """
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/my_gradient"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    tools:context=".presentation.fragments.main_fragment.HistoryFragment">

    <androidx.recyclerview.widget.RecyclerView
        android:id="@+id/rv_history_data"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        tools:listitem="@layout/rv_history_data_item"
        android:layout_marginBottom="3dp"
        app:layoutManager="androidx.recyclerview.widget.LinearLayoutManager"
        android:padding="3dp" />

</FrameLayout>
"""
    }
    
    
    static let rvDataHistListName = "rv_history_data_item.xml"
    
    static func rvDataHistListFile(textColor: String) -> String {
        return """
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:gravity="center"
    android:orientation="vertical">

    <TextView
        android:id="@+id/tv_country_history"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:padding="3dp"
        android:textColor="#\(textColor)"
        android:layout_margin="5dp" />

    <TextView
        android:id="@+id/tv_city_history"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:padding="3dp"
        android:textColor="#\(textColor)"
        android:layout_margin="5dp" />

    <TextView
        android:id="@+id/tv_timezone_history"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:padding="3dp"
        android:textColor="#\(textColor)"
        android:layout_margin="5dp" />

    <TextView
        android:id="@+id/tv_query_history"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:padding="3dp"
        android:textColor="#\(textColor)"
        android:layout_margin="5dp" />

    <com.google.android.material.divider.MaterialDivider
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        app:dividerInsetEnd="16dp"
        app:dividerColor="#\(textColor)"
        app:dividerInsetStart="16dp" />

</LinearLayout>
"""
    }
}
