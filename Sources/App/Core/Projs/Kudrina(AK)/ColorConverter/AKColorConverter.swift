//
//  File.swift
//  
//
//  Created by admin on 11.08.2023.
//

import Foundation

struct AKColorConverter: FileProviderProtocol {
    static var fileName: String = "AKColorConverter.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.selectable
import androidx.compose.material.OutlinedTextField
import androidx.compose.material.RadioButton
import androidx.compose.material.RadioButtonDefaults
import androidx.compose.material.Text
import androidx.compose.material.TextFieldDefaults
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import kotlin.math.absoluteValue
import kotlin.math.roundToInt
import androidx.compose.ui.graphics.Color
import android.graphics.Color.rgb


val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))


@HiltViewModel
class MainViewModel @Inject constructor() : ViewModel() {


    private val _currentType = MutableLiveData(0)
    val currentType: LiveData<Int> get() = _currentType

    fun changeCurrentType(newCurrentType: Int) {
        _currentType.value = newCurrentType
    }



    private val _buttonClicked = MutableLiveData(false)
    val buttonClicked: LiveData<Boolean> get() = _buttonClicked

    fun changeButtonClicked(newButtonClicked: Boolean) {
        _buttonClicked.value = newButtonClicked
    }



    private val _textFromInput = MutableLiveData("")
    val textFromInput: LiveData<String> get() = _textFromInput

    fun changeTextFromInput(newTextFromInput: String) {
        _textFromInput.value = newTextFromInput
    }



    private fun setColorRGB(red: Int = 100, green: Int = 0, blue: Int = 0) {
        currentColor.value = rgb(red, green, blue)
    }

    val currentColor = MutableLiveData(rgb(38, 63, 27))

    fun convertAndSetColorRGB(textFromForm: String) {
        val colorArray = textFromForm.split(',')
        if (colorArray.size == 3) setColorRGB(
            colorArray[0].trim().toInt(),
            colorArray[1].trim().toInt(),
            colorArray[2].trim().toInt()
        )
    }

}

fun rgbToHex(rgbColor: String): String {
    val list = colorListAsList(rgbColor)
    if (list.size == 3) {
        return Integer.toHexString(
            rgb(
                list[0].trim().toInt(), list[1].trim().toInt(), list[2].trim().toInt()
            )
        )
    }
    return Integer.toHexString(rgb(0, 0, 0))
}


fun rgbToHsl(rgbColor: String, context: Context): String {

    var red = 0
    var green = 0
    var blue = 0

    val list = colorListAsList(rgbColor)
    if (list.size == 3) {
        red = list[0].trim().toInt()
        green = list[1].trim().toInt()
        blue = list[2].trim().toInt()
    }


    var r: Double = red / 255.0
    var g: Double = green / 255.0
    var b: Double = blue / 255.0

    var max: Double = maxOf(r, g, b)
    var min: Double = minOf(r, g, b)
    var dalet: Double = max - min
    var hue: Double = 0.0
    var saturation: Double = 0.0


    if (dalet > 0) {
        if (max == r) {
            hue = ((g - b) / dalet);
            if (hue < 0) {
                hue += 6
            }
        } else if (max == g) {
            hue = ((b - r) / dalet) + 2
        } else if (max == b) {
            hue = ((r - g) / dalet) + 4
        }
        hue *= 60
    }

    var luminosity: Double = (max + min) / 2.0
    if (dalet != 0.0) {
        saturation = dalet / (1 - 2 * luminosity - 1)
    }

    saturation *= 100
    luminosity *= 100

    return context.getString(
        R.string.hsl,
        hue.roundToInt().absoluteValue.toString(),
        saturation.roundToInt().absoluteValue.toString(),
        luminosity.roundToInt().absoluteValue.toString()
    )
}


fun hexToRgb(hexColor: String, context: Context): String {
    return if (hexColor.trim().length == 6) {
        val red = "0x" + hexColor.substring(0, 2).uppercase()
        val green = "0x" + hexColor.substring(2, 4).uppercase()
        val blue = "0x" + hexColor.substring(4, 6).uppercase()

        val redInt = Integer.decode(red)
        val greenInt = Integer.decode(green)
        val blueInt = Integer.decode(blue)

        context.getString(R.string.rgb, redInt.toString(), greenInt.toString(), blueInt.toString())
    } else {
        context.getString(R.string.rgb, "0", "0", "0")
    }
}

fun hexToHsl(hexColor: String, context: Context): String {
    val res = hexToRgb(hexColor, context)
    return rgbToHsl(res, context)
}

fun absValue(value: Double): Double {
    return if (value < 0.0) -value else value
}

