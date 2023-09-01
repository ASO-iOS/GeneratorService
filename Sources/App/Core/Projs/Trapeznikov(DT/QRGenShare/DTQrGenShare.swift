//
//  File.swift
//  
//
//  Created by admin on 9/1/23.
//

import Foundation

struct DTQrGenShare: SFFileProviderProtocol {
    static var fileName: String = ""
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return ""
    }
    
    
    static func mainFragmentCMF(_ mainData: MainData) -> ANDMainFragmentCMF {
        ANDMainFragmentCMF(content: """
package \(mainData.packageName).presentation.fragments.main_fragment

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.core.content.FileProvider
import androidx.core.graphics.drawable.toBitmap
import androidx.fragment.app.Fragment
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import coil.compose.SubcomposeAsyncImage
import \(mainData.packageName).R
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream
import javax.inject.Inject

@AndroidEntryPoint
class MainFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setContent {
                MainScreen()
            }
        }
    }
}

@Composable
fun MainScreen() {
    MaterialTheme {
        QrCodeScreen()
    }
}

@HiltViewModel
class QrCodeViewModel @Inject constructor() : ViewModel() {

    private val _state = MutableStateFlow("")
    val state = _state.asStateFlow()

    private val url = "https://api.qrserver.com/v1/create-qr-code/?size=600x600&data="

    fun generateQrCode(data: String) {
        _state.value = url + data
    }
}

val backColorPrimary = Color(0xFF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(mainData.uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(mainData.uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF"))

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun QrCodeScreen(
    viewModel: QrCodeViewModel = hiltViewModel()
) {
    val urlState = viewModel.state.collectAsState()
    val keyboardController = LocalSoftwareKeyboardController.current
    Box(
        modifier = Modifier
            .fillMaxSize()

            .background(backColorPrimary)
            .padding(dimensionResource(id = R.dimen.main_padding))
    ) {
        Column(
            modifier = Modifier
                .align(Alignment.TopCenter)
                .background(backColorPrimary)
        ) {
            val textFieldState = remember { mutableStateOf("") }
            OutlinedTextField(
                value = textFieldState.value,
                onValueChange = {
                    textFieldState.value = it
                },
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = textColorPrimary,
                    cursorColor = buttonColorPrimary,
                    focusedBorderColor = buttonColorPrimary,
                    focusedContainerColor = backColorPrimary
                ),
                modifier = Modifier.fillMaxWidth(),
                placeholder = { Text(stringResource(R.string.input_a_data)) }
            )
            Spacer(modifier = Modifier.height(8.dp))
            Button(
                onClick = {
                    if (textFieldState.value.isNotBlank()) {
                        keyboardController?.hide()
                        viewModel.generateQrCode(textFieldState.value)
                    }
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = buttonColorPrimary,
                    contentColor = buttonTextColorPrimary
                )
            ) {
                Text(text = stringResource(R.string.generate), color = buttonTextColorPrimary)
            }
        }

        if (urlState.value.isNotEmpty()) {
            ShowQrCode(modifier = Modifier.align(Alignment.Center), url = urlState.value)
        }
    }
}

@Composable
fun ShowQrCode(modifier: Modifier, url: String) {
    val context = LocalContext.current
    val drawable = remember { mutableStateOf<Drawable?>(null) }
    val clickState = remember { mutableStateOf(false) }

    LaunchedEffect(clickState.value) {
        if (clickState.value) {
            drawable.value?.let {
                context.shareImage(
                    context.getString(R.string.share_image_via),
                    it,
                    context.getString(R.string.qr_code)
                )
            }
        }
        clickState.value = false
    }
    Column(
        modifier = modifier.background(color = backColorPrimary),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        SubcomposeAsyncImage(
            model = url,
            contentDescription = stringResource(R.string.QR_code),
            loading = { CircularProgressIndicator(color = buttonColorPrimary) },
            error = {
                drawable.value = null
                Text(
                    text = stringResource(id = R.string.connection_lost),
                    modifier = Modifier.align(Alignment.Center),
                    color = textColorPrimary,
                    textAlign = TextAlign.Center
                )
            },
            onSuccess = {
                drawable.value = it.result.drawable
            }
        )
        if (drawable.value != null) {
            Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.main_margin)))
            Button(
                onClick = { clickState.value = true },
                modifier = Modifier.width(150.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = buttonColorPrimary,
                    contentColor = buttonTextColorPrimary
                )
            ) {
                Text(text = stringResource(R.string.share), color = buttonTextColorPrimary)
            }
        }
    }
}

suspend fun Context.shareImage(title: String, image: Drawable, filename: String) {
    withContext(Dispatchers.IO) {
        try {
            val outputFile = File(cacheDir, "$filename.png")
            val outPutStream = FileOutputStream(outputFile)
            image.toBitmap().compress(Bitmap.CompressFormat.PNG, 100, outPutStream)
            outPutStream.flush()
            outPutStream.close()
            withContext(Dispatchers.Main) {
                val uri = FileProvider.getUriForFile(
                    this@shareImage,
                    "\(mainData.packageName)" + ".provider",
                    outputFile
                )
                val shareIntent = Intent().apply {
                    action = Intent.ACTION_SEND
                    type = "image/png"
                    putExtra(Intent.EXTRA_STREAM, uri)
                }
                startActivity(Intent.createChooser(shareIntent, title))
            }
        } catch (e: Throwable) {
            withContext(Dispatchers.Main) {
                toast(e)
            }
        }
    }
}

fun Context.toast(throwable: Throwable) =
    throwable.message?.let { toast(it) } ?: toast(getString(R.string.unexpected_error))

fun Context.toast(message: String) {
    Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
}
""", fileName: "MainFragment.kt")
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        ANDData(
            mainFragmentData: ANDMainFragment(imports: "", content: ""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="connection_lost">Connection lost</string>
    <string name="unexpected_error">Unexpected error</string>
    <string name="input_a_data">Input a data</string>
    <string name="generate">Generate</string>
    <string name="share">Share</string>
    <string name="QR_code">QR code</string>
    <string name="qr_code">qr_code</string>
    <string name="share_image_via">Share image via</string>
"""),
            colorsData: ANDColorsData(additional: ""))
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
apply plugin: 'dagger.hilt.android.plugin'
apply plugin: 'kotlin-kapt'

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
    implementation Dependencies.coil_compose
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
    const val gradle = "8.1.0"
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
    const val coil = "2.4.0"
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
