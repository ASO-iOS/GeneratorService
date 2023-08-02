//
//  File.swift
//  
//
//  Created by admin on 02.08.2023.
//

import Foundation

struct VEPassGen: FileProviderProtocol {
    static var fileName: String = "VEPassGen.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.ClipData
import android.content.ClipboardManager
import android.os.Build
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Key
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.outlined.Numbers
import androidx.compose.material.icons.outlined.Pin
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FabPosition
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.FloatingActionButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
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
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.PassScreenComposeDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenComposeDestination
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import javax.inject.Inject

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)

@Composable
fun PassGeneratorTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

@Destination
@Composable
fun PassScreenCompose(
    viewModel: PassViewModel = hiltViewModel()
) {
    Scaffold(
        floatingActionButton = {
            InputFieldWithGenerateButton(
                onGeneratePassword = viewModel::generatePassword
            )
        },
        floatingActionButtonPosition = FabPosition.Center
    ) { paddings ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(bottom = paddings.calculateBottomPadding()),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            OptionalButtons(
                onUppercaseEnabled = { viewModel.uppercaseEnabled.value = it },
                onNumbersEnabled = { viewModel.numbersEnabled.value = it },
                onSymbolsEnabled = { viewModel.symbolsEnabled.value = it }
            )
            PasswordCard(
                state = viewModel.state.value
            )
        }
    }
}