fun roundValue(num: Double): Int {
    return if (num < 0) (num - 0.5).toInt() else (num + 0.5).toInt()
}

fun hslToRgb(hslColor: String, context: Context): String {
    val listColor = colorListAsList(hslColor)
    if (listColor.size == 3) {
        var h = listColor[0].toDouble()
        var s = listColor[1].toDouble()
        var l = listColor[2].toDouble()

        if (s > 100) {
            s = 100.0
        }
        if (l > 100) {
            l = 100.0
        }
        if (h > 359) {
            h = 100.0
        }

        var red = 0.0
        var green = 0.0
        var blue = 0.0
        if (s != 0.0) {
            s /= 100.0
        }
        if (l != 0.0) {
            l /= 100.0
        }

        val chroma = s * (1 - absValue(2 * l - 1))
        val h1 = h / 60.0

        val m = l - chroma / 2

        val x = chroma * (1.0 - absValue(h1 % 2 - 1.0))

        when  {
            h1 in 0.0..1.0 -> {
                green = x
                red = chroma
            }
            h1 == 1.0 -> {
                red = x
                green = chroma
            }
            (h1 >= 2.0 && h1 < 3.0)  -> {
                blue = x
                green = chroma
            }
            (h1 >= 3.0 && h1 < 4.0) -> {
                green = x
                blue = chroma
            }
            (h1 >= 4.0 && h1 < 5.0) -> {
                red = x
                blue = chroma
            }
            else -> {
                blue = x
                red = chroma
            }
        }


        red += m
        green += m
        blue += m

        red *= 255.0
        green *= 255.0
        blue *= 255.0

        val r = roundValue(red)
        val g = roundValue(green)
        val b = roundValue(blue)
        return context.getString(R.string.rgb, r.toString(), g.toString(), b.toString())
    } else {
        return context.getString(R.string.rgb, "0", "0", "0")
    }

}

fun hslToHex(hslColor: String, context: Context): String {
    val res = hslToRgb(hslColor, context)
    return rgbToHex(res)
}

fun rgbIsCorrect(input: String): Boolean {
    val list = colorListAsList(input)
    return when {
        list.size != 3 -> false
        list[0].trim().toIntOrNull() == null -> false
        list[1].trim().toIntOrNull() == null -> false
        list[2].trim().toIntOrNull() == null -> false
        list[0].trim().toInt() !in 0..255 -> false
        list[1].trim().toInt() !in 0..255 -> false
        list[2].trim().toInt() !in 0..255 -> false
        else -> true
    }
}

fun hexIsCorrect(input: String): Boolean {
    return when {
        input.trim().length != 6 -> false
        input.trim().lowercase() !in "000000".."ffffff" -> false
        else -> true
    }
}

fun hslIsCorrect(input: String): Boolean {
    val list = colorListAsList(input)
    return when {
        list.size != 3 -> false
        list[0].trim().toIntOrNull() == null -> false
        list[1].trim().toIntOrNull() == null -> false
        list[2].trim().toIntOrNull() == null -> false
        list[0].trim().toInt() !in 0..360 -> false
        list[1].trim().toInt() !in 0..100 -> false
        list[2].trim().toInt() !in 0..100 -> false
        else -> true
    }
}

val MainFont = FontFamily(
    Font(R.font.brainstorm_marker)
)

val MainFontLight = FontFamily(
    Font(R.font.brainstorm_rollerball)
)


val listFormats = listOf(R.string.format_rgb, R.string.format_hex, R.string.format_hsl)

fun colorListAsList(rgb: String): List<String> {
    if (rgb.isEmpty()) return listOf()
    if (!rgb.contains(',')) return listOf()
    return rgb.split(',')
}

@Composable
fun Square(myColor: MutableState<Int>) {
    Canvas(
        modifier = Modifier
            .size(150.dp)
            .padding(top = 10.dp)
            .background(Color(myColor.value))
    ) {}
}

