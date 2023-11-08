//
//  File.swift
//  
//
//  Created by admin on 08.11.2023.
//

import Foundation

struct KDFindUniversity: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.MenuDefaults
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.ui.text.TextStyle
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.ui.Alignment
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import \(packageName).R
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.runtime.collectAsState
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Converter
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton
import dagger.Binds
import retrofit2.http.GET
import retrofit2.http.Query
import android.util.Log
import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import kotlinx.coroutines.delay


val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))


val mediumFontSize = 20.sp
val lowFontSize = 16.sp
val highFontSize = 24.sp


const val DEBUG = "AppDebug"

fun Any?.logDebug(){
    Log.i(DEBUG, toString())
}
enum class ScreenState{
    Empty, Success, Error, None, Loading
}

inline fun<T> Result<T>.resultHandler(
    onSuccess: (T) -> Unit,
    onError: (Throwable) -> Unit,
    onEmpty: () -> Unit
){
    onSuccess { value ->
        if(value is Collection<*>){
            if(value.isEmpty()) onEmpty()
        }
        else if(value is Map<*,*>){
            if(value.isEmpty()) onEmpty()
        }
        else if(value is Array<*>){
            if(value.isEmpty()) onEmpty()
        }
        if(value.toString().isEmpty()){
            if(value !is Collection<*> && value !is Map<*,*> && value !is Array<*>){
                onEmpty()
            }
        }
        else{
            onSuccess(value)
        }
    }
    onFailure { error ->
        onError(error)
    }
}


typealias FunResult<T> = () -> Result<T>

object Debug {
    const val LOADING = "Loading"
    const val SUCCESS = "Success: "
    const val ERROR = "Error: "
    const val EMPTY = "Empty"
}

suspend inline fun<T> Result<T>.loadAndHandleData(
    haveDebug: Boolean = false,
    haveDelay: Boolean = false,
    delayTimeMillis: Long = 500,
    onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    if(haveDelay) delay(delayTimeMillis)
    if(haveDebug) Debug.LOADING.logDebug()
    resultHandler(
        onSuccess = {result ->
            if(haveDebug) (Debug.SUCCESS + result).logDebug()
            onSuccess(result)
        },
        onEmpty = {
            if(haveDebug) Debug.EMPTY.logDebug()
            onEmpty()
        },
        onError = {error ->
            if(haveDebug) (Debug.ERROR + error.message).logDebug()
            onError(error)
        }
    )
}

const val CIS_COUNTRIES_CODE = "RU,UA,KZ,BY,KG,AZ,AM,MD,TJ,GE,LV,LT,EE,RS"

@Keep
data class University(
    @SerializedName("id")
    val id: Int,
    @SerializedName("title")
    val title: String
)


@Keep
data class Country(
    @SerializedName("id")
    val id: Int,
    @SerializedName("title")
    val title: String
)
@Keep
data class City(
    @SerializedName("id")
    val id: Int,
    @SerializedName("title")
    val title: String
)


interface ApiRepository {

    suspend fun getUniversities(cityId: Int, countryId: Int): Result<List<University>>

    suspend fun getCountries(countryCodes: String): Result<List<Country>>

    suspend fun getCities(countryId: Int): Result<List<City>>

}

class ApiRepositoryImpl @Inject constructor(private val api: API) : ApiRepository {
    override suspend fun getUniversities(
        cityId: Int,
        countryId: Int
    ): Result<List<University>> = runCatching {
        api.getUniversities(cityId = cityId, countryId = countryId).response.items
    }

    override suspend fun getCountries(
        countryCodes: String
    ): Result<List<Country>> = runCatching {
        api.getCountries(countryCodes = countryCodes).response.items
    }

    override suspend fun getCities(countryId: Int): Result<List<City>>
            = runCatching{
        api.getCities(countryId = countryId).response.items
    }

}

@Keep
data class VKResponse<T>(
    @SerializedName("count")
    val count: Int,
    @SerializedName("items")
    val items: List<T>
)

@Keep
data class VKRequest<T>(
    @SerializedName("response")
    val response: VKResponse<T>
)



const val BASE_URL = "https://api.vk.com/method/"
const val ACCESS_TOKEN = "c8c3be4ec8c3be4ec8c3be4e3bcbd6fdc9cc8c3c8c3be4eac10278811eaaccec6d31c40"
const val V = "5.131"

object Endpoints {

    const val EMPTY_GET = "."
    const val GET_UNIVERSITIES = "database.getUniversities"
    const val GET_COUNTRIES = "database.getCountries"
    const val GET_CITIES = "database.getCities"

}


interface API {

    @GET(Endpoints.GET_UNIVERSITIES)
    suspend fun getUniversities(
        @Query("country_id") countryId: Int,
        @Query("city_id") cityId: Int,
        @Query("v") version: String = V,
        @Query("access_token") accessToken: String = ACCESS_TOKEN,
    ): VKRequest<University>


