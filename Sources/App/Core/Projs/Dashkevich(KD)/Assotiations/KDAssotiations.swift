//
//  File.swift
//  
//
//  Created by admin on 11/9/23.
//

import Foundation

struct KDAssotiations: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import android.util.Log
import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import \(packageName).R
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName
import dagger.Binds
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import okhttp3.logging.HttpLoggingInterceptor.Logger
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query
import javax.inject.Inject
import javax.inject.Singleton

val backColorSecondary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val onSurfaceColor = Color(0xFF\(uiSettings.onSurfaceColor ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))

val topBar = TextStyle(
    fontWeight = FontWeight.Black,
    fontSize = 21.sp
)

val textField = TextStyle(
    fontWeight = FontWeight.Light,
    fontSize = 16.sp
)

val loadingText = TextStyle(
    fontWeight = FontWeight.Black,
    fontSize = 32.sp
)

val headline4 = TextStyle(

)

val headline5 = TextStyle(

)

val headline6 = TextStyle(

)

val defaultShape = RoundedCornerShape(11.dp)

sealed interface UiState{

    object Success: UiState
    object Error: UiState
    object Empty: UiState
    object Loading: UiState
    object None: UiState

}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppTopBar(modifier: Modifier = Modifier, lang: Lang, onAction: () -> Unit) {
    TopAppBar(
        modifier = modifier,
        title = {
            Text(
                text = stringResource(R.string.enter_a_word) + " - ${lang.name}",
                style = topBar,
                color = primaryColor
            )
        },
        actions = {
            Icon(
                modifier = Modifier
                    .padding(end = 10.dp)
                    .size(32.dp)
                    .clickable {
                        onAction()
                    },
                imageVector = Icons.Default.Settings,
                contentDescription = null,
                tint = primaryColor
            )
        }
    )
}
abstract class BaseViewModel<State>(initState: State): ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    protected val stateValue: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State){
        _viewState.value = viewState.value.changeState()
    }



}

const val DEBUG = "AppDebug"

fun Any?.logDebug(prefix: String = "", postfix: String = "") {
    if (this is Throwable?) {
        Log.e(DEBUG, toString())
    } else {
        Log.i(DEBUG, toString())
    }
}


object DebugMessage {
    const val LOADING = "Loading"
    const val SUCCESS = "Success: "
    const val ERROR = "Error: "
    const val EMPTY = "Empty"
}


suspend inline fun <T> (suspend () -> Result<T>).loadAndHandleData(
    haveDebug: Boolean = false,
    onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    if (haveDebug) DebugMessage.LOADING.logDebug()
    this().resultHandler(
        onSuccess = { result ->
            if (haveDebug) (DebugMessage.SUCCESS + result).logDebug()
            onSuccess(result)
        },
        onEmpty = {
            if (haveDebug) DebugMessage.EMPTY.logDebug()
            onEmpty()
        },
        onError = { error ->
            if (haveDebug) (DebugMessage.ERROR + error.message).logDebug()
            onError(error)
        }
    )
}

inline fun <T> Result<T>.resultHandler(
    onSuccess: (T) -> Unit,
    onError: (Throwable) -> Unit,
    onEmpty: () -> Unit
) {
    onSuccess { value ->
        if (value is Collection<*>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value is Map<*, *>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value is Array<*>) {
            if (value.isEmpty()) onEmpty()
            else onSuccess(value)
        } else if (value.toString().isEmpty()) {
            onEmpty()
        } else {
            onSuccess(value)
        }
    }
    onFailure { error ->
        onError(error)
    }
}

interface ApiRepository {

    suspend fun getAssociations(
        text: String,
        lang: Lang = Lang.En,
        type: Type = Type.Stimulus,
        limit: Int = 100, indent:
        Indent = Indent.No,
        vararg pos: Pos = arrayOf(
            Pos.Adjective, Pos.Adverb, Pos.Noun, Pos.Verb
        )
    ): Result<List<Association>>

}
enum class Indent(val str: String) {
    Yes("yes"), No("no")
}

enum class Pos(val title: String) {
    Noun("noun"), Adjective("adjective"),
    Verb("verb"), Adverb("adverb");
}

enum class Type(val title: String) {
    Stimulus("stimulus"), Response("response")
}

enum class Lang(val title: String) {
    Ru("ru"), En("en"), Es("es"),
    It("it"), De("de"), Pt("pt"),
    Fr("fr")
}
@JvmInline
value class Association(
    val value: String,
)

