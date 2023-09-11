//
//  File.swift
//  
//
//  Created by admin on 9/7/23.
//

import Foundation

struct DTEmojiFinder: SFFileProviderProtocol {
    static func mainFragmentCMF(_ mainData: MainData) -> ANDMainFragmentCMF {
        ANDMainFragmentCMF(content: """
package \(mainData.packageName).presentation.fragments.main_fragment

import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.text.selection.SelectionContainer
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.dimensionResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.fragment.app.Fragment
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import \(mainData.packageName).R
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

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
        EmojiScreen()
    }
}

sealed class Resource<T> {
    class Success<T>(val data: T) : Resource<T>()
    class Error<T>(val message: String) : Resource<T>()
    class Loading<T> : Resource<T>()
}

fun EmojiDto.toDomain(): Emoji {
    return Emoji(
        character = this.character,
        code = this.code,
        name = this.name.replaceFirstChar { it.uppercase() }
    )
}

class AuthInterceptor(private val apiKey: String) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request().newBuilder()
            .addHeader("X-Api-Key", apiKey)
            .build()
        return chain.proceed(request)
    }
}

data class EmojiDto(
    @SerializedName("character")
    val character: String,
    @SerializedName("code")
    val code: String,
    @SerializedName("group")
    val group: String,
    @SerializedName("image")
    val imageUrl: String,
    @SerializedName("name")
    val name: String,
    @SerializedName("subgroup")
    val subgroup: String
)

interface EmojiService {

    @GET("v1/emoji")
    suspend fun getEmojisByName(@Query("name") name: String): retrofit2.Response<List<EmojiDto>>
}

class EmojiRepositoryImpl(
    private val emojiService: EmojiService,
    private val context: Context
) : EmojiRepository {

    override suspend fun getEmojisByName(name: String): Flow<Resource<List<Emoji>>> = flow {
        try {
            emit(Resource.Loading())
            val response = emojiService.getEmojisByName(name)
            val body = response.body()
            if (response.isSuccessful && body != null) {
                if (body.isNotEmpty()) {
                    emit(Resource.Success(body.map { it.toDomain() }))
                } else {
                    emit(Resource.Error(context.getString(R.string.no_emoji_with_that_name)))
                }
            } else {
                emit(Resource.Error(context.getString(R.string.unexpected_error)))
            }
        } catch (e: Throwable) {
            when (e) {
                is IOException -> emit(Resource.Error(context.getString(R.string.connection_lost)))
                is HttpException -> emit(Resource.Error(context.getString(R.string.server_error)))
                else -> emit(Resource.Error(context.getString(R.string.unexpected_error)))
            }
        }
    }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Singleton
    @Provides
    fun provideEmojiService(): EmojiService {
        val httpClient = OkHttpClient.Builder()
            .addInterceptor(AuthInterceptor("zOevlY5qtngRacRnWBdJSA==8YDMqZkhD4IS9sxC"))
            .build()

        val retrofit = Retrofit.Builder()
            .baseUrl("https://api.api-ninjas.com/")
            .client(httpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()

        return retrofit.create(EmojiService::class.java)
    }

    @Singleton
    @Provides
    fun provideEmojiRepository(emojiService: EmojiService, app: Application): EmojiRepository {
        return EmojiRepositoryImpl(emojiService, app)
    }
}

data class Emoji(
    val character: String,
    val code: String,
    val name: String
)

interface EmojiRepository {

    suspend fun getEmojisByName(name: String): Flow<Resource<List<Emoji>>>
}

val backColorPrimary = Color(0xFF\(mainData.uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(mainData.uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(mainData.uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(mainData.uiSettings.surfaceColor ?? "FFFFFF"))
val paddingPrimary = 16

@Composable
fun EmojiItem(emoji: Emoji, modifier: Modifier = Modifier) {
    Card(
        modifier = modifier,
        elevation = CardDefaults.cardElevation(dimensionResource(id = R.dimen.main_card_elevation)),
        colors = CardDefaults.cardColors(containerColor = surfaceColor)
    ) {
        SelectionContainer(modifier = Modifier.background(surfaceColor)) {
            Column(
                modifier = Modifier
                    .padding(paddingPrimary.dp)
                    .fillMaxWidth()
                    .background(surfaceColor)
            ) {
                Row(
                    verticalAlignment = Alignment.Bottom,
                    modifier = Modifier.background(surfaceColor)
                ) {
                    Text(
                        text = stringResource(R.string.character),
                        style = MaterialTheme.typography.titleMedium,
                        color = textColorPrimary
                    )
                    Text(text = emoji.character, color = textColorPrimary)
                }
                Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.main_margin)))
                Row(
                    verticalAlignment = Alignment.Top,
                    modifier = Modifier.background(surfaceColor)
                ) {
                    Text(
                        text = stringResource(R.string.emoji_name),
                        style = MaterialTheme.typography.titleMedium,
                        color = textColorPrimary
                    )
                    Text(
                        text = emoji.name,
                        modifier = Modifier.fillMaxWidth(),
                        color = textColorPrimary
                    )
                }
                Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.main_margin)))
                Row(
                    verticalAlignment = Alignment.Top,
                    modifier = Modifier.background(surfaceColor)
                ) {
                    Text(
                        text = stringResource(R.string.unicode),
                        style = MaterialTheme.typography.titleMedium,
                        color = textColorPrimary
                    )
                    Text(
                        text = emoji.code,
                        modifier = Modifier.fillMaxWidth(),
                        color = textColorPrimary
                    )
                }
            }
        }
    }
}

@Composable
fun EmojiScreen(viewModel: EmojiViewModel = hiltViewModel()) {
    val state = viewModel.state.collectAsState()
    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(
                    start = dimensionResource(id = R.dimen.main_padding),
                    end = dimensionResource(id = R.dimen.main_padding)
                )
                .background(backColorPrimary)
        ) {
            LazyColumn(
                verticalArrangement = Arrangement.spacedBy(paddingPrimary.dp),
                contentPadding = PaddingValues(
                    top = dimensionResource(id = R.dimen.main_padding),
                    bottom = dimensionResource(id = R.dimen.main_padding)
                )
            ) {
                item {
                    Header(modifier = Modifier.fillMaxWidth()) {
                        viewModel.onUserInputChanged(it)
                    }
                }
                items(state.value.emojis) { emoji ->
                    EmojiItem(emoji = emoji)
                }
            }
            when {
                state.value.isLoading -> {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center),
                        color = buttonColorPrimary
                    )
                }

                state.value.error.isNotEmpty() -> {
                    Text(
                        text = state.value.error,
                        modifier = Modifier.align(Alignment.Center),
                        color = textColorPrimary
                    )
                }
            }
        }
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun Header(modifier: Modifier = Modifier, onUserInputChange: (String) -> Unit) {
    val keyboardController = LocalSoftwareKeyboardController.current
    val focusManager = LocalFocusManager.current
    val textFieldState = rememberSaveable { mutableStateOf("") }
    Column(
        modifier = modifier.background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Text(
            text = stringResource(R.string.emoji_finder),
            style = MaterialTheme.typography.titleLarge,
            modifier = Modifier.align(Alignment.Start),
            color = textColorPrimary
        )
        Spacer(modifier = Modifier.height(dimensionResource(id = R.dimen.main_margin)))
        OutlinedTextField(
            modifier = Modifier.fillMaxWidth(),
            value = textFieldState.value,
            placeholder = { Text(text = stringResource(R.string.input_a_emoji_name)) },
            singleLine = true,
            colors = OutlinedTextFieldDefaults.colors(
                focusedTextColor = textColorPrimary,
                unfocusedTextColor = textColorPrimary,
                cursorColor = buttonColorPrimary,
                focusedBorderColor = buttonColorPrimary,
                unfocusedBorderColor = textColorPrimary,
                focusedContainerColor = backColorPrimary,
                unfocusedContainerColor = backColorPrimary
            ),
            keyboardOptions = KeyboardOptions.Default.copy(
                keyboardType = KeyboardType.Text,
                imeAction = ImeAction.Done
            ),
            keyboardActions = KeyboardActions(onDone = {
                keyboardController?.hide()
                focusManager.clearFocus(true)
            }),
            onValueChange = {
                textFieldState.value = it
                if (it.isNotBlank()) onUserInputChange(it)
            }
        )
    }
}

data class EmojiState(
    val emojis: List<Emoji> = emptyList(),
    val isLoading: Boolean = false,
    val error: String = ""
)

@HiltViewModel
class EmojiViewModel @Inject constructor(
    private val emojiRepository: EmojiRepository
) : ViewModel() {

    private val _state = MutableStateFlow(EmojiState())
    val state = _state.asStateFlow()

    private val userInput = MutableStateFlow("")

    init {
        observeUserInput()
    }

    @OptIn(FlowPreview::class)
    private fun observeUserInput() {
        viewModelScope.launch {
            userInput
                .filter { it.isNotBlank() }
                .map { it.trim() }
                .debounce(1500)
                .distinctUntilChanged()
                .collect {
                    getEmojisByName(it)
                }
        }
    }

    private suspend fun getEmojisByName(name: String) {
        emojiRepository.getEmojisByName(name).collect {
            when (it) {
                is Resource.Success -> _state.value = EmojiState(emojis = it.data)
                is Resource.Loading -> _state.value = EmojiState(isLoading = true)
                is Resource.Error -> _state.value = EmojiState(error = it.message)
            }
        }
    }

    fun onUserInputChanged(input: String) {
        userInput.value = input
    }
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
    <string name="server_error">Server error</string>
    <string name="unexpected_error">Unexpected error</string>
    <string name="character">"Character: "</string>
    <string name="emoji_name">"Emoji name: "</string>
    <string name="unicode">"Unicode: "</string>
    <string name="input_a_emoji_name">Input an emoji name</string>
    <string name="emoji_finder">\(mainData.appName)</string>
    <string name="no_emoji_with_that_name">Couldn\\'t find an emoji with that name</string>
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
            buildConfig true
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
        implementation Dependencies.retrofit
        implementation Dependencies.converter_gson
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
    
    
    
    
    
    static var fileName: String = ""
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return ""
    }
    
    
}
