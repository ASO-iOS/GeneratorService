//
//  File.swift
//  
//
//  Created by admin on 11.08.2023.
//

import Foundation

struct AKBoilingEgg: FileProviderProtocol {
    static var fileName: String = "AKBoilingEgg.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.media.RingtoneManager
import android.os.Handler
import android.os.Looper
import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.Icon
import androidx.compose.material.IconButton
import androidx.compose.material.Text
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.navigation.NamedNavArgument
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.Calendar
import javax.inject.Inject

val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))



val eggCategoryText = listOf(R.string.eggCategoryB, R.string.eggCategoryC0, R.string.eggCategoryC1, R.string.eggCategoryC2, R.string.eggCategoryC3)
val eggBoilingTypeText = listOf(R.string.boilingSmall, R.string.boilingMedium, R.string.boilingLarge)
val eggPotSizeText = listOf(R.string.potSmall, R.string.potMedium, R.string.potLarge)

val MainFont = FontFamily(
    Font(R.font.main_halvar_breit)
)

val MainBoldFont = FontFamily(
    Font(R.font.bold_halvar_breit)
)

fun calculate(viewModel: MainViewModel): Int {

    val baseTime = 210
    var res = baseTime

    when (viewModel.eggCategory.value) {
        "C-2" -> res += 25
        "C-1" -> res += 50
        "C-0" -> res += 75
        "B" -> res += 100
    }

    when (viewModel.boilingType.value) {
        "в “Мешочек”" -> res += 50
        "Вкрутую" -> res += 100
    }

    when (viewModel.potType.value) {
        "Средняя" -> res += 50
        "Большая" -> res += 100
    }

    return res
}


@HiltViewModel
class MainViewModel @Inject constructor() : ViewModel() {

    private val _eggCategory = MutableLiveData("")
    val eggCategory: LiveData<String> get() = _eggCategory

    fun setEggCategory(eggCategoryInput: String) {
        _eggCategory.value = eggCategoryInput
    }


    private val _boilingType = MutableLiveData("")
    val boilingType: LiveData<String> get() = _boilingType

    fun setBoilingType(boilingTypeInput: String) {
        _boilingType.value = boilingTypeInput
    }


    private val _potType = MutableLiveData("")
    val potType: LiveData<String> get() = _potType

    fun setPotType(potTypeInput: String) {
        _potType.value = potTypeInput
    }

}


@HiltViewModel
class TimerViewModel @Inject constructor() : ViewModel() {

    private val _dataForDisplay = MutableLiveData("")
    val dataForDisplay: LiveData<String> get() = _dataForDisplay

    fun setDataForDisplay(dataForDisplayInput: String) {
        _dataForDisplay.value = dataForDisplayInput
    }

    private val _timerDone = MutableLiveData(false)
    val timerDone: LiveData<Boolean> get() = _timerDone

    fun setTimerDone(timerDoneInput: Boolean) {
        _timerDone.value = timerDoneInput
    }

}

@Composable
fun BackgroundImage() {
    Image(
        modifier = Modifier
            .fillMaxSize(),
        painter = painterResource(id = R.drawable.background_image),
        contentDescription = stringResource(id = R.string.bgImageDesc),
        contentScale = ContentScale.FillBounds
    )
}

@Composable
fun TimerScreen(navController: NavController, time: String?) {
    BackgroundImage()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(start = 16.dp, end = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp, Alignment.CenterVertically)
    ) {

        InstructionCard()

        Timer(time?: stringResource(id = R.string.error))


        BackButton(navController)

    }
}

