//
//  File.swift
//  
//
//  Created by admin on 13.06.2023.
//

import Foundation

struct VSPhoneInfo: FileProviderProtocol {
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
                implementation 'io.github.g00fy2.quickie:quickie-bundled:1.6.0'
            implementation 'androidx.datastore:datastore-preferences:1.0.0'
            coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.3'
            implementation Dependencies.okhttp
            implementation Dependencies.okhttp_login_interceptor
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
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: """
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
""",
                content: """
            Box(
                modifier = Modifier
                    .fillMaxSize()
            ) {
                PhoneInfoNavHost()
            }
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
                    <string name="cancel">Cancel</string>

                    <string name="theme_dialog_title">Theme</string>
                    <string name="theme_dialog_light">Light</string>
                    <string name="theme_dialog_dark">Dark</string>
                    <string name="theme_dialog_default">System default</string>

                    <string name="settings_theme_choice">Theme</string>
                    <string name="init_text">Enter the number and click search</string>
                    <string name="nothing_found">Sorry, we found nothing</string>
                    <string name="invalid_number">The number is invalid</string>

                    <string name="phone_info_country">Country</string>
                    <string name="phone_info_region">Region</string>
                    <string name="phone_info_timezone">Time zones</string>
                    <string name="phone_info_topbar_title">\(mainData.appName)</string>

                    <string name="topbar_back">Back</string>
                    <string name="topbar_settings">Settings</string>
                    <string name="phone_picker_search">Search</string>
                    <string name="settings_dark_mode">Dark Mode</string>
        
        """),
            colorsData: ANDColorsData(additional: "")
        )
    }
    
    static var fileName = "VSPhoneInfo.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import androidx.annotation.DrawableRes
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.SizeTransform
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.with
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.MaterialTheme.shapes
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.DarkMode
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.RadioButtonDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.lightColorScheme
import androidx.compose.material3.surfaceColorAtElevation
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ColorFilter
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import java.net.SocketTimeoutException
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "3F51B5"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "3F51B5"))
val surfaceColorPrimary = Color(0xFF\(uiSettings.surfaceColor ?? "071950"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "348810"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Composable
fun PhoneInfoNavHost() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = Screens.MainScreen.route) {
        composable(Screens.MAIN_SCREEN) {
            PhoneFinderMainScreen(navController)
        }
    }
}

sealed class Screens(val route: String) {

    companion object {
        const val MAIN_SCREEN = "main"
    }

    object MainScreen : Screens(route = MAIN_SCREEN)
}

@Composable
fun BoxWithLabel(label: String, content: String) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(shapes.medium)
            .background(colorScheme.secondary)
            .padding(12.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text(text = label, color = colorScheme.onSecondary)
        Text(text = content, color = colorScheme.onSecondary)
    }
}

@Composable
fun ColumnScope.Filler(text: String, @DrawableRes image: Int) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 32.dp)
            .weight(1f),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Image(
            modifier = Modifier
                .padding(top = 24.dp)
                .fillMaxWidth()
                .weight(1f),
            painter = painterResource(image),
            contentDescription = null,
            contentScale = ContentScale.Fit,
            colorFilter = ColorFilter.tint(textColorPrimary)
        )
        Text(modifier = Modifier.padding(top = 24.dp), text = text, color = textColorPrimary)
        Spacer(modifier = Modifier.weight(0.6f))
    }
}

