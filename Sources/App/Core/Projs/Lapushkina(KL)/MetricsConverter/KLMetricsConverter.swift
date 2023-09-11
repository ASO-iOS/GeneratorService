//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct KLMetricsConverter: XMLFileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import androidx.activity.OnBackPressedCallback
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.fragment.app.viewModels
import androidx.lifecycle.ViewModel
import com.google.android.material.snackbar.Snackbar
import \(packageName).R
import \(packageName).databinding.FragmentConverterBinding
import \(packageName).databinding.ItemSpinnerBinding
import \(packageName).repository.state.StateViewModel
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import java.util.regex.Pattern
import javax.inject.Inject

@AndroidEntryPoint
class ConverterFragment : Fragment() {

    private var _binding: FragmentConverterBinding? = null
    private val binding get() = _binding!!

    private val viewModel: ConverterViewModel by viewModels()
    private val stateViewModel: StateViewModel by activityViewModels()

    private lateinit var unitType: UnitType

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.getString(UNIT_TYPE)?.let {
            unitType = UnitType.valueOf(it)
        }

        activity?.onBackPressedDispatcher?.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                stateViewModel.setMainState()
            }
        })
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentConverterBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.tvUnitType.text = getString(unitType.displayName)
        setSpinnerAdapters()
        setButtonListener()
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }

    private fun setSpinnerAdapters() {
        val list = viewModel.getUnitList(unitType)
        val fromAdapter = UnitAdapter(
            requireActivity(),
            R.layout.item_spinner,
            list
        )
        val toAdapter = UnitAdapter(
            requireActivity(),
            R.layout.item_spinner,
            list
        )
        binding.spUnitFrom.adapter = fromAdapter
        binding.spUnitTo.adapter = toAdapter
    }

    private fun setButtonListener() {
        with(binding) {
            btnConvert.setOnClickListener {
                val value = etFrom.text.toString()
                val from = spUnitFrom.selectedItem as Units
                val to = spUnitTo.selectedItem as Units
                if (viewModel.validateInput(value)) {
                    val result = viewModel.getConvertedResult(from, to, value.toDouble())
                    etTo.setText(result.toString())
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


    companion object {

        private const val UNIT_TYPE = "unit_type"

        fun newInstance(unitType: String) = ConverterFragment().apply {
            arguments = Bundle().apply {
                putString(UNIT_TYPE, unitType)
            }
        }
    }
}

@HiltViewModel
class ConverterViewModel  @Inject constructor() : ViewModel() {

    fun getUnitList(type: UnitType): MutableList<Units> {
        return Units.values().filter { it.unitType == type }.toMutableList()
    }

    fun getConvertedResult(from: Units, to: Units, value: Double) : Double {
        return if (from.unitType == UnitType.TEMPERATURE && to.unitType == UnitType.TEMPERATURE) {
            return convertTemperature(from, to, value)
        } else {
            value * from.value / to.value
        }
    }

    private fun convertTemperature(from: Units, to: Units, value: Double) : Double {
        when (from) {
            Units.FAHRENHEIT -> {
                return when (to) {
                    Units.CELSIUS -> (value - Units.FAHRENHEIT.value) * FAHRENHEIT_MULTIPLIER / 1
                    Units.KELVIN -> (value - Units.FAHRENHEIT.value) * FAHRENHEIT_MULTIPLIER / 1 + Units.KELVIN.value
                    Units.FAHRENHEIT -> value
                    else -> 0.0
                }
            }

            Units.CELSIUS -> {
                return when (to) {
                    Units.CELSIUS -> value
                    Units.KELVIN -> value + Units.KELVIN.value
                    Units.FAHRENHEIT -> value * FAHRENHEIT_MULTIPLIER + Units.FAHRENHEIT.value
                    else -> 0.0
                }
            }

            Units.KELVIN -> {
                return when (to) {
                    Units.CELSIUS -> value - Units.KELVIN.value
                    Units.KELVIN -> value
                    Units.FAHRENHEIT -> (value - Units.KELVIN.value) * FAHRENHEIT_MULTIPLIER + Units.FAHRENHEIT.value
                    else -> 0.0
                }
            }

            else -> return 0.0
        }
    }

    fun validateInput(value: String): Boolean {
        val pattern = Pattern.compile(REGEX_INPUT)
        return pattern.matcher(value).matches() && value.isNotEmpty()
    }

    companion object {
        private const val REGEX_INPUT = "[0-9]+([,.][0-9]+)?"
        private const val FAHRENHEIT_MULTIPLIER = 1.8
    }
}

class UnitAdapter(
    context: Context,
    itemLayout: Int,
    list: MutableList<Units>
) : ArrayAdapter<Units>(context, itemLayout, list) {

    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        val binding: ItemSpinnerBinding = if (convertView != null) {
            ItemSpinnerBinding.bind(convertView)
        } else {
            ItemSpinnerBinding.inflate(LayoutInflater.from(context), parent, false)
        }

        val itemName = getItem(position)?.displayName
        itemName?.let {
            binding.tvUnitItemSpinner.text = context.getString(it)
        }

        return binding.root
    }

    override fun getDropDownView(position: Int, convertView: View?, parent: ViewGroup): View {
        val binding: ItemSpinnerBinding = if (convertView != null) {
            ItemSpinnerBinding.bind(convertView)
        } else {
            ItemSpinnerBinding.inflate(LayoutInflater.from(context), parent, false)
        }

        val itemName = getItem(position)?.displayName
        itemName?.let {
            binding.tvUnitItemSpinner.text = context.getString(it)
        }

        return binding.root
    }
}

enum class Units(val displayName: Int, val value: Double, val unitType: UnitType) {
    //length
    MILLIMETER(R.string.millimeter, 0.001, UnitType.LENGTH),
    CENTIMETER(R.string.centimeter, 0.01, UnitType.LENGTH),
    DECIMETER(R.string.decimeter, 0.1, UnitType.LENGTH),
    METER(R.string.meter, 1.0, UnitType.LENGTH),
    KILOMETER(R.string.kilometer, 1000.0, UnitType.LENGTH),
    MILE(R.string.mile, 1609.34, UnitType.LENGTH),
    YARD(R.string.yard, 0.9144, UnitType.LENGTH),
    FOOT(R.string.foot, 0.3048, UnitType.LENGTH),
    INCH(R.string.inch, 0.0254, UnitType.LENGTH),

    //weight
    MILLIGRAM(R.string.milligram, 0.000001, UnitType.WEIGHT),
    GRAM(R.string.gram, 0.001, UnitType.WEIGHT),
    KILOGRAM(R.string.kilogram, 1.0, UnitType.WEIGHT),
    METRIC_TON(R.string.metric_ton, 1000.0, UnitType.WEIGHT),
    POUND(R.string.pound, 0.4535, UnitType.WEIGHT),
    OUNCE(R.string.ounce, 0.0283, UnitType.WEIGHT),

    //temperature
    KELVIN(R.string.kelvin, 273.15, UnitType.TEMPERATURE),
    CELSIUS(R.string.celsius, 1.0, UnitType.TEMPERATURE),
    FAHRENHEIT(R.string.fahrenheit, 32.0, UnitType.TEMPERATURE),

    //volume
    CUBIC_MILLIMETER(R.string.cubic_millimeter, 0.000000001, UnitType.VOLUME),
    CUBIC_CENTIMETER(R.string.cubic_centimeter, 0.000001, UnitType.VOLUME),
    CUBIC_DECIMETER(R.string.cubic_decimeter, 0.001, UnitType.VOLUME),
    CUBIC_METER(R.string.cubic_meter, 1.0, UnitType.VOLUME),
    CUBIC_KILOMETER(R.string.cubic_kilometer, 1000000000.0, UnitType.VOLUME),
    CUBIC_MILE(R.string.cubic_mile, 4168180000.0, UnitType.VOLUME),
    CUBIC_YARD(R.string.cubic_yard, 0.7645, UnitType.VOLUME),
    CUBIC_FOOT(R.string.cubic_foot, 0.0283, UnitType.VOLUME),
    CUBIC_INCH(R.string.cubic_inch, 0.000016, UnitType.VOLUME),
    MILLILITER(R.string.milliliter, 0.000001, UnitType.VOLUME),
    LITER(R.string.liter, 0.001, UnitType.VOLUME),
    GALLON(R.string.gallon, 0.00378541, UnitType.VOLUME),
    QUART(R.string.quart, 0.0009463525, UnitType.VOLUME),
    PINT(R.string.pint, 0.0004731763, UnitType.VOLUME),
    CUP(R.string.cup, 0.0002365881, UnitType.VOLUME),

    //time
    NANOSECOND(R.string.nanosecond, 0.000000001, UnitType.TIME),
    MILLISECOND(R.string.millisecond, 0.001, UnitType.TIME),
    SECOND(R.string.second, 1.0, UnitType.TIME),
    MINUTE(R.string.minute, 60.0, UnitType.TIME),
    HOUR(R.string.hour, 3600.0, UnitType.TIME),
    DAY(R.string.day, 86400.0, UnitType.TIME),

    //area
    SQUARE_MILLIMETER(R.string.square_millimeter, 0.000001, UnitType.AREA),
    SQUARE_CENTIMETER(R.string.square_centimeter, 0.0001, UnitType.AREA),
    SQUARE_DECIMETER(R.string.square_decimeter, 0.01, UnitType.AREA),
    SQUARE_METER(R.string.square_meter, 1.0, UnitType.AREA),
    SQUARE_KILOMETER(R.string.square_kilometer, 1000000.0, UnitType.AREA),
    SQUARE_MILE(R.string.square_mile, 2589990.0, UnitType.AREA),
    SQUARE_YARD(R.string.square_yard, 0.83612736, UnitType.AREA),
    SQUARE_FOOT(R.string.square_foot, 0.09290304, UnitType.AREA),
    SQUARE_INCH(R.string.square_inch, 0.00064516, UnitType.AREA),
    HECTARE(R.string.hectare, 10000.0, UnitType.AREA),
    ACRE(R.string.acre, 4046.8564224, UnitType.AREA)
}

enum class UnitType(val displayName: Int) {
    LENGTH(R.string.length),
    TIME(R.string.time),
    WEIGHT(R.string.weight),
    TEMPERATURE(R.string.temperature),
    AREA(R.string.area),
    VOLUME(R.string.volume)
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: """
import \(mainData.packageName).presentation.fragments.main_fragment.ConverterFragment
""", extraFunc: "", content: "", extraStates: """
                        is FragmentState.ConverterState -> replace(ConverterFragment.newInstance(it.unitType))
"""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="convert_button_text">Convert</string>
    <string name="edit_text_unit_from">From</string>
    <string name="edit_text_unit_to">To</string>
    <string name="invalid_input">Invalid Input</string>

    //length
    <string name="length">Length</string>
    <string name="millimeter">Millimeter</string>
    <string name="centimeter">Centimeter</string>
    <string name="decimeter">Decimeter</string>
    <string name="meter">Meter</string>
    <string name="kilometer">Kilometer</string>
    <string name="mile">Mile</string>
    <string name="yard">Yard</string>
    <string name="foot">Foot</string>
    <string name="inch">Inch</string>

    //time
    <string name="time">Time</string>
    <string name="nanosecond">Nanosecond</string>
    <string name="millisecond">Millisecond</string>
    <string name="second">Second</string>
    <string name="minute">Minute</string>
    <string name="hour">Hour</string>
    <string name="day">Day</string>

    //weight
    <string name="weight">Weight</string>
    <string name="milligram">Milligram</string>
    <string name="gram">Gram</string>
    <string name="kilogram">Kilogram</string>
    <string name="metric_ton">Metric Ton</string>
    <string name="pound">Pound</string>
    <string name="ounce">Ounce</string>

    //temperature
    <string name="temperature">Temperature</string>
    <string name="kelvin">Kelvin</string>
    <string name="celsius">Celsius</string>
    <string name="fahrenheit">Fahrenheit</string>

    //volume
    <string name="volume">Volume</string>
    <string name="cubic_millimeter">Cubic Millimeter</string>
    <string name="cubic_centimeter">Cubic Centimeter</string>
    <string name="cubic_decimeter">Cubic Decimeter</string>
    <string name="cubic_meter">Cubic Meter</string>
    <string name="cubic_kilometer">Cubic Kilometer</string>
    <string name="cubic_mile">Cubic Mile</string>
    <string name="cubic_yard">Cubic Yard</string>
    <string name="cubic_foot">Cubic Foot</string>
    <string name="cubic_inch">Cubic Inch</string>
    <string name="milliliter">Milliliter</string>
    <string name="liter">Liter</string>
    <string name="gallon">Gallon</string>
    <string name="quart">Quart</string>
    <string name="pint">Pint</string>
    <string name="cup">Cup</string>

    //area
    <string name="area">Area</string>
    <string name="square_millimeter">Square Millimeter</string>
    <string name="square_centimeter">Square Centimeter</string>
    <string name="square_decimeter">Square Decimeter</string>
    <string name="square_meter">Square Meter</string>
    <string name="square_kilometer">Square Kilometer</string>
    <string name="square_mile">Square Mile</string>
    <string name="square_yard">Square Yard</string>
    <string name="square_foot">Square Foot</string>
    <string name="square_inch">Square Inch</string>
    <string name="hectare">Hectare</string>
    <string name="acre">Acre</string>
"""), colorsData: ANDColorsData(additional: """
            <color name="backColorPrimary">#\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
            <color name="surfaceColor">#\(mainData.uiSettings.surfaceColor ?? "FFFFFF")</color>
            <color name="textColorPrimary">#\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
            <color name="textColorSecondary">#\(mainData.uiSettings.textColorSecondary ?? "FFFFFF")</color>
            <color name="buttonColorPrimary">#\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF")</color>
        """), stateViewModelData: """

    fun setConverterState(unitType: String) {
        _state.value = FragmentState.ConverterState(unitType)
    }
""", fragmentStateData: """
            class ConverterState(val unitType: String) : FragmentState()
        """)
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

    implementation "com.google.dagger:hilt-android:2.44"
    kapt "com.google.dagger:hilt-android-compiler:2.44"

    implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.1"
    implementation "androidx.lifecycle:lifecycle-livedata-ktx:2.6.1"

    implementation 'androidx.fragment:fragment-ktx:1.6.0'
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
import androidx.fragment.app.activityViewModels
import \(packageName).databinding.FragmentMainBinding
import \(packageName).repository.state.StateViewModel
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainFragment : Fragment() {

    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!

    private val viewModel by activityViewModels<StateViewModel>()

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
        setOnClickListeners()
    }

    override fun onDetach() {
        super.onDetach()
        _binding = null
    }

    private fun setOnClickListeners() {
        with(binding) {
            btnLength.setOnClickListener {
                viewModel.setConverterState(UnitType.LENGTH.name)
            }
            btnArea.setOnClickListener {
                viewModel.setConverterState(UnitType.AREA.name)
            }
            btnTime.setOnClickListener {
                viewModel.setConverterState(UnitType.TIME.name)
            }
            btnTemperature.setOnClickListener {
                viewModel.setConverterState(UnitType.TEMPERATURE.name)
            }
            btnWeight.setOnClickListener {
                viewModel.setConverterState(UnitType.WEIGHT.name)
            }
            btnVolume.setOnClickListener {
                viewModel.setConverterState(UnitType.VOLUME.name)
            }
        }
    }

}
""", fileName: "MainFragment.kt")
    }
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData] {
        let converterFragmentName = "fragment_converter.xml"
        let converterFragmentContent = """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    android:paddingHorizontal="@dimen/fragment_padding_horizontal"
    android:paddingVertical="@dimen/fragment_padding_vertical">

    <TextView
        android:id="@+id/tv_unit_type"
        style="@style/AppTitle"
        android:text="@string/length"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <com.google.android.material.textfield.TextInputLayout
        android:id="@+id/textInputLayout"
        style="@style/ThemeOverlay.Material3.AutoCompleteTextView.OutlinedBox"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        app:hintTextColor="@color/textColorPrimary"
        app:boxStrokeColor="@color/textColorPrimary"
        app:layout_constraintBottom_toTopOf="@+id/textInputLayout2"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_unit_type"
        app:layout_constraintVertical_chainStyle="packed">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/et_from"
            android:layout_width="match_parent"
            android:layout_height="@dimen/et_height"
            android:background="@color/surfaceColor"
            android:textColor="@color/textColorPrimary"
            android:textCursorDrawable="@null"
            android:hint="@string/edit_text_unit_from"
            android:inputType="numberDecimal"
            android:lines="1"
            android:maxLines="1" />

    </com.google.android.material.textfield.TextInputLayout>

    <com.google.android.material.textfield.TextInputLayout
        android:id="@+id/textInputLayout2"
        style="@style/ThemeOverlay.Material3.AutoCompleteTextView.OutlinedBox"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginTop="@dimen/et_space_between"
        app:hintTextColor="@color/textColorPrimary"
        app:boxStrokeColor="@color/textColorPrimary"
        app:layout_constraintBottom_toTopOf="@+id/sp_unit_from"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/textInputLayout">

        <com.google.android.material.textfield.TextInputEditText
            android:id="@+id/et_to"
            android:layout_width="match_parent"
            android:layout_height="@dimen/et_height"
            android:background="@color/surfaceColor"
            android:textColor="@color/textColorPrimary"
            android:textCursorDrawable="@null"
            android:clickable="false"
            android:focusable="false"
            android:focusableInTouchMode="false"
            android:hint="@string/edit_text_unit_to" />

    </com.google.android.material.textfield.TextInputLayout>


    <Spinner
        android:id="@+id/sp_unit_from"
        style="@style/Spinner"
        android:layout_height="@dimen/sp_height"
        android:spinnerMode="dialog"
        android:popupBackground="@color/surfaceColor"
        app:layout_constraintBottom_toTopOf="@+id/sp_unit_to"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent" />

    <Spinner
        android:id="@+id/sp_unit_to"
        style="@style/Spinner"
        android:layout_height="@dimen/sp_height"
        android:spinnerMode="dialog"
        app:layout_constraintBottom_toTopOf="@+id/btn_convert"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent" />

    <Button
        android:id="@+id/btn_convert"
        style="@style/Button"
        android:text="@string/convert_button_text"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
"""
        let mainFragmentName = "fragment_main.xml"
        let mainFragmentContent = """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    android:paddingHorizontal="@dimen/fragment_padding_horizontal"
    android:paddingVertical="@dimen/fragment_padding_vertical">

    <TextView
        android:id="@+id/tv_speed_test_title"
        style="@style/AppTitle"
        android:text="@string/app_name"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <Button
        android:id="@+id/btn_length"
        style="@style/Button"
        android:text="@string/length"
        app:layout_constraintBottom_toTopOf="@+id/btn_time"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_speed_test_title"
        app:layout_constraintVertical_chainStyle="packed" />

    <Button
        android:id="@+id/btn_time"
        style="@style/Button"
        android:text="@string/time"
        app:layout_constraintBottom_toTopOf="@+id/btn_weight"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/btn_length" />

    <Button
        android:id="@+id/btn_weight"
        style="@style/Button"
        android:text="@string/weight"
        app:layout_constraintBottom_toTopOf="@+id/btn_temperature"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/btn_time" />

    <Button
        android:id="@+id/btn_temperature"
        style="@style/Button"
        android:text="@string/temperature"
        app:layout_constraintBottom_toTopOf="@+id/btn_area"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/btn_weight" />

    <Button
        android:id="@+id/btn_area"
        style="@style/Button"
        android:text="@string/area"
        app:layout_constraintBottom_toTopOf="@+id/btn_volume"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/btn_temperature" />

    <Button
        android:id="@+id/btn_volume"
        style="@style/Button"
        android:text="@string/volume"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/btn_area" />

</androidx.constraintlayout.widget.ConstraintLayout>
"""
        let itemName = "item_spinner.xml"
        let itemContent = """
<?xml version="1.0" encoding="utf-8"?>
<TextView
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/tv_unit_item_spinner"
    style="?attr/spinnerDropDownItemStyle"
    android:textColor="@color/textColorPrimary"
    android:background="@color/surfaceColor"
    android:singleLine="true"
    android:layout_width="match_parent"
    android:layout_height="?attr/dropdownListPreferredItemHeight" />
"""
        return [
            XMLLayoutData(content: converterFragmentContent, name: converterFragmentName),
            XMLLayoutData(content: mainFragmentContent, name: mainFragmentName),
            XMLLayoutData(content: itemContent, name: itemName)
        ]
        
    }
    
    static func dimens(_ uiSettings: UISettings) -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="textSizePrimary">24sp</dimen>

    <dimen name="fragment_padding_vertical">20dp</dimen>
    <dimen name="fragment_padding_horizontal">72dp</dimen>

    <dimen name="et_width">300dp</dimen>
    <dimen name="et_height">100dp</dimen>

    <dimen name="sp_width">240dp</dimen>
    <dimen name="sp_width_land">200dp</dimen>
    <dimen name="sp_height">48dp</dimen>

    <dimen name="btn_width">240dp</dimen>
    <dimen name="btn_height">64dp</dimen>

    <dimen name="sp_bottom_margin">20dp</dimen>
    <dimen name="et_top_margin">100dp</dimen>
    <dimen name="et_space_between">20dp</dimen>

    <dimen name="btn_top_margin">20dp</dimen>
