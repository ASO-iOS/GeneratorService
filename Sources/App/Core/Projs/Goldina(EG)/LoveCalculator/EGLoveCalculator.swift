//
//  File.swift
//  
//
//  Created by admin on 11.08.2023.
//

import Foundation

struct EGLoveCalculator: CMFFileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.TextField
import androidx.compose.material.TextFieldDefaults
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Favorite
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DatePickerDefaults
import androidx.compose.material3.DatePickerState
import androidx.compose.material3.DisplayMode
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.material3.rememberDatePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringArrayResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.util.Calendar
import java.util.Collections
import javax.inject.Inject


val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

private val LightColorPalette = lightColorScheme(
    primary = primaryColor,
    background = backColorPrimary,
)

@Composable
fun LoveCalcTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorPalette,
        typography = Typography,
        content = content
    )
}

val Typography = Typography(
    displayLarge = TextStyle(
        fontFamily = FontFamily.SansSerif,
        fontWeight = FontWeight.W800,
        fontSize = 50.sp,
        lineHeight = 40.sp,
        letterSpacing = 0.4.sp,
    ),
    displayMedium = TextStyle(
        fontFamily = FontFamily.SansSerif,
        fontWeight = FontWeight.W600,
        fontSize = 20.sp,
        lineHeight = 20.sp,
        letterSpacing = 0.4.sp,
    ),
    displaySmall = TextStyle(
        fontFamily = FontFamily.SansSerif,
        fontWeight = FontWeight.Light,
        fontSize = 15.sp,
        lineHeight = 15.sp,
    )
)

@Composable
fun MainScreen(navController: NavHostController) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(30.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        val transition = rememberInfiniteTransition()

        val scale by transition.animateFloat(
            initialValue = 1f,
            targetValue = 1.5f,
            animationSpec = infiniteRepeatable(
                animation = tween(durationMillis = 1000),
                repeatMode = RepeatMode.Reverse
            )
        )
        Icon(
            imageVector = Icons.Outlined.Favorite,
            contentDescription = "Favorite",
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier
                .scale(scale = scale)
                .size(size = 100.dp)
        )

        CustomButton(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 100.dp),
            text = stringResource(R.string.btn_date)
        ) {
            navController.navigate(Screens.routeDate)
        }
        CustomButton(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 20.dp),
            text = stringResource(R.string.btn_name)
        ) {
            navController.navigate(Screens.routeName)
        }
    }
}

@ExperimentalMaterial3Api
@Composable
fun ByDateScreen(dateViewModel: DateViewModel = hiltViewModel()) {
    val calendar = Calendar.getInstance()
    calendar.set(1990, 0, 22)
    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(30.dp)
    ) {
        val datePickerStateFirst = rememberDatePickerState(
            initialSelectedDateMillis = calendar.timeInMillis,
            initialDisplayMode = DisplayMode.Input
        )
        val datePickerStateSecond = rememberDatePickerState(
            initialSelectedDateMillis = calendar.timeInMillis,
            initialDisplayMode = DisplayMode.Input
        )
        Column(
            modifier = Modifier.align(Alignment.TopCenter),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Top
        ) {

            CustomDatePicker(datePickerStateFirst, stringResource(R.string.headline_first))
            CustomDatePicker(datePickerStateSecond, stringResource(R.string.headline_second))
            val result = dateViewModel.valueLove.collectAsState().value
            if (result > 0) TextResult(text = stringArrayResource(id = R.array.result_description)[result - 1])
        }

        FloatingActionButton(
            modifier = Modifier
                .fillMaxWidth()
                .align(alignment = Alignment.BottomCenter),
            containerColor = MaterialTheme.colorScheme.primary,
            contentColor = buttonTextColorPrimary,
            onClick = {
                val dateFirst = datePickerStateFirst.selectedDateMillis ?: 0
                val dateSecond = datePickerStateSecond.selectedDateMillis ?: 0
                if (dateFirst > 0 && dateSecond > 0) {
                    dateViewModel.setDates(dateFirst, dateSecond)
                    dateViewModel.onEvent(CalculatorEvent.OnCalculateClick)
                }
            }
        ) {
            Text(text = stringResource(R.string.btn_calculate))
        }


    }

}