@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    abstract fun provideApiRepository(apiRepositoryImpl: ApiRepositoryImpl): ApiRepository

}

@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {
    @Provides
    @Singleton
    fun provideInterceptor(): OkHttpClient {
        val httpLoggingInterceptor = HttpLoggingInterceptor(Logger.DEFAULT).also { interceptor ->
            interceptor.level = HttpLoggingInterceptor.Level.BODY
        }
        return OkHttpClient.Builder().addInterceptor(httpLoggingInterceptor).build()
    }

    @Provides
    @Singleton
    fun provideGson(): Gson = GsonBuilder().setLenient().create()

    @Provides
    @Singleton
    fun provideApi(okHttpClient: OkHttpClient, gson: Gson): API {
        return Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create(gson))
            .client(okHttpClient)
            .build()
            .create(API::class.java)
    }
}
fun AssociationsResponse.mapToListAssociation(): List<Association> =
    response.firstOrNull()?.items?.map { item ->
        Association(item.item)
    } ?: emptyList<Association>()


class ApiRepositoryImpl @Inject constructor(private val api: API): ApiRepository {
    override suspend fun getAssociations(
        text: String,
        lang: Lang,
        type: Type,
        limit: Int,
        indent: Indent,
        vararg pos: Pos
    ): Result<List<Association>> = runCatching {
        api.getAssociations(
            text = text,
            lang = lang.title,
            type = type.title,
            limit = limit,
            indent = indent.str,
            pos = pos.joinToString(separator = ",") { mappedPos ->
                mappedPos.title
            }
        ).mapToListAssociation()
    }


}
interface API {


    @GET(Endpoints.GET_ASSOCIATIONS)
    suspend fun getAssociations(
        @Query(Attributes.ACCESS_TOKEN) accessToken: String = accessKey,
        @Query(Attributes.TEXT) text: String,
        @Query(Attributes.LANG) lang: String,
        @Query(Attributes.TYPE) type: String,
        @Query(Attributes.LIMIT) limit: Int,
        @Query(Attributes.POS) pos: String,
        @Query(Attributes.INDENT) indent: String,
    ): AssociationsResponse

}

@Keep
data class Response(
    @SerializedName("items")
    val items: List<Item>,
    @SerializedName("text")
    val text: String
)

@Keep
data class Request(
    @SerializedName("indent")
    val indent: String,
    @SerializedName("lang")
    val lang: String,
    @SerializedName("limit")
    val limit: Int,
    @SerializedName("pos")
    val pos: String,
    @SerializedName("text")
    val text: List<String>,
    @SerializedName("type")
    val type: String
)

@Keep
data class AssociationsResponse(
    @SerializedName("code")
    val code: Int,
    @SerializedName("request")
    val request: Request,
    @SerializedName("response")
    val response: List<Response>,
    @SerializedName("version")
    val version: String
)


const val BASE_URL = "https://api.wordassociations.net/associations/v1.0/json/"
val accessKey: String
    get() = getApiKey()

 fun getApiKey(): String = "3b140bef-ace1-4aee-b704-3c0e2365fb00"

object Endpoints {

    const val EMPTY = "."
    const val GET_ASSOCIATIONS = "search"

}

object Attributes {

    const val ACCESS_TOKEN = "apikey"
    const val TEXT = "text"
    const val LANG = "lang"
    const val TYPE = "type"
    const val LIMIT = "limit"
    const val POS = "pos"
    const val INDENT = "indent"

}


@Keep
data class Item(
    @SerializedName("item")
    val item: String,
    @SerializedName("pos")
    val pos: String,
    @SerializedName("weight")
    val weight: Int
)

sealed class Destinations(val route: String) {

    object Main : Destinations(Routes.MAIN) {

        fun templateRoute(): String {
            return route
        }

        fun requestRoute(): String {
            return route
        }

    }

}

object Routes {

    const val MAIN = "main"

}

@Composable
fun AppNavigation() {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()

    NavHost(
        modifier = Modifier
            .fillMaxSize(),
        navController = navController,
        startDestination = Destinations.Main.route
    ) {
        composable(Destinations.Main.route) { MainDest(navController) }
    }

    SideEffect {
        systemUiController.run {
            setStatusBarColor(
                color = onSurfaceColor,
                darkIcons = false
            )
            setNavigationBarColor(
                color = surfaceColor,
                darkIcons = true
            )
        }
    }
}