@Composable
fun Timer(time:String, timerViewModel: TimerViewModel = hiltViewModel()) {

    val dataForDisplay = rememberSaveable {
        mutableStateOf("")
    }

    timerViewModel.dataForDisplay.observe(LocalLifecycleOwner.current) {
        dataForDisplay.value = it
    }


    Box(
        modifier = Modifier.fillMaxWidth(),
        contentAlignment = Alignment.Center
    ) {
        Canvas(
            modifier = Modifier
                .size(260.dp)
                .background(color = buttonColorPrimary, shape = RoundedCornerShape(50))
        ) {}

        Canvas(
            modifier = Modifier
                .size(220.dp)
                .background(color = buttonColorSecondary, shape = RoundedCornerShape(50))
        ) {}

        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {

            val isVisible = rememberSaveable {
                mutableStateOf(false)
            }

            if (isVisible.value) {
                Text(
                    text = dataForDisplay.value,
                    fontSize = 38.sp,
                    color = buttonColorPrimary,
                    fontFamily = MainBoldFont
                )
            }

            val context = LocalContext.current

            if (!isVisible.value) {
                IconButton(
                    modifier = Modifier.padding(top = 8.dp),
                    onClick = {
                        isVisible.value = true
                        if (time.toIntOrNull()==null) {
                            timer(0, context, timerViewModel)
                        } else {
                            timer(time.toInt(), context, timerViewModel)
                        }

                    }
                ) {
                    Icon(
                        modifier = Modifier.size(36.dp),
                        painter = painterResource(id = R.drawable.play_icon),
                        contentDescription = stringResource(id = R.string.playButtonDesc),
                        tint = buttonColorPrimary
                    )
                }
            }

        }
    }
}


@Composable
fun InstructionCard() {
    Card(
        modifier = Modifier
            .fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = buttonColorSecondary
        ),
        border = BorderStroke(width = 1.dp, textColorSecondary)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp)
        ) {
            Text(
                modifier = Modifier.padding(bottom = 10.dp),
                text = stringResource(id = R.string.instruction),
                fontSize = 12.sp,
                color = textColorSecondary,
                fontFamily = MainFont
            )

            Text(
                text = stringResource(id = R.string.instructionText),
                color = textColorSecondary,
                fontSize = 14.sp,
                fontFamily = MainFont,
                fontWeight = FontWeight.Bold
            )
        }
    }
}


@Composable
fun BackButton(navController: NavController) {
    Button(
        modifier = Modifier.fillMaxWidth(),
        colors = ButtonDefaults.buttonColors(backgroundColor = buttonColorPrimary),
        shape = RoundedCornerShape(12.dp),
        onClick = {
            navController.navigate(Screen.MainScreen.route){
                popUpTo(0)
            }
        }
    ) {
        Text(
            text = stringResource(id = R.string.buttonBackText),
            color = buttonColorSecondary,
            fontSize = 12.sp,
            fontFamily = MainBoldFont,
            fontWeight = FontWeight.Bold
        )
    }
}

@Composable
fun MainEggScreen(navController: NavController) {

    BackgroundImage()


    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(start = 16.dp, end = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp, Alignment.CenterVertically),

        ) {
        MainText()

        EggCategory()

        BoilingType()

        PotSize()

        CalculateButton(navController)
    }

}


@OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
@Composable
fun PotSize(viewModel: MainViewModel = hiltViewModel()) {

    Column() {

        Text(
            text = stringResource(id = R.string.potSize),
            fontSize = 14.sp,
            color = textColorSecondary,
            fontFamily = MainFont
        )

        val selectedItem = rememberSaveable {
            mutableStateOf("")
        }

        FlowRow(
            modifier = Modifier
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {

            eggPotSizeText.forEach { item ->

                val text = stringResource(id = item)

                FilterChip(
                    selected = (text == selectedItem.value),
                    onClick = {
                        selectedItem.value = text
                        viewModel.setPotType(text)
                    },
                    label = {
                        Text(
                            text = text,
                            color = if (selectedItem.value == text) buttonColorSecondary else buttonColorPrimary,
                            fontSize = 12.sp,
                            fontFamily = MainFont,
                            fontWeight = FontWeight.Bold,
                        )
                    },
                    colors = FilterChipDefaults.filterChipColors(
                        containerColor = Color.Transparent,
                        selectedContainerColor = buttonColorPrimary
                    ),
                    border = FilterChipDefaults.filterChipBorder(
                        borderColor = buttonColorPrimary,
                        borderWidth = 1.dp
                    ),
                    shape = RoundedCornerShape(12.dp)
                )

            }
        }

    }
}

@Composable
fun MainText() {
    Text(
        modifier = Modifier.padding(bottom = 20.dp),
        text = stringResource(id = R.string.mainText),
        fontFamily = MainBoldFont,
        fontSize = 36.sp,
        fontWeight = FontWeight.Bold,
        color = textColorPrimary
    )
}

@OptIn(ExperimentalLayoutApi::class, ExperimentalMaterial3Api::class)
@Composable
fun EggCategory(viewModel: MainViewModel = hiltViewModel()) {

    Column() {
        Text(
            text = stringResource(id = R.string.eggCategory),
            fontSize = 14.sp,
            color = textColorSecondary,
            fontFamily = MainFont
        )


        val selectedItem = rememberSaveable {
            mutableStateOf("")
        }

        FlowRow(
            modifier = Modifier
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {

            eggCategoryText.forEach { item ->

                val text = stringResource(id = item)

                FilterChip(
                    selected = (text == selectedItem.value),
                    onClick = {
                        selectedItem.value = text
                        viewModel.setEggCategory(text)
                    },
                    label = {
                        Text(
                            text = text,
                            color = if (selectedItem.value==text) buttonColorSecondary else buttonColorPrimary,
                            fontSize = 12.sp,
                            fontFamily = MainFont,
                            fontWeight = FontWeight.Bold,
                        )
                    },
                    colors = FilterChipDefaults.filterChipColors(
                        containerColor = Color.Transparent,
                        selectedContainerColor = buttonColorPrimary
                    ),
                    border = FilterChipDefaults.filterChipBorder(
                        borderColor = buttonColorPrimary,
                        borderWidth = 1.dp
                    ),
                    shape = RoundedCornerShape(12.dp)
                )

            }
        }

    }
}

@Composable
fun CalculateButton(navController: NavController, viewModel: MainViewModel = hiltViewModel()) {
    val context = LocalContext.current

    Button(
        modifier = Modifier.fillMaxWidth(),
        colors = ButtonDefaults.buttonColors(backgroundColor = buttonColorPrimary),
        shape = RoundedCornerShape(12.dp),
        onClick = {
            if (viewModel.eggCategory.value?.isEmpty() == true ||
                viewModel.boilingType.value?.isEmpty() == true ||
                viewModel.potType.value?.isEmpty() == true
            ) {
                Toast.makeText(context, R.string.textForToast, Toast.LENGTH_SHORT).show()
            } else {
                val time = calculate(viewModel)
                navController.navigate(Screen.TimerScreen.createRoute(time.toString()))
            }
        }
    ) {
        Text(
            text = stringResource(id = R.string.buttonCalculate),
            color = buttonColorSecondary,
            fontSize = 12.sp,
            fontFamily = MainBoldFont,
            fontWeight = FontWeight.Bold
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
@Composable
fun BoilingType(viewModel: MainViewModel = hiltViewModel()) {
    Column() {
        Text(
            text = stringResource(id = R.string.boilingTypeText),
            fontSize = 14.sp,
            color = textColorSecondary,
            fontFamily = MainFont
        )

        val selectedItem = remember {
            mutableStateOf("")
        }

        FlowRow(
            modifier = Modifier
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {

            eggBoilingTypeText.forEach { item ->

                val text = stringResource(id = item)

                FilterChip(
                    selected = (text == selectedItem.value),
                    onClick = {
                        selectedItem.value = text
                        viewModel.setBoilingType(text)
                    },
                    label = {
                        Text(
                            text = text,
                            color = if (selectedItem.value==text) buttonColorSecondary else buttonColorPrimary,
                            fontSize = 12.sp,
                            fontFamily = MainFont,
                            fontWeight = FontWeight.Bold,
                        )
                    },
                    colors = FilterChipDefaults.filterChipColors(
                        containerColor = Color.Transparent,
                        selectedContainerColor = buttonColorPrimary
                    ),
                    border = FilterChipDefaults.filterChipBorder(
                        borderColor = buttonColorPrimary,
                        borderWidth = 1.dp
                    ),
                    shape = RoundedCornerShape(12.dp)
                )

            }
        }

    }
}

fun updateTime(context: Context, viewModel: TimerViewModel, secondsForTimer: Int) {

    val currentDate = Calendar.getInstance()
    val eventDate = Calendar.getInstance()

    eventDate[Calendar.SECOND] += secondsForTimer

    val diff = eventDate.timeInMillis - currentDate.timeInMillis
    if (diff>0) {
        val minutes = diff / (1000 * 60) % 60
        val seconds = (diff / 1000) % 60

        viewModel.setDataForDisplay(context.getString(R.string.time, "$minutes", "$seconds"))
    } else {
        ringtone(context)
        viewModel.setTimerDone(true)
        viewModel.setDataForDisplay(context.getString(R.string.time, "0", "0"))
    }

}

private val handler = Handler(Looper.getMainLooper())

fun timer(time: Int, context: Context, viewModel: TimerViewModel) {

    var seconds = time

    handler.post(object : Runnable {
        override fun run() {
            handler.postDelayed(this, 1000)
            updateTime(context, viewModel, seconds--)
            if (viewModel.timerDone.value == true) {
                handler.removeCallbacks(this)
            }
        }

    })
}

fun ringtone(context: Context) {
    CoroutineScope(Dispatchers.Default).launch {
        val notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
        val ringtone = RingtoneManager.getRingtone(context, notification)
        ringtone.play()
        delay(10000)
        ringtone.stop()
    }
}

@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screen.MainScreen.route) {


        composable(Screen.MainScreen.route) {
            MainEggScreen(navController)
        }

        composable(
            route = Screen.TimerScreen.route,
            arguments = Screen.TimerScreen.arguments
        ) { backStackEntry ->
            TimerScreen(navController, backStackEntry.arguments?.getString("timerTime"))
        }

    }
}


sealed class Screen(val route: String, val arguments: List<NamedNavArgument>) {
    object MainScreen : Screen(route = "main_screen", arguments = listOf())
    object TimerScreen : Screen(route = "timer_screen/{timerTime}", arguments = listOf(navArgument("timerTime") { type = NavType.StringType })) {
        fun createRoute(timerTime: String) = "timer_screen/$timerTime"
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    Navigation()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="eggCategoryB">B</string>
    <string name="eggCategoryC0">C-0</string>
    <string name="eggCategoryC1">C-1</string>
    <string name="eggCategoryC2">C-2</string>
    <string name="eggCategoryC3">C-3</string>

    <string name="boilingSmall">Всмятку</string>
    <string name="boilingMedium">в “Мешочек”</string>
    <string name="boilingLarge">Вкрутую</string>

    <string name="potSmall">Маленькая</string>
    <string name="potMedium">Средняя</string>
    <string name="potLarge">Большая</string>

    <string name="bgImageDesc">background image</string>
    <string name="playButtonDesc">start</string>
    <string name="error">error</string>
    <string name="instruction">Инструкция:</string>
    <string name="instructionText">Поставьте кастрюлю с водой на плиту, дождитесь пока вода закипит, после чего запустите таймер и варите яйца до окончания таймера</string>
    <string name="buttonBackText">Вернуться назад</string>
    <string name="potSize">Размер кастрюли:</string>
    <string name="mainText">Калькулятор\nварки яиц</string>
    <string name="eggCategory">Категория яиц:</string>
    <string name="textForToast">Отметьте все</string>
    <string name="buttonCalculate">Вычислить</string>
    <string name="boilingTypeText">Тип варки:</string>

    <string name="time">%1$s:%2$s</string>
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

    implementation Dependencies.compose_navigation
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
