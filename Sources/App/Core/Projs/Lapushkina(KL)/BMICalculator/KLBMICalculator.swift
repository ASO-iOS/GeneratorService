//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct KLBMICalculator: XMLFileProviderProtocol {
    static var fileName: String = "KLBMICalculator.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.lifecycle.ViewModel
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import java.util.regex.Pattern
import javax.inject.Inject

@HiltViewModel
class BmiViewModel @Inject constructor() : ViewModel() {

    fun getBmiResult(weight: String, height: String, isMetric: Boolean): Float {
        val weightFloat = weight.toFloat()
        val heightFloat = height.toFloat()
        val result = if(isMetric) {
            weightFloat / (heightFloat * heightFloat)
        } else {
            weightFloat / (heightFloat * heightFloat) * 703
        }
        return result
    }

    fun getCommentResult(bmi: Float): Int {
        return when {
            bmi < 16.0 ->  R.string.severely_underweight
            bmi in 16.0 .. 18.4 -> R.string.underweight
            bmi in 18.5 .. 24.9 -> R.string.normal
            bmi in 25.0 .. 29.9 -> R.string.overweight
            bmi in 30.0 .. 34.9 -> R.string.moderately_obese
            bmi in 35.0 .. 39.9 -> R.string.severely_obese
            else -> R.string.morbidly_obese
        }
    }

    fun getColorResult(bmi: Float): Int {
        return when {
            bmi < 18.4 -> R.color.underweight
            bmi in 18.5 .. 24.9 -> R.color.normal
            bmi in 25.0 .. 29.9 -> R.color.overweight
            else -> R.color.obese
        }
    }

    fun validateInput(value: String): Boolean {
        val pattern = Pattern.compile(REGEX_INPUT)
        val matchesPattern = pattern.matcher(value).matches()
        val notEmpty = value.isNotEmpty()
        val biggerThanZero = value.toFloat() > 0.0
        return matchesPattern && notEmpty && biggerThanZero
    }

    companion object {
        private const val REGEX_INPUT = "[0-9]+([,.][0-9]{1,2})?"
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="metric_system">Metric</string>
    <string name="imperial_system">Imperial</string>
    <string name="height_m_hint">Height (m)</string>
    <string name="height_in_hint">Height (in)</string>
    <string name="weight_kg_hint">Weight (kg)</string>
    <string name="weight_lbs_hint">Weight (lbs)</string>
    <string name="invalid_input">Invalid Input</string>
    <string name="severely_underweight">Severely Underweight</string>
    <string name="underweight">Underweight</string>
    <string name="normal">Normal</string>
    <string name="overweight">Overweight</string>
    <string name="moderately_obese">Moderately Obese</string>
    <string name="severely_obese">Severely Obese</string>
    <string name="morbidly_obese">Morbidly Obese</string>
    <string name="calculate_bmi">Calculate BMI</string>
    <string name="bmi">BMI</string>
"""), colorsData: ANDColorsData(additional: """
    <color name="backColorPrimary">#\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
    <color name="backColorSecondary">#\(mainData.uiSettings.backColorSecondary ?? "FFFFFF")</color>
    <color name="buttonColorPrimary">#\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF")</color>
    <color name="surfaceColor">#\(mainData.uiSettings.surfaceColor ?? "FFFFFF")</color>
    <color name="textColorPrimary">#\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
    <color name="textColorSecondary">#\(mainData.uiSettings.textColorSecondary ?? "FFFFFF")</color>
    <color name="buttonTextColorPrimary">#\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF")</color>
    <color name="underweight">#FFE28B</color>
    <color name="normal">#8BC34A</color>
    <color name="overweight">#FFB03B</color>
    <color name="obese">#ED6157</color>
"""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = """
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id 'com.android.application' version '8.0.2' apply false
    id 'com.android.library' version '8.0.2' apply false
    id 'org.jetbrains.kotlin.android' version '1.8.20' apply false
    id 'com.google.dagger.hilt.android' version '2.44' apply false
}
"""
        let projectGradleName = "build.gradle"
        let moduleGradle = """
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

android {
    namespace '\(packageName)'
    compileSdk 33

    defaultConfig {
        applicationId "\(packageName)"
        minSdk 24
        targetSdk 33
        versionCode 1
        versionName "1.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.debug
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = '17'
    }
    buildFeatures {
        viewBinding true
    }
}

dependencies {

    implementation 'androidx.core:core-ktx:1.10.1'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.9.0'
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'

    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.6.1'
    implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.1"
    implementation "androidx.lifecycle:lifecycle-livedata-ktx:2.6.1"
    implementation 'androidx.fragment:fragment-ktx:1.6.0'

    implementation "com.google.dagger:hilt-android:2.44"
    kapt "com.google.dagger:hilt-android-compiler:2.44"
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = ""
        let dependenciesName = ""

        return GradleFilesData(
            projectBuildGradle: GradleFileInfoData(
                content: projectGradle,
                name: projectGradleName
            ),
            moduleBuildGradle: GradleFileInfoData(
                content: moduleGradle,
                name: moduleGradleName
            ),
            dependencies: GradleFileInfoData(
                content: dependencies,
                name: dependenciesName
            ))
    }
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import \(packageName).R
import \(packageName).databinding.FragmentMainBinding
import com.google.android.material.snackbar.Snackbar
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainFragment : Fragment() {

    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!

    private val viewModel: BmiViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentMainBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        setRBListeners()
        setButtonListener()
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }

    private fun setButtonListener() {
        with (binding) {
            btnCalculateBmi.setOnClickListener {
                val height = etHeight.text.toString()
                val weight = etWeight.text.toString()

                if (viewModel.validateInput(height) && viewModel.validateInput(weight)) {
                    val metric = rbMetric.isChecked
                    val result = viewModel.getBmiResult(weight, height, metric)
                    tvBmiResult.text = String.format(FORMAT_FLOAT, result)
                    setResultColor(result)
                    setCommentResult(result)
                } else {
                    Snackbar.make(
                        binding.root,
                        getString(R.string.invalid_input),
                        Snackbar.LENGTH_SHORT
                    ).show()
                }
            }
        }
    }

    private fun setResultColor(result: Float) {
        val colorId = viewModel.getColorResult(result)
        binding.tvBmiResult.setBackgroundResource(colorId)

    }

    private fun setCommentResult(result: Float) {
        val commentId = viewModel.getCommentResult(result)
        binding.tvResultComment.text = getString(commentId)
    }

    private fun setRBListeners() {
        with(binding) {
            rbImperial.setOnClickListener {
                tilHeight.hint = getString(R.string.height_in_hint)
                tilWeight.hint = getString(R.string.weight_lbs_hint)
            }

            rbMetric.setOnClickListener {
                tilHeight.hint = getString(R.string.height_m_hint)
                tilWeight.hint = getString(R.string.weight_kg_hint)
            }
        }
    }

    companion object {
        private const val FORMAT_FLOAT = "%.1f"
    }
}
""", fileName: "MainFragment.kt")
    }
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData] {
        let name = "fragment_main.xml"
        let content = """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:background="@color/backColorPrimary"
    android:layout_width="match_parent"
    android:layout_height="match_parent">


    <TextView
        android:id="@+id/tv_bmi_result"
        style="@style/BmiResult"
        android:background="@color/backColorSecondary"
        android:text="@string/bmi"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <com.google.android.material.textfield.TextInputLayout
        android:id="@+id/til_height"
        android:layout_width="@dimen/width_300dp"
        android:layout_height="wrap_content"
        android:layout_marginBottom="@dimen/margin_bottom_16dp"
        android:hint="@string/height_m_hint"
        app:layout_constraintBottom_toTopOf="@+id/til_weight"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_bmi_result"
        app:layout_constraintVertical_chainStyle="packed">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/et_height"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:background="@color/surfaceColor"
            android:inputType="numberDecimal"
            android:lines="1"
            android:maxLines="1" />
    </com.google.android.material.textfield.TextInputLayout>

    <com.google.android.material.textfield.TextInputLayout
        android:id="@+id/til_weight"
        android:layout_width="@dimen/width_300dp"
        android:layout_height="wrap_content"
        app:layout_constraintBottom_toTopOf="@+id/rg_unit_system"
        app:layout_constraintEnd_toEndOf="parent"
        android:hint="@string/weight_kg_hint"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/til_height">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/et_weight"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:background="@color/surfaceColor"
            android:inputType="numberDecimal"
            android:lines="1"
            android:maxLines="1" />
    </com.google.android.material.textfield.TextInputLayout>

    <RadioGroup
        android:id="@+id/rg_unit_system"
        android:layout_width="@dimen/width_300dp"
        android:layout_height="wrap_content"
        android:layout_marginBottom="@dimen/margin_bottom_16dp"
        app:layout_constraintBottom_toTopOf="@+id/btn_calculate_bmi"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent">

        <RadioButton
            android:id="@+id/rb_metric"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:checked="true"
            android:text="@string/metric_system"/>

        <RadioButton
            android:id="@+id/rb_imperial"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="@string/imperial_system"/>
    </RadioGroup>

    <com.google.android.material.button.MaterialButton
        android:id="@+id/btn_calculate_bmi"
        style="@style/Button"
        android:text="@string/calculate_bmi"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent" />

    <TextView
        android:id="@+id/tv_result_comment"
        style="@style/BmiCommentResult"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_bmi_result" />

</androidx.constraintlayout.widget.ConstraintLayout>
"""
        return [XMLLayoutData(content: content, name: name)]
    }
    
    static func dimens(_ uiSettings: UISettings) -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="textSizePrimary">24sp</dimen>
    <dimen name="textSizeSecondary">56sp</dimen>

    <dimen name="width_300dp">300dp</dimen>
    <dimen name="height_300dp">300dp</dimen>
    <dimen name="height_200dp">200dp</dimen>
    <dimen name="height_60dp">60dp</dimen>

    <dimen name="margin_bottom_24dp">24dp</dimen>
    <dimen name="margin_bottom_16dp">16dp</dimen>
    <dimen name="margin_top_8dp">8dp</dimen>
</resources>
""", name: "dimens.xml")
    }
    
    static func styles() -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Button">
        <item name="android:layout_width">@dimen/width_300dp</item>
        <item name="android:layout_height">@dimen/height_60dp</item>
        <item name="android:layout_marginBottom">@dimen/margin_bottom_24dp</item>
        <item name="backgroundTint">@color/buttonColorPrimary</item>
        <item name="textAllCaps">false</item>
    </style>

    <style name="BmiResult">
        <item name="android:layout_width">match_parent</item>
        <item name="android:layout_height">@dimen/height_200dp</item>
        <item name="fontFamily">monospace</item>
        <item name="android:gravity">center</item>
        <item name="android:textSize">@dimen/textSizeSecondary</item>
        <item name="android:textColor">@color/textColorSecondary</item>
    </style>

    <style name="BmiCommentResult">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="android:layout_marginTop">@dimen/margin_top_8dp</item>
        <item name="fontFamily">monospace</item>
        <item name="android:textSize">@dimen/textSizePrimary</item>
        <item name="android:textColor">@color/textColorPrimary</item>
    </style>
</resources>


""", name: "styles.xml")
    }
    
}