@Composable
fun AssociationCard(modifier: Modifier = Modifier, association: Association) {
    Box(modifier = modifier, contentAlignment = Alignment.Center) {
        Text(
            text = association.value, style = textField, color = onSurfaceColor,
            modifier = Modifier.fillMaxWidth(),
            textAlign = TextAlign.Start
        )
    }
}

@Composable
fun AssociationsColumn(modifier: Modifier = Modifier, associations: List<Association>) {
    LazyColumn(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        contentPadding = PaddingValues(vertical = 25.dp, horizontal = 8.dp),
        verticalArrangement = Arrangement.spacedBy(11.dp)
    ) {
        items(associations) { association ->
            AssociationCard(
                association = association,
                modifier = Modifier
                    .fillMaxWidth()
                    .background(color = surfaceColor, shape = defaultShape)
                    .padding(horizontal = 9.dp, vertical = 14.dp)
            )
        }
    }
}

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun AssociationTextField(
    modifier: Modifier = Modifier,
    placeHolder: @Composable () -> Unit,
    text: String,
    onTextChanged: (String) -> Unit,
    onSearch: () -> Unit
) {
    val keyboardController = LocalSoftwareKeyboardController.current
    Box(modifier = modifier, contentAlignment = Alignment.Center) {
        TextField(
            value = text,
            onValueChange = onTextChanged,
            colors = TextFieldDefaults.colors(
                unfocusedIndicatorColor = surfaceColor,
                focusedIndicatorColor = surfaceColor,
                unfocusedContainerColor = primaryColor,
                focusedContainerColor = primaryColor,
                unfocusedTextColor = surfaceColor,
                focusedTextColor = surfaceColor,
                cursorColor = surfaceColor,
            ),
            singleLine = true,
            modifier = Modifier.fillMaxWidth(),
            textStyle = textField,
            placeholder = {
                placeHolder()
            },
            keyboardActions = KeyboardActions(
                onSearch = {
                    keyboardController?.hide()
                    onSearch()
                }
            ),
            keyboardOptions = KeyboardOptions(
                imeAction = ImeAction.Search,
                keyboardType = KeyboardType.Text
            )
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    Column(modifier = modifier, horizontalAlignment = Alignment.CenterHorizontally) {
        Spacer(modifier = Modifier.height(16.dp))
        AssociationTextField(
            modifier = Modifier
                .padding(horizontal = 12.dp)
                .fillMaxWidth()
                .clip(shape = defaultShape)
                .background(color = primaryColor)
                .padding(horizontal = 9.dp, vertical = 25.dp),
            text = viewState.associationText, onTextChanged = { text ->
                viewModel.changedAssociationField(text)
            },
            placeHolder = {
                Text(
                    text = stringResource(R.string.text_field_placeholder),
                    style = textField.copy(fontSize = 15.sp),
                    color = surfaceColor
                )
            },
            onSearch = {
                viewModel.searchedAssociations()
            }
        )

        when (viewState.uiState) {
            UiState.Empty, UiState.Error, UiState.Loading -> {
                Spacer(modifier = Modifier.weight(0.8f))
                LoadingUi(
                    modifier = Modifier
                        .padding(horizontal = 30.dp)
                        .fillMaxWidth()
                        .background(
                            color = surfaceColor.copy(alpha = 0.72f),
                            shape = defaultShape,
                        )
                        .border(width = 1.dp, shape = defaultShape, color = onSurfaceColor)
                        .padding(vertical = 11.dp, horizontal = 30.dp)
                )
                Spacer(modifier = Modifier.weight(1f))
            }

            UiState.None -> {

            }

            UiState.Success -> {
                Spacer(modifier = Modifier.height(11.dp))
                AssociationsColumn(
                    modifier = Modifier
                        .padding(horizontal = 10.dp)
                        .fillMaxWidth()
                        .background(color = primaryColor, shape = defaultShape),
                    associations = viewState.associations
                )
            }

            else -> {}
        }


    }
}

@Composable
fun LoadingUi(modifier: Modifier = Modifier) {
    Box(
        modifier = modifier,
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = stringResource(R.string.loading),
            color = primaryColor,
            style = loadingText
        )
    }
}

data class MainState(
    val associationText: String = "",
    val associations: List<Association> = emptyList(),
    val uiState: UiState = UiState.None,
    val currentLang: Lang = Lang.En,
    val openDialog: Boolean = false
)

@Composable
fun MainDest(navController: NavController) {
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(
        viewModel = mainViewModel,
        viewState = viewState
    )
}

@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    Scaffold(
        containerColor = backColorSecondary,
        topBar = {
            AppTopBar(lang = viewState.currentLang, onAction = {
                viewModel.openedDialog()
            })
        }
    ) {
        if (viewState.openDialog) {
            LangAlertDialog(
                modifier = Modifier
                    .fillMaxHeight(0.7f)
                    .fillMaxWidth()
                    .background(color = surfaceColor, shape = defaultShape)
                    .padding(4.dp),
                currentLang = viewState.currentLang,
                onDismiss = {
                    viewModel.dismissedDialog()
                },
                onLangClick = { lang ->
                    viewModel.changedLang(lang)
                }
            )
        }
        MainContent(
            modifier = Modifier
                .padding(it)
                .fillMaxSize(),
            viewModel = viewModel,
            viewState = viewState
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LangAlertDialog(
    modifier: Modifier = Modifier,
    currentLang: Lang,
    onDismiss: () -> Unit,
    onLangClick: (Lang) -> Unit
) {
    AlertDialog(
        onDismissRequest = {
            onDismiss()
        },
        modifier = modifier
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = stringResource(R.string.select_a_language),
                style = topBar,
                color = onSurfaceColor,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
            Lang.values().forEach { lang ->
                val buttonColor =
                    if (lang == currentLang) primaryColor else backColorSecondary
                FilledTonalButton(
                    modifier = Modifier
                        .padding(horizontal = 8.dp, vertical = 2.dp)
                        .fillMaxWidth(),
                    onClick = {
                        onLangClick(lang)
                    },
                    shape = defaultShape,
                    colors = ButtonDefaults.filledTonalButtonColors(
                        containerColor = buttonColor,
                        disabledContainerColor = buttonColor
                    ),
                    contentPadding = PaddingValues(10.dp)
                ) {
                    Text(
                        text = lang.name,
                        style = textField,
                        color = surfaceColor,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                }
            }
        }
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(private val apiRepository: ApiRepository) :
    BaseViewModel<MainState>(MainState()) {


    fun searchedAssociations() = viewModelScope.launch(Dispatchers.IO) {
        val call = suspend {
            apiRepository.getAssociations(
                text = stateValue.associationText,
                indent = Indent.No,
                lang = stateValue.currentLang
            )
        }
        call.loadAndHandleData(
            onSuccess = { associations ->
                updateState {
                    copy(
                        associations = associations,
                        uiState = UiState.Success
                    )
                }
            },
            onError = {
                updateState {
                    copy(
                        uiState = UiState.Error
                    )
                }
            },
            onLoading = {
                updateState {
                    copy(
                        uiState = UiState.Loading
                    )
                }
            },
            onEmpty = {
                updateState {
                    copy(
                        uiState = UiState.Empty
                    )
                }
            },
        )
    }

    fun changedAssociationField(text: String) = viewModelScope.launch {
        updateState {
            copy(associationText = text)
        }
    }

    fun dismissedDialog() = viewModelScope.launch {
        updateState {
            copy(
                openDialog = false
            )
        }
    }

    fun openedDialog() = viewModelScope.launch {
        updateState {
            copy(
                openDialog = true
            )
        }
    }

    fun changedLang(lang: Lang) = viewModelScope.launch {
        updateState {
            copy(
                openDialog = false,
                currentLang = lang
            )
        }
    }

}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: .init(
                imports: "",
                content: """
            AppNavigation()
"""
            ),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(
                additional: """
    <string name="enter_a_word">Enter a word</string>
    <string name="text_field_placeholder">Enter a word or sentence</string>
    <string name="loading">Loading...</string>
    <string name="select_a_language">Select a language</string>
"""
            ),
            colorsData: .empty)
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
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

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
            signingConfig signingConfigs.debug
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
    //Base
    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material
    
    //Compose
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.compose_system_ui_controller

    //Other
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime

    //DI
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_hilt_nav

    //Internet
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson

    implementation Dependencies.okhttp_login_interceptor

    //Room
    kapt Dependencies.room_compiler
    implementation Dependencies.room_runtime
    implementation Dependencies.room_ktx

    
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
    const val okhttp = "4.11.0"
    const val room = "2.5.0"
    const val coil = "1.3.2"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
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