@Composable
fun ColumnScope.FillerPhoneInfo(info: PhoneInfo) {
    Column(
        modifier = Modifier
            .weight(1f)
            .fillMaxWidth()
            .padding(start = 32.dp, top = 32.dp, end = 32.dp),
        verticalArrangement = Arrangement.spacedBy(24.dp)
    ) {
        BoxWithLabel(
            label = stringResource(R.string.phone_info_country),
            content = info.country
        )
        if (info.location != info.country && info.location.isNotEmpty()) {
            BoxWithLabel(
                label = stringResource(R.string.phone_info_region),
                content = info.location
            )
        }
        BoxWithLabel(
            label = stringResource(R.string.phone_info_timezone),
            content = info.timezones.joinToString("", limit = 5)
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainTopBar(viewModel: PhoneFinderViewModel, state: PhoneFinderUiState, navController: NavController) {
    CenterAlignedTopAppBar(
        navigationIcon = {
            AnimatedVisibility(visible = state.state !is PhoneFinderUiState.FinderState.Init, enter = fadeIn(), exit = fadeOut()) {
                IconButton(onClick = { viewModel.resetState() }) {
                    Icon(
                        imageVector = Icons.Default.ArrowBack,
                        contentDescription = stringResource(R.string.topbar_back),
                        tint = textColorPrimary
                    )
                }
            }
        },
        title = {
            AnimatedContent(
                targetState = state.state,
                transitionSpec = {
                    (fadeIn() + slideInHorizontally() with fadeOut() + slideOutHorizontally { it / 2 })
                        .using(SizeTransform(clip = false))
                }
            ) { targetState ->
                when (targetState) {
                    is PhoneFinderUiState.FinderState.Init -> Text(stringResource(R.string.phone_info_topbar_title), color = textColorPrimary)
                    else -> NumberTextField(
                        value = state.number,
                        onValue = viewModel::changeNumber,
                        onAction = viewModel::getInfo
                    )
                }
            }
        },
        actions = { }
    , colors = TopAppBarDefaults.centerAlignedTopAppBarColors(containerColor = backColorSecondary)
    )
}

@Composable
fun NumberTextField(value: String, onValue: (String) -> Unit, onAction: () -> Unit) {
    Box(
        modifier = Modifier
            .background(backColorSecondary)
            .fillMaxWidth()
            .padding(horizontal = 32.dp)
    ) {
        BasicTextField(
            modifier = Modifier.align(Alignment.Center),
            value = value,
            onValueChange = onValue,
            textStyle = TextStyle(
                color = textColorPrimary,
                fontSize = 14.sp
            ),
            singleLine = true,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone, imeAction = ImeAction.Search),
            keyboardActions = KeyboardActions(
                onSearch = { onAction() }
            )
        ) { innerTextField ->
            Box(
                Modifier
                    .fillMaxWidth()
                    .padding(vertical = 24.dp)
                    .clip(MaterialTheme.shapes.medium)
                    .background(surfaceColorPrimary)
                    .padding(16.dp),
                contentAlignment = Alignment.CenterStart
            ) {
                innerTextField()
            }
        }
    }
}

@Composable
fun PhoneFinderMainScreen(navController: NavController, viewModel: PhoneFinderViewModel = hiltViewModel()) {
    val state = viewModel.state.collectAsState().value

    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .imePadding()
            .statusBarsPadding(),
        topBar = { MainTopBar(viewModel = viewModel, state = state, navController = navController) }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .background(backColorPrimary)
                .padding(paddingValues),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            AnimatedVisibility(visible = state.state is PhoneFinderUiState.FinderState.Init) {
                NumberTextField(value = state.number, onValue = viewModel::changeNumber, onAction = viewModel::getInfo)
            }

            when (state.state) {
                is PhoneFinderUiState.FinderState.Init -> Filler(stringResource(R.string.init_text), R.drawable.img_phone)
                is PhoneFinderUiState.FinderState.NothingFound -> Filler(stringResource(R.string.nothing_found), R.drawable.img_nothing_found)
                is PhoneFinderUiState.FinderState.PhoneFound ->
                    if (state.state.info.isValid) FillerPhoneInfo(state.state.info)
                    else Filler(stringResource(R.string.invalid_number), R.drawable.img_nothing_found)
            }
            Button(
                modifier = Modifier.fillMaxWidth(0.8f),
                shape = MaterialTheme.shapes.medium,
                onClick = viewModel::getInfo,
                enabled = !state.isLoading,
                colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary, contentColor = buttonTextColorPrimary)
            ) {
                Text(text = stringResource(R.string.phone_picker_search))
            }
        }
    }
}

data class PhoneFinderUiState(
    val number: String = "",
    val state: FinderState = FinderState.Init,
    val isLoading: Boolean = false
) {
    sealed interface FinderState {
        object Init : FinderState
        data class PhoneFound(val info: PhoneInfo) : FinderState
        object NothingFound : FinderState
    }
}

@HiltViewModel
class PhoneFinderViewModel @Inject constructor(
    val repository: PhoneFinderRepository
) : ViewModel() {

    var job: Job? = null
    private val _state = MutableStateFlow(PhoneFinderUiState())
    val state = _state.asStateFlow()

    fun getInfo() {
        if (job?.isActive != true) {
            _state.value = state.value.copy(isLoading = true)
            job = viewModelScope.launch {
                _state.value = when (val response = repository.getPhoneInfo(state.value.number)) {
                    is SafeResponse.Error -> _state.value.copy(state = PhoneFinderUiState.FinderState.NothingFound, isLoading = false)
                    is SafeResponse.Success -> _state.value.copy(state = PhoneFinderUiState.FinderState.PhoneFound(
                        response.value
                    ), isLoading = false)
                }
            }
        }
    }

    fun changeNumber(number: String) {
        _state.value = _state.value.copy(number = number)
    }

    fun resetState() {
        _state.value = _state.value.copy(state = PhoneFinderUiState.FinderState.Init)
    }
}


@Composable
fun SettingsRadioButtonWithLabel(text: String, selected: Boolean, onClick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(vertical = 8.dp, horizontal = 16.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        RadioButton(
            selected = selected,
            onClick = null,
            colors = RadioButtonDefaults.colors(
                unselectedColor = MaterialTheme.colorScheme.onSurface
            )
        )
        Text(modifier = Modifier.padding(start = 16.dp), text = text)
    }
}