    @GET(Endpoints.GET_COUNTRIES)
    suspend fun getCountries(
        @Query("v") version: String = V,
        @Query("access_token") accessToken: String = ACCESS_TOKEN,
        @Query("need_all") needAll: Boolean = true,
        @Query("code") countryCodes: String
    ): VKRequest<Country>


    @GET(Endpoints.GET_CITIES)
    suspend fun getCities(
        @Query("v") version: String = V,
        @Query("access_token") accessToken: String = ACCESS_TOKEN,
        @Query("country_id") countryId: Int
    ): VKRequest<City>

}


const val ROOM_DATABASE = "room-database"

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
    fun provideConverterFactory(): Converter.Factory{
        return GsonConverterFactory.create()
    }

    @Provides
    @Singleton
    fun provideRetrofit(converterFactory: Converter.Factory): Retrofit {
        return Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(converterFactory)
            .build()
    }

    @Provides
    @Singleton
    fun provideAPI(retrofit: Retrofit): API {
        return retrofit.create(API::class.java)
    }

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




sealed class Destinations(val route: String){

    object Main: Destinations("main")

}

@Composable
fun AppNavigation() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = Destinations.Main.route
    ){
        composable(Destinations.Main.route){ MainDest(navController) }
    }
}

data class MainState(
    val screenState: ScreenState = ScreenState.None,
    val universities: List<University> = emptyList(),
    val countryField: ExpandableField<Country> = ExpandableField(currentItem = Country(1, "")),
    val cityField: ExpandableField<City> = ExpandableField(currentItem = City(1, ""))
)

data class ExpandableField<Item>(
    val currentItem: Item,
    val expanded: Boolean = false,
    val items: List<Item> = emptyList()
)


@HiltViewModel
class MainViewModel @Inject constructor(
    private val apiRepository: ApiRepository,
) : BaseViewModel<MainState>(MainState()) {


    init {
        loadCISCountries()
    }

    internal fun loadUniversities() = launchViewModelScope {
        apiRepository.getUniversities(
            cityId = stateValue.cityField.currentItem.id,
            countryId = stateValue.countryField.currentItem.id
        ).loadAndHandleData(
            onLoading = {
                updateState { copy(screenState = ScreenState.Loading) }
            },
            onSuccess = { universities ->
                updateState {
                    copy(
                        screenState = ScreenState.Success,
                        universities = universities
                    )
                }
            },
            onError = { _ ->
                updateState { copy(screenState = ScreenState.Error) }
            },
            onEmpty = {
                updateState { copy(screenState = ScreenState.Empty) }
            },
            haveDelay = true
        )
    }

    private fun loadCISCountries() = launchViewModelScope {
        apiRepository.getCountries(
            countryCodes = CIS_COUNTRIES_CODE
        ).loadAndHandleData(
            onSuccess = { countries ->
                updateState {
                    copy(
                        countryField = stateValue.countryField.copy(
                            items = countries,
                            currentItem = countries[0]
                        )
                    )
                }
            },
            haveDebug = true
        )
    }

    internal fun loadCities() = launchViewModelScope {
        apiRepository.getCities(
            countryId = stateValue.countryField.currentItem.id
        ).loadAndHandleData(
            onSuccess = { cities ->
                updateState {
                    copy(
                        screenState = ScreenState.Success,
                        cityField = cityField.copy(
                            items = cities,
                            currentItem = cities[0]
                        )
                    )
                }
            },
        )
    }

    fun clickCountryItem(itemTitle: String) =
        launchViewModelScope(dispatcher = Dispatchers.Default) {
            updateState {
                copy(
                    countryField = countryField.copy(
                        currentItem = countryField.items.find { it.title == itemTitle }!!,
                        expanded = false
                    )
                )
            }
        }

    fun changeCountryExpand() = launchViewModelScope {
        updateState {
            copy(
                countryField = countryField.copy(
                    expanded = !countryField.expanded
                )
            )
        }
    }

    fun dismissCountryMenu() = launchViewModelScope {
        updateState {
            copy(
                countryField = countryField.copy(
                    expanded = false
                )
            )
        }
    }

    fun clickCityItem(itemTitle: String) =
        launchViewModelScope(dispatcher = Dispatchers.Default) {
            updateState {
                copy(
                    cityField = cityField.copy(
                        currentItem = cityField.items.find { it.title == itemTitle }!!,
                        expanded = false
                    )
                )
            }
        }

    fun changeCityExpand() = launchViewModelScope {
        updateState {
            copy(
                cityField = cityField.copy(
                    expanded = !cityField.expanded
                )
            )
        }
    }

    fun dismissCityMenu() = launchViewModelScope {
        updateState {
            copy(
                cityField = cityField.copy(
                    expanded = false
                )
            )
        }
    }


    inline fun launchViewModelScope(
        dispatcher: CoroutineDispatcher = Dispatchers.IO,
        start: CoroutineStart = CoroutineStart.DEFAULT,
        crossinline call: suspend () -> Unit
    ) = viewModelScope.launch(dispatcher, start) {
        call()
    }


}