@Composable
private fun InputFieldWithGenerateButton(
    onGeneratePassword: (length: Int) -> Unit
) {
    var passwordLength by remember { mutableStateOf("4") }
    val maxLength = 5

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        TextField(
            value = passwordLength,
            onValueChange = { newValue ->
                newValue.toIntOrNull()?.let {
                    if(newValue.length < maxLength)
                        passwordLength = newValue
                }
                if(newValue.isEmpty()) passwordLength = newValue
            },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
            singleLine = true,
            shape = RoundedCornerShape(20),
            textStyle = TextStyle(
                textAlign = TextAlign.Center,
                color = textColorPrimary
            ),
            colors = TextFieldDefaults.colors(
                focusedContainerColor = buttonColorPrimary,
                unfocusedContainerColor = buttonColorPrimary
            )
        )
        FloatingActionButton(
            modifier = Modifier.size(70.dp),
            onClick = {
                if(passwordLength.isNotEmpty())
                    onGeneratePassword(passwordLength.toInt())
            },
            containerColor = buttonColorPrimary,
            elevation = FloatingActionButtonDefaults.elevation(10.dp)
        ) {
            Icon(
                modifier = Modifier.size(30.dp),
                imageVector = Icons.Default.Key,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun PasswordCard(
    state: UiPassState
) {
    val context = LocalContext.current
    val clipboard = context.getSystemService(ClipboardManager::class.java)
    val defaultTitle = stringResource(id = R.string.default_title)
    var generatedPassword by remember { mutableStateOf(defaultTitle) }

    Card(
        modifier = Modifier
            .heightIn(min = 100.dp, max = 300.dp)
            .fillMaxWidth()
            .padding(10.dp),
        onClick = {
            val clip = ClipData.newPlainText("label", generatedPassword)
            clipboard.setPrimaryClip(clip)
            Toast.makeText(context, R.string.copied_message, Toast.LENGTH_SHORT).show()
        },
        elevation = CardDefaults.elevatedCardElevation(10.dp),
        colors = CardDefaults.cardColors(
            containerColor = buttonColorPrimary
        )
    ) {
        when(state) {
            is UiPassState.Loading -> CircularProgressIndicator(
                modifier = Modifier.align(Alignment.CenterHorizontally)
            )
            is UiPassState.Ready -> {
                generatedPassword = state.password
                Text(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(20.dp),
                    text = generatedPassword,
                    style = TextStyle(
                        letterSpacing = 15.sp,
                        fontSize = 18.sp,
                        lineHeight = 30.sp,
                        textAlign = TextAlign.Start
                    ),
                    color = textColorPrimary
                )
            }
            is UiPassState.Default -> Text(
                modifier = Modifier.padding(20.dp),
                text = generatedPassword,
                style = MaterialTheme.typography.titleLarge.copy(
                    letterSpacing = 15.sp,
                    fontSize = 18.sp,
                    lineHeight = 40.sp
                ),
                color = textColorPrimary
            )
            is UiPassState.Error -> {
                Toast.makeText(context, state.resId, Toast.LENGTH_SHORT).show()
            }
        }
    }
}

@Composable
private fun OptionalButtons(
    onUppercaseEnabled: (enabled: Boolean) -> Unit,
    onNumbersEnabled: (enabled: Boolean) -> Unit,
    onSymbolsEnabled: (enabled: Boolean) -> Unit
) {
    var uppercaseEnabled by remember { mutableStateOf(false) }
    var numbersEnabled by remember { mutableStateOf(false) }
    var symbolsEnabled by remember { mutableStateOf(false) }

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 10.dp, vertical = 20.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceAround
    ) {
        FloatingActionButton(
            modifier = Modifier.size(70.dp),
            onClick = {
                uppercaseEnabled = !uppercaseEnabled
                onUppercaseEnabled(uppercaseEnabled)
            },
            containerColor = if(!uppercaseEnabled) buttonColorPrimary else buttonColorSecondary,
            elevation = FloatingActionButtonDefaults.elevation(10.dp)
        ) {
            Text(text = "Тт", color = textColorPrimary, fontSize = 20.sp)
//            Icon(
//                modifier = Modifier.size(40.dp),
//                painter = painterResource(id = R.drawable.uppercase_icon),
//                contentDescription = null,
//                tint = textColorPrimary
//            )
        }
        FloatingActionButton(
            modifier = Modifier.size(70.dp),
            onClick = {
                numbersEnabled = !numbersEnabled
                onNumbersEnabled(numbersEnabled)
            },
            containerColor = if(!numbersEnabled) buttonColorPrimary else buttonColorSecondary,
            elevation = FloatingActionButtonDefaults.elevation(10.dp)
        ) {
            Icon(
                modifier = Modifier.size(30.dp),
                imageVector = Icons.Outlined.Pin,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
        FloatingActionButton(
            modifier = Modifier.size(70.dp),
            onClick = {
                symbolsEnabled = !symbolsEnabled
                onSymbolsEnabled(symbolsEnabled)
            },
            containerColor = if(!symbolsEnabled) buttonColorPrimary else buttonColorSecondary,
            elevation = FloatingActionButtonDefaults.elevation(10.dp)
        ) {
            Icon(
                modifier = Modifier.size(30.dp),
                imageVector = Icons.Outlined.Numbers,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@HiltViewModel
class PassViewModel @Inject constructor(

): ViewModel() {
    private  val symbols = "!@#$%^&*()_+=[]'/.,?|`~".toList()
    private val numbers = ('0'..'9').toList()
    private val upperLetters = ('A'..'Z').toList()
    private val lowerLetters = ('a'..'z').toList()

    private val _state = mutableStateOf<UiPassState>(UiPassState.Default)
    val state: State<UiPassState> = _state

    val numbersEnabled = mutableStateOf(false)
    val uppercaseEnabled = mutableStateOf(false)
    val symbolsEnabled = mutableStateOf(false)

    fun generatePassword(length: Int) {
        _state.value = UiPassState.Loading

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val allowedChars = mutableListOf<Char>().also { it.addAll(lowerLetters) }
                if(numbersEnabled.value) allowedChars.addAll(numbers)
                if(symbolsEnabled.value) allowedChars.addAll(symbols)
                if(uppercaseEnabled.value) allowedChars.addAll(upperLetters)

                val generated = (1..length)
                    .map { allowedChars.random() }
                    .joinToString("")

                _state.value = UiPassState.Ready(password = generated)
            } catch (e: Exception) {
                _state.value = UiPassState.Error(R.string.incorrect_argument)
            }
        }
    }
}

sealed class UiPassState {
    object Loading: UiPassState()
    object Default: UiPassState()
    class Ready(val password: String): UiPassState()
    class Error(val resId: Int): UiPassState()
}

@RootNavGraph(start = true)
@Destination
@Composable
fun SplashScreenCompose(
    navigator: DestinationsNavigator
) {
    LaunchedEffect(key1 = Unit) {
        delay(2000)
        navigator.navigate(PassScreenComposeDestination()) {
            popUpTo(SplashScreenComposeDestination) { inclusive = true }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = stringResource(id = R.string.app_name).uppercase(),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
        Icon(
            modifier = Modifier.size(200.dp),
            imageVector = Icons.Filled.Lock,
            contentDescription = null,
            tint = textColorPrimary
        )
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: """
        import androidx.compose.foundation.layout.fillMaxSize
        import androidx.compose.material3.MaterialTheme
        import androidx.compose.material3.Surface
        import androidx.compose.ui.Modifier
        import com.ramcosta.composedestinations.DestinationsNavHost
        """, content: """
            PassGeneratorTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    DestinationsNavHost(navGraph = NavGraphs.root)
                }
            }
        """), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
            <string name="copied_message">Copied!</string>
            <string name="generate">Generate</string>
            <string name="default_title">Click here for copy!</string>
            <string name="incorrect_argument">Incorrect number!</string>
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

plugins{
    id 'com.google.devtools.ksp' version '1.8.10-1.0.9'
}

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
            minifyEnabled false
            shrinkResources false
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
        dataBinding true
        viewBinding true
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
    implementation Dependencies.compose_system_ui_controller
    implementation Dependencies.compose_permissions
    implementation 'androidx.work:work-runtime-ktx:2.8.1'
    implementation 'androidx.navigation:navigation-fragment:2.6.0'
    implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
    implementation Dependencies.compose_destinations_core
    ksp Dependencies.compose_destinations_ksp
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
    const val hilt = "2.45"
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
    const val glide = "4.14.2"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "2.2.2"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"

    const val compose_destination = "1.8.42-beta"
    const val moshi = "1.15.0"

    const val kotlin_serialization = "1.5.1"
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

    const val compose_destinations_core = "io.github.raamcosta.compose-destinations:core:${Versions.compose_destination}"
    const val compose_destinations_ksp = "io.github.raamcosta.compose-destinations:ksp:${Versions.compose_destination}"

    const val moshi = "com.squareup.moshi:moshi-kotlin:${Versions.moshi}"

    const val kotlinx_serialization = "org.jetbrains.kotlinx:kotlinx-serialization-json:${Versions.kotlin_serialization}"
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
