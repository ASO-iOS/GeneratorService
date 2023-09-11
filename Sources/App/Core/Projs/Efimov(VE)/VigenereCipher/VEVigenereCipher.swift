//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct VEVigenereCipher: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.RadioButton
import androidx.compose.material3.RadioButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.MainScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenDestination
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import javax.inject.Inject
import javax.inject.Singleton

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))

private val LightColorScheme = lightColorScheme(
    primary = textColorPrimary,
    background = backColorPrimary,
    surface = surfaceColor,
    primaryContainer = buttonColorPrimary,
    secondaryContainer = buttonColorSecondary
)

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
fun SimpleVigenereCipher(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = LightColorScheme,
        typography = Typography,
        content = content
    )
}

class CipherRepositoryImpl(
    private val cipherProvider: CipherProvider
): CipherRepository {

    override suspend fun encrypt(sourceText: String, key: String): String {
        return cipherProvider.encrypt(sourceText, key)
    }

    override suspend fun decrypt(sourceText: String, key: String): String {
        return cipherProvider.decrypt(sourceText, key)
    }
}

class CopyManager @Inject constructor(
    @ApplicationContext private val context: Context
) {
    private val clipboardManager get() = context.getSystemService(ClipboardManager::class.java)
    private val label = "CopyManagerLabel"

    fun copy(text: String) {
        val clipData = ClipData.newPlainText(label, text)
        clipboardManager.setPrimaryClip(clipData)
    }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @[Provides Singleton]
    fun provideCipherProvider(): CipherProvider = CipherProvider()

    @[Provides Singleton]
    fun provideCipherRepository(cipherProvider: CipherProvider): CipherRepository {
        return CipherRepositoryImpl(cipherProvider)
    }
}

class CipherProvider {

    suspend fun encrypt(sourceText: String, key: String): String =
        withContext(Dispatchers.Default) {
            if(key.isEmpty()) return@withContext ""


            val res = StringBuilder()
            val upperSourceText = sourceText.uppercase()

            var j = 0
            for(i in sourceText.indices) {
                val character = upperSourceText[i].code
                if(character < 'A'.code || character > 'Z'.code) continue

                val nextCharacter = (character + key[j].code - 2 * 'A'.code).mod(26) + 'A'.code
                res.append(nextCharacter.toChar())
                j = (++j).mod(key.length)
            }

            return@withContext res.toString().lowercase()
        }

    suspend fun decrypt(sourceText: String, key: String): String =
        withContext(Dispatchers.Default) {
            if(key.isEmpty()) return@withContext ""

            val result = StringBuilder()
            val upperSourceText = sourceText.uppercase()

            var j = 0
            for(i in sourceText.indices) {
                val character = upperSourceText[i].code
                if(character < 'A'.code || character > 'Z'.code) continue

                val nextCharacter = (character - key[j].code + 26).mod(26) + 'A'.code
                result.append(nextCharacter.toChar())
                j = (++j).mod(key.length)
            }


            return@withContext result.toString().lowercase()
        }

}

interface CipherRepository {
    suspend fun encrypt(sourceText: String, key: String): String
    suspend fun decrypt(sourceText: String, key: String): String
}

class CopyUseCase @Inject constructor(
    private val copyManager: CopyManager
) {
    operator fun invoke(text: String) {
        copyManager.copy(text)
    }
}

class DecryptUseCase @Inject constructor(
    private val cipherRepository: CipherRepository
) {
    suspend operator fun invoke(sourceText: String, key: String) =
        cipherRepository.decrypt(sourceText, key)
}

class EncryptUseCase @Inject constructor(
    private val cipherRepository: CipherRepository
) {
    suspend operator fun invoke(sourceText: String, key: String) =
        cipherRepository.encrypt(sourceText, key)
}

sealed class MainEvent {
    data class Encrypt(val sourceText: String = "", val key: String = ""): MainEvent()
    data class Decrypt(val sourceText: String = "", val key: String = ""): MainEvent()
    class Copy(val text: String): MainEvent()
}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val encryptUseCase: EncryptUseCase,
    private val decryptUseCase: DecryptUseCase,
    private val copyUseCase: CopyUseCase
): ViewModel() {

    private val _uiState = MutableStateFlow<UiMainState>(UiMainState.Default)
    val uiState = _uiState.asStateFlow()

    fun handle(event: MainEvent) {
        when(event) {
            is MainEvent.Encrypt -> encrypt(event.sourceText, event.key)
            is MainEvent.Decrypt -> decrypt(event.sourceText, event.key)
            is MainEvent.Copy -> copyUseCase(event.text)
        }
    }

    private fun encrypt(sourceText: String, key: String) {
        _uiState.value = UiMainState.Loading

        viewModelScope.launch {
            _uiState.value = UiMainState.Ready(encryptUseCase(sourceText, key))
        }

    }

    private fun decrypt(sourceText: String, key: String) {
        _uiState.value = UiMainState.Loading

        viewModelScope.launch {
            _uiState.value = UiMainState.Ready(decryptUseCase(sourceText, key))
        }

    }
}

sealed class UiMainState {
    object Default: UiMainState()
    object Loading: UiMainState()
    class Ready(val encryptedText: String): UiMainState()
}