@Composable
fun MainDest(navController: NavController){
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(viewModel = mainViewModel, viewState = viewState)
}

@Composable
fun MainTopBar(
    modifier: Modifier = Modifier,
    countryField: ExpandableField<Country>,
    onCountryItemClick: (String) -> Unit,
    onCountryExpandedChange: (Boolean) -> Unit,
    onCountryDismiss: () -> Unit,
    cityField: ExpandableField<City>,
    onCityItemClick: (String) -> Unit,
    onCityExpandedChange: (Boolean) -> Unit,
    onCityDismiss: () -> Unit
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .shadow(elevation = 3.dp)
            .background(color = backColorPrimary)
            .padding(horizontal = 34.dp, vertical = 20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        with(countryField) {
            FieldWithDropDownMenu(
                modifier = Modifier.fillMaxWidth(),
                expanded = expanded,
                onExpandedChange = { expanded ->
                    onCountryExpandedChange(expanded)
                },
                onDismissRequest = {
                    onCountryDismiss()
                },
                onItemClick = { itemTitle ->
                    onCountryItemClick(itemTitle)
                },
                selectedItem = currentItem.title,
                menuItems = items.map { it.title }
            )
        }
        with(cityField) {
            FieldWithDropDownMenu(
                modifier = Modifier.fillMaxWidth(),
                expanded = expanded,
                onExpandedChange = { expanded ->
                    onCityExpandedChange(expanded)
                },
                onDismissRequest = {
                    onCityDismiss()
                },
                onItemClick = { itemTitle ->
                    onCityItemClick(itemTitle)
                },
                selectedItem = currentItem.title,
                menuItems = items.map { it.title }
            )
        }
    }
}

@Composable
fun MainContent(modifier: Modifier = Modifier, viewState: MainState) {
    Box(modifier = modifier
        .fillMaxSize()
        .background(color = backColorPrimary)
    ) {
        when (viewState.screenState) {
            ScreenState.Empty -> {
                InfoMessage(text = stringResource(R.string.main_empty_result))
            }

            ScreenState.Success -> {
                UniversitiesList(
                    modifier = Modifier.fillMaxSize(),
                    universities = viewState.universities
                )
            }

            ScreenState.Error -> {
                InfoMessage(text = stringResource(R.string.main_error_result))

            }

            ScreenState.Loading -> {
                LoadingIndicator(color = primaryColor, size = 40.dp, width = 4.dp)
            }

            ScreenState.None -> {}
        }
    }
}

@Composable
fun UniversitiesList(modifier: Modifier = Modifier, universities: List<University>) {
    LazyColumn(
        modifier = modifier,
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        items(universities) { university ->
            UniversityCard(
                university = university,
                modifier = Modifier
                    .fillMaxWidth(0.8f)
                    .padding(14.dp)
            )
        }
    }
}

