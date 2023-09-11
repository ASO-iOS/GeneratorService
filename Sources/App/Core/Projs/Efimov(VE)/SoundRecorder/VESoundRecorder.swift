//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct VESoundRecorder: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.media.MediaRecorder
import android.os.Build
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Circle
import androidx.compose.material.icons.filled.FormatListBulleted
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Stop
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.google.accompanist.permissions.isGranted
import com.google.accompanist.permissions.rememberPermissionState
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.RecordListScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.VoiceRecorderScreenDestination
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.io.File
import java.time.LocalDateTime
import javax.inject.Inject

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
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
fun VoiceRecorderTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

class MediaPlayerProvider @Inject constructor(
    @ApplicationContext private val context: Context
) {
    private val recordFolder = "${context.filesDir}/"

    fun readFiles(): List<String> {
        return File(recordFolder).listFiles()?.filter { it.name.contains(".mp3") }?.map { it.name } ?: emptyList()
    }
}

class MediaRecorderProvider @Inject constructor(
    @ApplicationContext private val context: Context
) {
    private var mediaRecorder: MediaRecorder

    init {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
            mediaRecorder = MediaRecorder(context)
        else
            mediaRecorder = MediaRecorder()
    }

    fun startRecording() = with(mediaRecorder){
        setAudioSource(MediaRecorder.AudioSource.MIC)
        setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
        setOutputFile(File("${context.filesDir}/${LocalDateTime.now()}.mp3"))
        prepare()
        start()
    }

    fun stopRecording() = with(mediaRecorder){
        stop()
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Destination
@Composable
fun RecordListScreen(
    viewModel: RecordListViewModel = hiltViewModel(),
    navigator: DestinationsNavigator
) {
    val state = viewModel.uiState.collectAsState().value

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        modifier = Modifier.padding(20.dp),
                        text = stringResource(id = R.string.records_list_title),
                        style = MaterialTheme.typography.titleLarge,
                        color = textColorPrimary
                    )
                },
                navigationIcon = {
                    IconButton(onClick = navigator::popBackStack) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = null,
                            tint = textColorPrimary
                        )
                    }
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = backColorPrimary
                )
            )
        },
        containerColor = backColorPrimary
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(it),
            contentAlignment = Alignment.Center
        ) {
            when(state) {
                is UiRecordListState.NoItems -> Text(text = "No items", color = textColorPrimary)
                is UiRecordListState.Loading -> CircularProgressIndicator(color = textColorPrimary)
                is UiRecordListState.Items -> RecordList(records = state.recordList)
            }
        }
    }
}

@Composable
private fun RecordList(
    records: List<String>
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp),
        contentPadding = PaddingValues(10.dp)
    ) {
        items(records) { record ->
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp)
            ) {
                Text(
                    modifier = Modifier.padding(20.dp),
                    text = record,
                    style = MaterialTheme.typography.titleLarge,
                    color = textColorPrimary
                )
            }
        }
    }
}

@HiltViewModel
class RecordListViewModel @Inject constructor(
    private val mediaPlayerProvider: MediaPlayerProvider
): ViewModel() {

    private val _uiState = MutableStateFlow<UiRecordListState>(UiRecordListState.Loading)
    val uiState = _uiState.asStateFlow()

    init {
        viewModelScope.launch {
            val files = mediaPlayerProvider.readFiles()
            if(files.isNotEmpty()) {
                _uiState.value = UiRecordListState.Items(files)
            } else
                _uiState.value = UiRecordListState.NoItems
        }
    }
}

sealed class UiRecordListState {
    object Loading: UiRecordListState()
    object NoItems: UiRecordListState()
    class Items(val recordList: List<String>): UiRecordListState()
}