@Destination
@Composable
fun MainScreen(
    viewModel: MainViewModel = hiltViewModel()
) {
    val uiState = viewModel.uiState.collectAsState().value
    var actionSelected: MainEvent by remember { mutableStateOf(MainEvent.Decrypt()) }

    var text by remember { mutableStateOf("") }
    var key by remember { mutableStateOf("") }

    val context = LocalContext.current

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .background(MaterialTheme.colorScheme.background)
            .padding(horizontal = 10.dp, vertical = 5.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically)
    ) {
        InputField(
            placeHolderResId = R.string.text_placeholder,
            text = text,
            onValueChanged = { text = it }
        )
        InputField(
            placeHolderResId = R.string.key_placeholder,
            text = key,
            onValueChanged = { key = it }
        )
        RadioButtons(
            actionSelected = actionSelected,
            onActionChanged = { actionSelected = it }
        )
        TextButton(
            onClick = {
                if(actionSelected is MainEvent.Decrypt)
                    viewModel.handle(MainEvent.Decrypt(text, key))

                if(actionSelected is MainEvent.Encrypt)
                    viewModel.handle(MainEvent.Encrypt(text, key))
            }
        ) {
            Text(
                text = stringResource(id = R.string.handle),
                color = MaterialTheme.colorScheme.primary,
                style = MaterialTheme.typography.titleLarge
            )
        }

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .heightIn(min = 100.dp),
            contentAlignment = Alignment.Center
        ) {
            when(uiState) {
                is UiMainState.Loading -> Loader()
                is UiMainState.Ready -> TargetText(
                    targetText = uiState.encryptedText,
                    onTargetTextPressed = {
                        Toast.makeText(context, R.string.copied, Toast.LENGTH_SHORT).show()
                        viewModel.handle(MainEvent.Copy(uiState.encryptedText))
                    }
                )
                is UiMainState.Default -> {}
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun TargetText(
    targetText: String,
    onTargetTextPressed: (event: MainEvent) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        onClick = { onTargetTextPressed(MainEvent.Copy(targetText)) },
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        )
    ) {
        Text(
            modifier = Modifier.padding(20.dp),
            text = targetText,
            color = MaterialTheme.colorScheme.primary,
            style = MaterialTheme.typography.bodyLarge
        )
    }
}

@Composable
private fun RadioButtons(
    actionSelected: MainEvent,
    onActionChanged: (action: MainEvent) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceAround
    ) {
        RadioButtonText(
            onSelectChanged = { onActionChanged(MainEvent.Encrypt()) },
            selected = actionSelected is MainEvent.Encrypt,
            stringResId = R.string.encrypt
        )

        RadioButtonText(
            onSelectChanged = { onActionChanged(MainEvent.Decrypt()) },
            selected = actionSelected is MainEvent.Decrypt,
            stringResId = R.string.decrypt
        )
    }
}

@Composable
private fun Loader() {
    CircularProgressIndicator(color = MaterialTheme.colorScheme.primary)
}

const val SPLASH_DELAY = 2000L

@RootNavGraph(start = true)
@Destination
@Composable
fun SplashScreen(navigator: DestinationsNavigator) {

    LaunchedEffect(key1 = Unit) {
        delay(SPLASH_DELAY)
        navigator.navigate(MainScreenDestination()) {
            popUpTo(SplashScreenDestination) { inclusive = true }
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            modifier = Modifier.size(200.dp),
            imageVector = Icons.Default.Lock,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.primary
        )
    }
}
@Composable
fun InputField(
    placeHolderResId: Int,
    text: String,
    onValueChanged: (newValue: String) -> Unit
) {
    val regexPattern = "[0-9]".toRegex()

    OutlinedTextField(
        value = text,
        onValueChange = { typedText ->
            if(!typedText.contains(regexPattern))
                onValueChanged(typedText)
        },
        placeholder = {
            Text(
                text = stringResource(id = placeHolderResId),
                color = MaterialTheme.colorScheme.primary,
                style = MaterialTheme.typography.titleLarge
            )
        },
        textStyle = MaterialTheme.typography.bodyLarge,
        colors = OutlinedTextFieldDefaults.colors(
            focusedContainerColor = MaterialTheme.colorScheme.surface,
            unfocusedTextColor = MaterialTheme.colorScheme.surface
        )
    )
}

@Composable
fun RadioButtonText(
    modifier: Modifier = Modifier,
    onSelectChanged: () -> Unit,
    selected: Boolean,
    stringResId: Int
) {
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceAround
    ) {
        RadioButton(
            onClick = onSelectChanged,
            selected = selected,
            colors = RadioButtonDefaults.colors(
                selectedColor = MaterialTheme.colorScheme.primaryContainer,
                unselectedColor = MaterialTheme.colorScheme.secondaryContainer
            )
        )
        Text(
            modifier = Modifier.clickable { onSelectChanged() },
            text = stringResource(id = stringResId),
            color = MaterialTheme.colorScheme.primary,
            style = MaterialTheme.typography.titleLarge
        )
    }
}



"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: """
import com.ramcosta.composedestinations.DestinationsNavHost
""", content: """
    SimpleVigenereCipher {
        DestinationsNavHost(navGraph = NavGraphs.root)
    }
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="encrypt">encrypt</string>
    <string name="decrypt">decrypt</string>
    <string name="handle">handle</string>
    <string name="text_placeholder">Type here your message</string>
    <string name="key_placeholder">Type here your key</string>
    <string name="target_placeholder">your target text here</string>
    <string name="copied">copied!</string>
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