@Composable
fun ByNameScreen(nameViewModel: NameViewModel = hiltViewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(30.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(30.dp)
        ) {

            Column(
                modifier = Modifier.align(Alignment.TopCenter),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Top
            ) {
                InputRow(
                    label = stringResource(R.string.label_name_first),
                    txtField = nameViewModel.nameFirst,
                    inputType = KeyboardType.Text,
                    onValueChange = nameViewModel::onNameFirstEnter
                )

                InputRow(
                    label = stringResource(R.string.label_name_second),
                    txtField = nameViewModel.nameSecond,
                    inputType = KeyboardType.Text,
                    onValueChange = nameViewModel::onNameSecondEnter
                )

                val result = nameViewModel.valueLove.collectAsState().value
                if (result > 0) TextResult(text = stringArrayResource(id = R.array.result_description)[result - 1])
            }

            FloatingActionButton(
                modifier = Modifier
                    .fillMaxWidth()
                    .align(alignment = Alignment.BottomCenter),
                containerColor = MaterialTheme.colorScheme.primary,
                contentColor = buttonTextColorPrimary,
                onClick = {
                    nameViewModel.onEvent(CalculatorEvent.OnCalculateClick)
                }
            ) {
                Text(text = stringResource(R.string.btn_calculate))
            }
        }
    }
}

@Composable
fun CustomButton(modifier: Modifier, text: String, onClick: () -> Unit) {
    OutlinedButton(
        modifier = modifier,
        shape = RoundedCornerShape(20.dp),
        border = BorderStroke(width = 2.dp, color = MaterialTheme.colorScheme.primary),
        colors = ButtonDefaults.buttonColors(
            containerColor = MaterialTheme.colorScheme.background,
            contentColor = MaterialTheme.colorScheme.primary
        ),
        onClick = onClick
    ) {
        Text(
            text = text,
            style = MaterialTheme.typography.displayMedium
        )
    }
}

@ExperimentalMaterial3Api
@Composable
fun CustomDatePicker(datePickerState: DatePickerState, headText: String) {
    DatePicker(
        title = null,
        headline = {
            Text(text = headText, fontSize = 20.sp)
        },
        state = datePickerState,
        showModeToggle = false,
        colors = DatePickerDefaults.colors(
            containerColor = MaterialTheme.colorScheme.background,
            headlineContentColor = MaterialTheme.colorScheme.primary,
            subheadContentColor = MaterialTheme.colorScheme.primary,
        )
    )
}

@Composable
fun InputRow(
    label: String,
    txtField: String,
    inputType: KeyboardType,
    onValueChange: (String) -> Unit,
) {
    TextField(
        modifier =
        Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp)
            .border(
                BorderStroke(
                    width = 2.dp,
                    color = MaterialTheme.colorScheme.primary
                ),
                shape = RoundedCornerShape(50.dp)
            ),
        colors = TextFieldDefaults.textFieldColors(
            textColor = surfaceColor,
            cursorColor = MaterialTheme.colorScheme.primary,
            backgroundColor = MaterialTheme.colorScheme.background,
            focusedIndicatorColor = MaterialTheme.colorScheme.background,
            unfocusedIndicatorColor = MaterialTheme.colorScheme.background
        ),
        textStyle = MaterialTheme.typography.displayMedium,
        placeholder = { Text(text = label) },
        value = txtField,
        keyboardOptions = KeyboardOptions(keyboardType = inputType),
        onValueChange = onValueChange
    )
}

@Composable
fun TextResult(text: String) {
    Text(
        modifier = Modifier.padding(vertical = 60.dp),
        text = text,
        style = MaterialTheme.typography.displayMedium,
        color = MaterialTheme.colorScheme.primary,
        textAlign = TextAlign.Center
    )
}

@ExperimentalMaterial3Api
@Composable
fun Navigation() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screens.MainScreen.route) {

        composable(route = Screens.MainScreen.route) {
            MainScreen(navController)
        }

        composable(route = Screens.ByDateScreen.route)
        {
            ByDateScreen()
        }

        composable(route = Screens.ByNameScreen.route)
        {
            ByNameScreen()
        }
    }

}

sealed class Screens(val route: String) {
    companion object {
        const val routeMain = "main_screen"
        const val routeDate = "date_screen"
        const val routeName = "name_screen"
    }

    object MainScreen : Screens(route = routeMain)

    object ByDateScreen : Screens(route = routeDate)

    object ByNameScreen : Screens(route = routeName)
}

@ExperimentalMaterial3Api
@HiltViewModel
class DateViewModel @Inject constructor() : ViewModel() {

    private val _valueLove =
        MutableStateFlow(0)
    val valueLove = _valueLove.asStateFlow()

    private var dateFirst by mutableStateOf("")
    private var dateSecond by mutableStateOf("")