</resources>
""", name: "dimens.xml")
    }
    
    static func styles() -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="AppTitle">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="fontFamily">monospace</item>
        <item name="android:textSize">@dimen/textSizePrimary</item>
        <item name="android:textColor">@color/textColorPrimary</item>
    </style>

    <style name="EditTextUnit">
        <item name="android:layout_width">match_parent</item>
        <item name="android:layout_height">@dimen/et_height</item>
        <item name="android:textColor">@color/textColorPrimary</item>
    </style>

    <style name="Spinner">
        <item name="android:layout_width">match_parent</item>
        <item name="android:layout_height">@dimen/sp_height</item>
        <item name="android:layout_marginBottom">@dimen/sp_bottom_margin</item>
        <item name="fontFamily">monospace</item>
        <item name="android:textColor">@color/textColorPrimary</item>
    </style>

    <style name="Button">
        <item name="android:layout_width">match_parent</item>
        <item name="android:layout_height">@dimen/btn_height</item>
        <item name="fontFamily">monospace</item>
        <item name="android:layout_marginTop">@dimen/btn_top_margin</item>
        <item name="backgroundTint">@color/buttonColorPrimary</item>
        <item name="android:textColor">@color/textColorSecondary</item>
    </style>
</resources>
""", name: "styles.xml")
    }
}
