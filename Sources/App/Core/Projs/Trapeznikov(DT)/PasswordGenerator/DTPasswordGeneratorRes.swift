//
//  File.swift
//  
//
//  Created by admin on 9/11/23.
//

import Foundation

struct DTPasswordGeneratorRes {
    static let icon = XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="layout_padding">16dp</dimen>
    <dimen name="hint_size">14sp</dimen>
    <dimen name="widget_padding">8dp</dimen>
</resources>
""", name: "dimens.xml")
    
    static let lay = XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    android:paddingStart="@dimen/layout_padding"
    android:paddingEnd="@dimen/layout_padding">

    <TextView
        android:id="@+id/passwordText"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:enabled="false"
        android:gravity="center"
        android:hint="@string/select_options_and_click_generate"
        android:padding="@dimen/widget_padding"
        android:textColor="@color/textColorPrimary"
        android:textColorHint="@color/textColorPrimary"
        app:layout_constraintBottom_toTopOf="@+id/lengthSlider"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <TextView
        android:id="@+id/passwordCopyHint"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:hint="@string/click_on_password_to_copy"
        android:textColor="@color/textColorPrimary"
        android:textSize="@dimen/hint_size"
        android:visibility="gone"
        app:layout_constraintEnd_toEndOf="@id/passwordText"
        app:layout_constraintStart_toStartOf="@id/passwordText"
        app:layout_constraintTop_toBottomOf="@id/passwordText"
        tools:visibility="visible" />

    <TextView
        android:id="@+id/passwordLength"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:paddingStart="@dimen/widget_padding"
        android:paddingEnd="@dimen/widget_padding"
        android:text="@string/default_length"
        android:textColor="@color/textColorPrimary"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/lengthSlider"/>

    <com.google.android.material.slider.Slider
        android:id="@+id/lengthSlider"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:contentDescription="@string/password_length_slider"
        android:labelFor="@id/lengthSlider"
        android:stepSize="1"
        android:valueFrom="4"
        android:valueTo="20"
        app:thumbColor="@color/purple_700"
        app:thumbStrokeColor="@color/purple_700"
        app:tickColor="@color/purple_200"
        app:layout_constraintBottom_toTopOf="@+id/lowercaseSwitch"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/passwordText"/>

    <com.google.android.material.switchmaterial.SwitchMaterial
        android:id="@+id/lowercaseSwitch"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:padding="@dimen/widget_padding"
        android:text="@string/lowercase_letter"
        android:textColor="@color/textColorPrimary"
        app:layout_constraintBottom_toTopOf="@+id/uppercaseSwitch"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/lengthSlider" />

    <com.google.android.material.switchmaterial.SwitchMaterial
        android:id="@+id/uppercaseSwitch"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:labelFor="@id/passwordLength"
        android:padding="@dimen/widget_padding"
        android:text="@string/uppercase_letter"
        android:textColor="@color/textColorPrimary"
        app:layout_constraintBottom_toTopOf="@+id/numbersSwitch"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/lowercaseSwitch" />

    <com.google.android.material.switchmaterial.SwitchMaterial
        android:id="@+id/numbersSwitch"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:padding="@dimen/widget_padding"
        android:text="@string/numbers"
        android:textColor="@color/textColorPrimary"
        app:layout_constraintBottom_toTopOf="@+id/symbolsSwitch"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/uppercaseSwitch" />

    <com.google.android.material.switchmaterial.SwitchMaterial
        android:id="@+id/symbolsSwitch"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:padding="@dimen/widget_padding"
        android:text="@string/symbols"
        android:textColor="@color/textColorPrimary"
        app:layout_constraintBottom_toTopOf="@+id/generateButton"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/numbersSwitch" />

    <com.google.android.material.button.MaterialButton
        android:id="@+id/generateButton"
        app:cornerRadius="16dp"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:backgroundTint="@color/buttonColorPrimary"
        android:textAllCaps="false"
        android:text="@string/generate"
        android:textColor="@color/buttonTextColorPrimary"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/symbolsSwitch" />
</androidx.constraintlayout.widget.ConstraintLayout>
""", name: "fragment_password.xml")
}