@Composable
fun ConvertButton(viewModel: MainViewModel, textFromInput: String, context: Context) {
    Button(
        modifier = Modifier.padding(top = 10.dp),
        onClick = {

            viewModel.changeButtonClicked(false)



            when (viewModel.currentType.value) {
                0 -> {
                    if (rgbIsCorrect(textFromInput)) {
                        val color = textFromInput
                        viewModel.convertAndSetColorRGB(color)
                        viewModel.changeButtonClicked(true)
                    } else {
                        Toast.makeText(context, R.string.input_error, Toast.LENGTH_SHORT).show()
                    }
                }

                1 -> {
                    if (hexIsCorrect(textFromInput)) {
                        val color = hexToRgb(textFromInput.uppercase(), context)
                        viewModel.convertAndSetColorRGB(color)
                        viewModel.changeButtonClicked(true)
                    } else {
                        Toast.makeText(context, R.string.input_error, Toast.LENGTH_SHORT).show()
                    }
                }

                2 -> {
                    if (hslIsCorrect(textFromInput)) {
                        val color = hslToRgb(textFromInput, context)
                        viewModel.convertAndSetColorRGB(color)
                        viewModel.changeButtonClicked(true)
                    } else {
                        Toast.makeText(context, R.string.input_error, Toast.LENGTH_SHORT).show()
                    }
                }
            }


        },
        colors = ButtonDefaults.buttonColors(
            containerColor = buttonColorPrimary
        )
    ) {
        Text(
            text = stringResource(id = R.string.button_text),
            fontSize = 16.sp,
            color = textColorPrimary,
            fontFamily = MainFont
        )
    }
}

@Composable
fun Header(viewModel: MainViewModel = hiltViewModel()) {
    Row(
        modifier = Modifier
            .fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        val colorTypes = listOf(
            stringResource(id = R.string.rgb_text),
            stringResource(id = R.string.hex_text),
            stringResource(id = R.string.hsl_text)
        )
        val (selectedOption, onOptionSelected) = remember { mutableStateOf(colorTypes[0]) }

        colorTypes.forEach { text ->
            Column(
                Modifier
                    .selectable(
                        selected = (text == selectedOption),
                        onClick = {
                            viewModel.changeTextFromInput("")
                            onOptionSelected(text)
                            viewModel.changeCurrentType(colorTypes.indexOf(text))
                        }
                    ),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {

                RadioButton(
                    selected = (text == selectedOption),
                    onClick = {
                        viewModel.changeTextFromInput("")
                        onOptionSelected(text)
                        viewModel.changeCurrentType(colorTypes.indexOf(text))
                    },
                    colors = RadioButtonDefaults.colors(
                        selectedColor = buttonColorPrimary,
                        unselectedColor = buttonColorPrimary
                    )
                )

                Text(
                    text = text,
                    fontSize = 22.sp,
                    fontFamily = MainFontLight,
                    color = textColorPrimary
                )
            }
        }
    }
}

@Composable
fun HelperText(myType: MutableState<Int>) {
    Text(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = 10.dp),
        text = stringResource(id = listFormats[myType.value]),
        textAlign = TextAlign.Center,
        fontSize = 16.sp,
        fontFamily = MainFont,
        color = textColorSecondary
    )
}