const val SPLASH_DELAY = 3000L
const val ANIMATION_DURATION = 2000
@RootNavGraph(start = true)
@Destination
@Composable
fun SplashScreen(
    navigator: DestinationsNavigator
) {
    val infiniteTransition = rememberInfiniteTransition(label = "")
    val alphaAnimation = infiniteTransition.animateFloat(
        initialValue = 1f,
        targetValue = 0f,
        animationSpec = infiniteRepeatable(
            animation = tween(ANIMATION_DURATION),
        ),
        label = ""
    )

    LaunchedEffect(key1 = Unit) {
        delay(SPLASH_DELAY)
        navigator.navigate(VoiceRecorderScreenDestination()) {
            popUpTo(SplashScreenDestination) { inclusive = true }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
    ) {
        Icon(
            modifier = Modifier
                .size(100.dp)
                .graphicsLayer { alpha = alphaAnimation.value },
            imageVector = Icons.Default.Circle,
            contentDescription = null,
            tint = primaryColor
        )
        Text(
            text = stringResource(id = R.string.app_name),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
    }
}

@OptIn(ExperimentalPermissionsApi::class)
@Destination
@Composable
fun VoiceRecorderScreen(
    viewModel: VoiceRecorderViewModel = hiltViewModel(),
    navigator: DestinationsNavigator
) {
    var isRecording by remember { mutableStateOf(false) }

    val infiniteTransition = rememberInfiniteTransition(label = "")
    val alphaAnimation = infiniteTransition.animateFloat(
        initialValue = 1f,
        targetValue = if(isRecording) 0f else 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(2000),
        ),
        label = ""
    )

    val microPermission = rememberPermissionState(
        permission = android.Manifest.permission.RECORD_AUDIO
    )

    LaunchedEffect(key1 = Unit) {
        if(!microPermission.status.isGranted)
            microPermission.launchPermissionRequest()

    }

    if(microPermission.status.isGranted) {
        Scaffold(
            bottomBar = {
                BottomActionsBar(
                    isRecording = isRecording,
                    onRecordTap = {
                        isRecording = !isRecording
                        if(isRecording)
                            viewModel.startRecording()
                        else
                            viewModel.stopRecording()
                    },
                    onListTap = { navigator.navigate(RecordListScreenDestination()) }
                )
            },
            containerColor = backColorPrimary
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(it),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(20.dp, Alignment.CenterVertically)
            ) {
                Icon(
                    modifier = Modifier
                        .size(100.dp)
                        .graphicsLayer { alpha = alphaAnimation.value },
                    imageVector = Icons.Default.Circle,
                    contentDescription = null,
                    tint = primaryColor
                )

                Text(
                    text = if(isRecording) stringResource(id = R.string.recording_message) else "",
                    style = MaterialTheme.typography.titleLarge,
                    color = textColorPrimary,
                    fontSize = 30.sp
                )
            }
        }
    }
}

@Composable
private fun BottomActionsBar(
    isRecording: Boolean,
    onRecordTap: () -> Unit,
    onListTap: () -> Unit
) {
    BottomAppBar(
        floatingActionButton = {
            FloatingActionButton(
                onClick = onRecordTap,
                containerColor = buttonColorPrimary
            ) {
                Icon(
                    imageVector = if(isRecording) Icons.Default.Stop else Icons.Default.PlayArrow,
                    contentDescription = null,
                    tint = textColorPrimary
                )
            }
        },
        actions = {
            IconButton(onClick = onListTap) {
                Icon(
                    imageVector = Icons.Default.FormatListBulleted,
                    contentDescription = null,
                    tint = textColorPrimary
                )
            }
        },
        containerColor = backColorPrimary
    )
}

@HiltViewModel
class VoiceRecorderViewModel @Inject constructor(
    private val mediaRecorderProvider: MediaRecorderProvider
): ViewModel() {

    fun startRecording() {
        mediaRecorderProvider.startRecording()
    }

    fun stopRecording() {
        mediaRecorderProvider.stopRecording()
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
    VoiceRecorderTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            DestinationsNavHost(navGraph = NavGraphs.root)
        }
    }
"""),
                       mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
                       themesData: ANDThemesData(isDefault: true, content: ""),
                       stringsData: ANDStringsData(additional: """
    <string name="recording_message">Recording…</string>
    <string name="save_title">Save record</string>
    <string name="save">Save</string>
    <string name="cancel">Cancel</string>
    <string name="records_list_title">Your records</string>
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

plugins {
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
            minifyEnabled true
            shrinkResources true
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
    implementation Dependencies.navigation_fragment
    implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
    ksp Dependencies.compose_destinations_ksp
    implementation Dependencies.compose_destinations_core
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
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
    const val minsdk = 26
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
    const val datastore_preferences = "1.0.0"
    const val navigation_fragment = "2.6.0"
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

    const val data_store = "androidx.datastore:datastore-preferences:${Versions.datastore_preferences}"
    const val navigation_fragment = "androidx.navigation:navigation-fragment:${Versions.navigation_fragment}"

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