@Composable
fun UniversityCard(modifier: Modifier = Modifier, university: University) {
    Card(
        modifier = Modifier,
        elevation = CardDefaults.elevatedCardElevation(
            defaultElevation = 2.dp
        ),
        border = BorderStroke(3.dp, color = primaryColor),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(
            containerColor = backColorPrimary,
            contentColor = backColorPrimary
        )
    ) {
        Column(
            modifier = modifier.heightIn(60.dp),
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                modifier = Modifier.align(Alignment.CenterHorizontally),
                text = university.title,
                fontSize = mediumFontSize,
                color = textColorPrimary,
                fontFamily = FontFamily.Monospace,
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
fun LoadingIndicator(
    modifier: Modifier = Modifier,
    color: Color = Color.Red,
    size: Dp = 30.dp,
    width: Dp = 3.dp
) {
    Box(modifier = modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        CircularProgressIndicator(
            modifier = Modifier.size(size),
            strokeWidth = width,
            color = color
        )
    }
}

@Composable
fun InfoMessage(
    modifier: Modifier = Modifier,
    text: String,
) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .padding(40.dp),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = text,
            fontSize = highFontSize,
            color = primaryColor
        )
    }
}
@Composable
fun MainBottomBar(modifier: Modifier = Modifier, onButtonClick: () -> Unit) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .shadow(5.dp)
            .background(color = backColorPrimary)
            .padding(vertical = 14.dp)
            .padding(bottom = 10.dp),
        horizontalArrangement = Arrangement.Center,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Button(
            modifier = Modifier.fillMaxWidth(0.8f),
            onClick = {
                onButtonClick()
            },
            shape = RectangleShape,
            contentPadding = PaddingValues(14.dp),
            colors = ButtonDefaults.buttonColors(
                containerColor = primaryColor,
                disabledContainerColor = primaryColor
            )
        ) {
            Text(
                text = stringResource(R.string.Search),
                fontSize = highFontSize,
                color = backColorPrimary
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FieldWithDropDownMenu(
    modifier: Modifier = Modifier,
    expanded: Boolean,
    onExpandedChange: (Boolean) -> Unit,
    onDismissRequest: () -> Unit,
    onItemClick: (String) -> Unit,
    selectedItem: String,
    menuItems: List<String>
) {
    ExposedDropdownMenuBox(
        modifier = modifier,
        expanded = expanded,
        onExpandedChange = onExpandedChange
    ) {
        OutlinedTextField(
            modifier = Modifier
                .fillMaxWidth()
                .menuAnchor(),
            value = selectedItem,
            onValueChange = {},
            readOnly = true,
            trailingIcon = {
                ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded)
            },
            colors = OutlinedTextFieldDefaults.colors(
                focusedTrailingIconColor = primaryColor,
                unfocusedTrailingIconColor = primaryColor,
                focusedTextColor = textColorPrimary,
                unfocusedTextColor = textColorPrimary,
                cursorColor = primaryColor,
                focusedBorderColor = primaryColor,
                unfocusedBorderColor = primaryColor
            ),
            textStyle = TextStyle(
                fontSize = mediumFontSize
            )
        )
        ExposedDropdownMenu(
            modifier = Modifier.fillMaxWidth(),
            expanded = expanded,
            onDismissRequest = onDismissRequest
        ) {
            menuItems.forEach { item ->
                DropdownMenuItem(
                    modifier = Modifier.fillMaxWidth(),
                    text = {
                        Text(text = item, color = textColorPrimary, fontSize = lowFontSize)
                    },
                    onClick = {
                        onItemClick(item)
                    },
                    colors = MenuDefaults.itemColors(

                    )
                )
            }
        }
    }
}

@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    Scaffold(
        bottomBar = {
            MainBottomBar(
                onButtonClick = {
                    viewModel.loadUniversities()
                }
            )
        },
        topBar = {
            MainTopBar(
                countryField = viewState.countryField,
                cityField = viewState.cityField,
                onCountryItemClick = { itemTitle ->
                    viewModel.clickCountryItem(itemTitle)
                },
                onCountryDismiss = {
                    viewModel.dismissCountryMenu()
                },
                onCountryExpandedChange = { _ ->
                    viewModel.changeCountryExpand()
                },
                onCityItemClick = { cityTitle ->
                    viewModel.clickCityItem(cityTitle)
                },
                onCityDismiss = {
                    viewModel.dismissCityMenu()
                },
                onCityExpandedChange = {
                    viewModel.changeCityExpand()
                }
            )
        }
    ) { scaffoldPaddings ->
        MainContent(
            modifier = Modifier.padding(scaffoldPaddings),
            viewState = viewState
        )
    }
    LaunchedEffect(viewState.countryField.currentItem) {
        viewModel.loadCities()
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: """
import androidx.compose.runtime.SideEffect
import \(mainData.packageName).presentation.fragments.main_fragment.AppNavigation
import \(mainData.packageName).presentation.fragments.main_fragment.backColorPrimary
import com.google.accompanist.systemuicontroller.rememberSystemUiController
""",
                content: """
                AppNavigation()
                val systemUiController = rememberSystemUiController()
                SideEffect {
                    systemUiController.setSystemBarsColor(
                        color = backColorPrimary,
                        darkIcons = true
                    )
                }
"""
            ),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: ANDStringsData(
                additional: """
    <string name="Search">Search</string>
    <string name="main_empty_result">There were no suitable universities</string>
    <string name="main_error_result">Data loading error</string>
"""
            ),
            colorsData: .empty
        )
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

        manifestPlaceholders = [
                appAuthRedirectScheme: 'com.example.sample'
        ]

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

    implementation 'com.squareup.retrofit2:converter-scalars:2.9.0'
    //Base
    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material


    //Compose
    implementation Dependencies.compose_ui
//    implementation Dependencies.compose_material
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_material3_window_size
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_hilt_nav
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

    //Internet
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson

    //Room
    kapt Dependencies.room_compiler
    implementation Dependencies.room_runtime
    implementation Dependencies.room_ktx

//    //implementation "com.vk:oauth-vk:0.109-24422"
//    implementation "com.vk:vksdk-pub:0.109-24422"



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
    const val compose_material3 = "androidx.compose.material3:material3:1.1.1"
    const val compose_material3_window_size = "androidx.compose.material3:material3-window-size-class:1.1.1"
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