@Composable
fun MainUI(viewModel: MainViewModel = hiltViewModel()) {

    val myColor = rememberSaveable {
        mutableStateOf(0)
    }

    val myType = rememberSaveable {
        mutableStateOf(0)
    }

    val myButton = rememberSaveable {
        mutableStateOf(false)
    }

    val textFromInput = rememberSaveable {
        mutableStateOf("")
    }

    viewModel.currentColor.observe(LocalLifecycleOwner.current) {
        myColor.value = it
    }

    viewModel.currentType.observe(LocalLifecycleOwner.current) {
        myType.value = it
    }

    viewModel.buttonClicked.observe(LocalLifecycleOwner.current) {
        myButton.value = it
    }

    viewModel.textFromInput.observe(LocalLifecycleOwner.current) {
        textFromInput.value = it
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(top = 20.dp, bottom = 10.dp, start = 20.dp, end = 20.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Header()



        OutlinedTextField(
            maxLines = 1,
            modifier = Modifier
                .padding(top = 20.dp)
                .align(Alignment.CenterHorizontally),
            value = textFromInput.value,
            onValueChange = { textFromInput.value = it },
            label = {
                Text(
                    text = stringResource(id = R.string.label_text),
                    fontFamily = MainFontLight
                )
            },
            textStyle = TextStyle.Default.copy(
                fontSize = 18.sp, fontFamily = MainFont
            ),
            colors = TextFieldDefaults.outlinedTextFieldColors(
                focusedBorderColor = buttonColorPrimary,
                unfocusedBorderColor = textColorSecondary,
                textColor = textColorPrimary,
                unfocusedLabelColor = textColorSecondary,
                focusedLabelColor = buttonColorPrimary,
                cursorColor = buttonColorPrimary
            ),
        )

        val context = LocalContext.current

        HelperText(myType)

        ConvertButton(viewModel, textFromInput.value, context)

        Square(myColor)



        if (myButton.value) {
            Text(
                text = when (myType.value) {
                    0 -> if (rgbIsCorrect(textFromInput.value)) textFromInput.value else stringResource(id = R.string.empty)
                    1 -> if (hexIsCorrect(textFromInput.value)) hexToRgb(textFromInput.value, context) else stringResource(id = R.string.empty)
                    2 -> if (hslIsCorrect(textFromInput.value)) hslToRgb(textFromInput.value, context) else stringResource(id = R.string.empty)
                    else -> stringResource(id = R.string.error)
                }
            )

            Text(
                text = when (myType.value) {
                    0 -> if (rgbIsCorrect(textFromInput.value)) rgbToHex(textFromInput.value) else stringResource(id = R.string.empty)
                    1 -> if (hexIsCorrect(textFromInput.value)) textFromInput.value else stringResource(id = R.string.empty)
                    2 -> if (hslIsCorrect(textFromInput.value)) hslToHex(textFromInput.value, context) else stringResource(id = R.string.empty)
                    else -> stringResource(id = R.string.error)
                }
            )

            Text(
                text = when (myType.value) {
                    0 -> if (rgbIsCorrect(textFromInput.value)) rgbToHsl(textFromInput.value, context) else stringResource(id = R.string.empty)
                    1 -> if (hexIsCorrect(textFromInput.value)) hexToHsl(textFromInput.value, context) else stringResource(id = R.string.empty)
                    2 -> if (hslIsCorrect(textFromInput.value)) textFromInput.value else stringResource(id = R.string.empty)
                    else -> stringResource(id = R.string.error)
                }
            )
        }

    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    MainUI()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="rgb">%1$s, %2$s, %3$s</string>
    <string name="hsl">%1$s, %2$s, %3$s</string>
    <string name="format_rgb">Format: 38, 63, 27</string>
    <string name="format_hex">Format: ffffff</string>
    <string name="format_hsl">Format: 250, 98, 30</string>
    <string name="error">error</string>
    <string name="rgb_text">RGB</string>
    <string name="hex_text">HEX</string>
    <string name="hsl_text">HSL</string>
    <string name="button_text">Convert</string>
    <string name="input_error">Wrong input</string>
    <string name="empty"> </string>
    <string name="label_text">Enter your color</string>
"""), colorsData: ANDColorsData(additional: ""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = """
import dependencies.Versions
import dependencies.Build

buildscript {
    ext {
        compose_version = Versions.compose
        kotlin_version = Versions.kotlin
    }

    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
    dependencies {
        classpath Build.build_tools
        classpath Build.kotlin_gradle_plugin
        classpath Build.hilt_plugin
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
"""
        let projectGradleName = "build.gradle"
        let moduleGradle = """
import dependencies.Versions
import dependencies.Application
import dependencies.Dependencies

apply plugin: 'com.android.application'
apply plugin: 'org.jetbrains.kotlin.android'
apply plugin: 'kotlin-kapt'
apply plugin: 'dagger.hilt.android.plugin'

android {
    namespace Application.id
    compileSdk Versions.compilesdk

    defaultConfig {
        applicationId Application.id
        minSdk Versions.minsdk
        targetSdk Versions.targetsdk
        versionCode Application.version_code
        versionName Application.version_name

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary true
        }
    }

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
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
        compose true
    }
    composeOptions {
        kotlinCompilerExtensionVersion compose_version
    }
    bundle {
        storeArchive {
            enable = false
        }
    }
}

dependencies {

    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_material
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_hilt_nav
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = """
package dependencies

object Application {
    const val id = "\(packageName)"
    const val version_code = 1
    const val version_name = "1.0"
}

object Build {
    const val build_tools = "com.android.tools.build:gradle:${Versions.gradle}"
    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    const val hilt_plugin = "com.google.dagger:hilt-android-gradle-plugin:${Versions.hilt}"
}

object Versions {
    const val gradle = "8.0.0"
    const val compilesdk = 33
    const val minsdk = 24
    const val targetsdk = 33
    const val kotlin = "1.8.10"
    const val kotlin_coroutines = "1.6.3"
    const val hilt = "2.43.2"
    const val hilt_viewmodel_compiler = "1.0.0"

    const val ktx = "1.10.0"
    const val lifecycle = "2.6.1"
    const val fragment_ktx = "1.5.7"
    const val appcompat = "1.6.1"
    const val material = "1.9.0"
    const val accompanist = "0.31.1-alpha"

    const val compose = "1.4.3"
    const val compose_navigation = "2.5.0-beta01"
    const val activity_compose = "1.7.1"
    const val compose_hilt_nav = "1.0.0"

    const val oneSignal = "4.6.7"
    const val glide = "4.12.0"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "1.3.2"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
}

object Dependencies {
    const val core_ktx = "androidx.core:core-ktx:${Versions.ktx}"
    const val appcompat = "androidx.appcompat:appcompat:${Versions.appcompat}"
    const val material = "com.google.android.material:material:${Versions.material}"

    const val compose_ui = "androidx.compose.ui:ui:${Versions.compose}"
    const val compose_material = "androidx.compose.material:material:${Versions.compose}"
    const val compose_preview = "androidx.compose.ui:ui-tooling-preview:${Versions.compose}"
    const val compose_activity = "androidx.activity:activity-compose:${Versions.activity_compose}"
    const val compose_ui_tooling = "androidx.compose.ui:ui-tooling:${Versions.compose}"
    const val compose_navigation = "androidx.navigation:navigation-compose:${Versions.compose_navigation}"
    const val compose_hilt_nav = "androidx.hilt:hilt-navigation-compose:${Versions.compose_hilt_nav}"
    const val compose_foundation = "androidx.compose.foundation:foundation:${Versions.compose}"
    const val compose_runtime = "androidx.compose.runtime:runtime:${Versions.compose}"
    const val compose_material3 = "androidx.compose.material3:material3:1.1.0-rc01"
    const val compose_runtime_livedata = "androidx.compose.runtime:runtime-livedata:${Versions.compose}"
    const val compose_mat_icons_core = "androidx.compose.material:material-icons-core:${Versions.compose}"
    const val compose_mat_icons_core_extended = "androidx.compose.material:material-icons-extended:${Versions.compose}"

    const val coroutines = "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.kotlin_coroutines}"
    const val fragment_ktx = "androidx.fragment:fragment-ktx:${Versions.fragment_ktx}"
    const val compose_system_ui_controller = "com.google.accompanist:accompanist-systemuicontroller:${Versions.accompanist}"
    const val compose_permissions = "com.google.accompanist:accompanist-permissions:${Versions.accompanist}"

    const val lifecycle_viewmodel = "androidx.lifecycle:lifecycle-viewmodel-ktx:${Versions.lifecycle}"
    const val lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime-ktx:${Versions.lifecycle}"

    const val retrofit = "com.squareup.retrofit2:retrofit:${Versions.retrofit}"
    const val converter_gson = "com.squareup.retrofit2:converter-gson:${Versions.retrofit}"
    const val okhttp = "com.squareup.okhttp3:okhttp:${Versions.okhttp}"
    const val okhttp_login_interceptor = "com.squareup.okhttp3:logging-interceptor:${Versions.okhttp}"

    const val room_runtime = "androidx.room:room-runtime:${Versions.room}"
    const val room_compiler = "androidx.room:room-compiler:${Versions.room}"
    const val room_ktx = "androidx.room:room-ktx:${Versions.room}"
    const val roomPaging = "androidx.room:room-paging:${Versions.room}"

    const val onesignal = "com.onesignal:OneSignal:${Versions.oneSignal}"
    
    const val swipe_to_refresh = "com.google.accompanist:accompanist-swiperefresh:${Versions.swipe}"

    const val glide = "com.github.bumptech.glide:glide:${Versions.glide}"
    const val glide_skydoves = "com.github.skydoves:landscapist-glide:${Versions.glide_skydoves}"
    const val glide_compiler = "com.github.bumptech.glide:compiler:${Versions.glide}"

    const val dagger_hilt = "com.google.dagger:hilt-android:${Versions.hilt}"
    const val dagger_hilt_compiler = "com.google.dagger:hilt-android-compiler:${Versions.hilt}"
    const val hilt_viewmodel_compiler = "androidx.hilt:hilt-compiler:${Versions.hilt_viewmodel_compiler}"
    const val coil_compose = "io.coil-kt:coil-compose:${Versions.coil}"
    const val coil_svg = "io.coil-kt:coil-svg:${Versions.coil}"
    const val expression = "net.objecthunter:exp4j:${Versions.exp}"
    const val calendar = "io.github.boguszpawlowski.composecalendar:composecalendar:${Versions.calend}"
    const val calendar_date = "io.github.boguszpawlowski.composecalendar:kotlinx-datetime:${Versions.calend}"
    const val paging = "androidx.paging:paging-runtime:${Versions.paging_version}"
    const val pagingCommon = "androidx.paging:paging-common:${Versions.paging_version}"
    const val pagingCompose = "androidx.paging:paging-compose:1.0.0-alpha18"
}
"""
        let dependenciesName = "Dependencies.kt"

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
    
    
}