@Module
@InstallIn(SingletonComponent::class)
object PhoneFinderModule {

    private const val API_KEY = "c+bE5Ns02J8TL3dmNNLFCQ==Zqv5UjpkkbmPftVT"
    private const val BASE_URL = "https://api.api-ninjas.com"

    @Provides
    @Singleton
    fun provideApiKeyInterceptor() = ApiKeyInterceptor(API_KEY)

    @Provides
    @Singleton
    fun provideOkHttpClient(apiKeyInterceptor: ApiKeyInterceptor) = OkHttpClient.Builder()
        .addInterceptor(
            HttpLoggingInterceptor().apply { setLevel(HttpLoggingInterceptor.Level.BASIC) }
        )
        .addInterceptor(apiKeyInterceptor)
        .build()

    @Provides
    @Singleton
    fun provideRetrofit(client: OkHttpClient) = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .client(client)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    @Provides
    @Singleton
    fun provideService(retrofit: Retrofit): PhoneFinderService {
        return retrofit.create(PhoneFinderService::class.java)
    }

    @Provides
    @Singleton
    fun provideRepository(service: PhoneFinderService) = PhoneFinderRepository(service)

    @Provides
    @Singleton
    fun provideDatastore(@ApplicationContext context: Context) = SettingsRepository(context)
}

sealed class RetrofitException : RuntimeException() {

    object InternalServerException : RetrofitException()
    object TooManyRequestsException : RetrofitException()
    object UnexpectedHttpException : RetrofitException()
    object SocketTimeoutException : RetrofitException()
    object IoException : RetrofitException()
}

data class Settings(
    val darkMode: DarkMode = DarkMode.System,
) {
    enum class DarkMode {
        System, Light, Dark
    }
}

class SettingsRepository(context: Context) {

    companion object {
        private const val PREFERENCES_NAME = "token_preferences"
        private val DARK_MODE = stringPreferencesKey("dark_mode")
    }

    private val Context.dataStore by preferencesDataStore(PREFERENCES_NAME)

    private val datastore = context.dataStore

    fun getSettings(): Flow<Settings> =
        datastore.data.map { prefs ->
            Settings(
                darkMode = prefs[DARK_MODE]?.let { Settings.DarkMode.valueOf(it) } ?: Settings.DarkMode.System,
            )
        }

    suspend fun updateSettings(settings: Settings) {
        datastore.edit { prefs ->
            prefs[DARK_MODE] = settings.darkMode.name
        }
    }
}

class ApiKeyInterceptor(private val apiKey: String) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        return chain.proceed(
            chain.request()
                .newBuilder()
                .addHeader("X-Api-Key", apiKey)
                .build()
        )
    }
}

class PhoneFinderRepository(
    private val service: PhoneFinderService,
) {

    suspend fun getPhoneInfo(number: String) =
        safeApiCall(Dispatchers.IO) {
            service.getPhoneInfo(number)
        }
}

interface PhoneFinderService {
    @GET("/v1/validatephone")
    suspend fun getPhoneInfo(@Query("number") number: String): PhoneInfo
}

data class PhoneInfo(
    @SerializedName("is_valid") val isValid: Boolean,
    val country: String,
    val location: String,
    val timezones: List<String>
)

suspend fun <T> safeApiCall(
    dispatcher: CoroutineDispatcher,
    apiCall: suspend () -> T
): SafeResponse<T> {
    return withContext(dispatcher) {
        try {
            SafeResponse.Success(apiCall.invoke())
        } catch (exception: Exception) {
            SafeResponse.Error(mapExceptionToNetworkException(exception))
        }
    }
}

internal fun mapExceptionToNetworkException(throwable: Throwable): RuntimeException {
    return when (throwable) {
        is HttpException -> mapErrorToNetworkException(throwable.code())
        is SocketTimeoutException -> RetrofitException.SocketTimeoutException
        is IOException -> RetrofitException.IoException
        else -> RetrofitException.UnexpectedHttpException
    }
}

internal fun mapErrorToNetworkException(code: Int): RuntimeException {
    return when (code) {
        429 -> RetrofitException.TooManyRequestsException
        500 -> RetrofitException.InternalServerException
        else -> RetrofitException.UnexpectedHttpException
    }
}

sealed interface SafeResponse<out T> {
    class Error(val error: Exception) : SafeResponse<Nothing>
    class Success<T>(val value: T) : SafeResponse<T>
}

@HiltViewModel
class MainScreenViewModel @Inject constructor(
    private val repository: SettingsRepository
) : ViewModel() {

    val settings = MutableStateFlow(Settings())

    init {
        viewModelScope.launch {
            repository.getSettings().collect {
                settings.value = it
            }
        }
    }
}

"""
    }
}