    fun setDates(dateFirst: Long, dateSecond: Long) {
        this.dateFirst = dateFirst.toDateString()
        this.dateSecond = dateSecond.toDateString()
    }

    fun onEvent(event: CalculatorEvent) {
        when (event) {
            CalculatorEvent.OnCalculateClick -> {
                viewModelScope.launch {
                    _valueLove.value = calculateByDate()
                }
            }
        }
    }

    private fun calculateByDate(): Int {
        val commonList = dateFirst + dateSecond
        var commonSum = 0
        commonList.forEach {
            commonSum += it.toString().toInt()
        }
        while (commonSum > 9) {
            commonSum = commonSum / 10 + commonSum % 10
        }
        return commonSum
    }

}

@HiltViewModel
class NameViewModel @Inject constructor() : ViewModel() {

    private val _valueLove =
        MutableStateFlow(0)
    val valueLove = _valueLove.asStateFlow()

    var nameFirst by mutableStateOf("")
        private set

    var nameSecond by mutableStateOf("")
        private set

    fun onNameFirstEnter(name: String) {
        nameFirst = name
    }

    fun onNameSecondEnter(name: String) {
        nameSecond = name
    }

    fun onEvent(event: CalculatorEvent) {
        when (event) {
            CalculatorEvent.OnCalculateClick -> {
                viewModelScope.launch {
                    if (nameFirst.isNotEmpty() && nameSecond.isNotEmpty()) {
                        _valueLove.value = calculateByName()
                    }
                }
            }
        }
    }

    private fun calculateByName(): Int {
        val commonList = nameFirst.lowercase() + nameSecond.lowercase()
        val distinctList = commonList.toSet()
        var commonSum = 0
        distinctList.forEach {
            commonSum += Collections.frequency(commonList.toList(), it)
        }
        while (commonSum > 9) {
            commonSum = commonSum / 10 + commonSum % 10
        }
        return commonSum
    }
}

sealed class CalculatorEvent {
    object OnCalculateClick : CalculatorEvent()
}

fun Long.toDateString(): String {
    val calendar = Calendar.getInstance()
    calendar.timeInMillis = this
    return String.format(
        "%s%s%s",
        calendar.get(Calendar.DAY_OF_MONTH),
        calendar.get(Calendar.MONTH),
        calendar.get(Calendar.YEAR)
    )
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="btn_date">By dates of birth</string>
    <string name="btn_name">By your names</string>
    <string name="headline_first">Your date of birth</string>
    <string name="headline_second">Partner\\'s date of birth</string>
    <string name="btn_calculate">Calculate</string>
    <string name="label_name_first">Your name</string>
    <string name="label_name_second">Partner\\'s name</string>

    <string-array name="result_description">
        <item>High compatibility. You will have regular quarrels, but if you discover the secret of harmony, then both will be happy. The union will be long and reliable, and the friendship will be strong, based not only on feelings, but also on trust, understanding and other positive qualities.</item>
        <item>Most likely, the main thing in your couple is a stable financial position of one of the partners. The more income, the stronger the relationship.</item>
        <item>You both love to chat and flirt. It won\\'t be boring, but it will be nervous and passionate. Don\\'t be surprised if cheating comes to the surface, especially if you manage to stay together for a long time. It\\'s easier for you to be friends than lovers.</item>
        <item>Everyone will insist on their own, try to be in charge. Some people like such roller coasters, but not everyone. However, if you learn to listen to each other, you can turn into one of the strongest alliances.</item>
        <item>Be sure — you are together for a long time. Mutual assistance is an absolute priority for both of you. If you want to get married, you will have a calm and friendly family, and if you have to end the relationship, you will remain good friends.</item>
        <item>The couple will turn out to be perfect, and friends will be inseparable — for life. And lapping is out of the question — such partners are literally created for each other, and friends are valued at their weight in gold.</item>
        <item>You are so different, but that\\'s exactly what attracts. Your relationship can be called strange and unconventional: one of the partners is more confident and willing to take risks, and the second is timid and tends to stability.</item>
        <item>You\\'d better stay friends. In such a relationship, one will always pull the blanket over himself, infringing on the interests of the second.</item>
    </string-array>
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
            signingConfig signingConfigs.debug
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
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
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import androidx.fragment.app.Fragment
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainFragment : Fragment() {
    @ExperimentalMaterial3Api
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setContent {
                LoveCalcTheme {
                    Box(
                        modifier = Modifier.fillMaxSize().background(MaterialTheme.colorScheme.background)
                    ){
                        Navigation()
                    }
                }
            }
        }
    }
}

""", fileName: "MainFragment.kt")
    }
}
