//
//  File.swift
//  
//
//  Created by admin on 11/9/23.
//

import Foundation

struct KDConverter: FileProviderProtocol {
    
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.util.Log
import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.SwapVert
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuBoxScope
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
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
import retrofit2.http.Header
import retrofit2.http.Query
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))

val header = TextStyle(
    fontSize = 18.sp,
    fontWeight = FontWeight.Bold,
)

val dropItemText = TextStyle(
    fontSize = 12.sp,
    fontWeight = FontWeight.Bold,
)

val converterField = TextStyle(
    fontSize = 14.sp,
    fontWeight = FontWeight.Normal,
)

val currency = TextStyle(
    fontSize = 14.sp,
    fontWeight = FontWeight.Bold,
)

val headline5 = TextStyle(

)

val headline6 = TextStyle(

)


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



val defaultShape = RoundedCornerShape(17.dp)
val miniShape = RoundedCornerShape(5.dp)
sealed interface UIState{

    object Success: UIState
    object Error: UIState
    object Empty: UIState
    object Loading: UIState
    object None: UIState

}
interface ApiRepository {
    suspend fun getConvertCurrency(have: String, want: String, amount: Double): Result<Currency>
}
@JvmInline
value class Currency(val value: Double)


fun CurrencyResponse.mapToCurrency(): Currency = Currency(newAmount)

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

class ApiRepositoryImpl @Inject constructor(private val api: API) : ApiRepository {
    override suspend fun getConvertCurrency(
        have: String, want: String, amount: Double
    ): Result<Currency> = runCatching {
        api.getConvertedCurrency(have = have, want = want, amount = amount).mapToCurrency()
    }


}
interface API {


    @GET(Endpoints.GET_CONVERT_CURRENCY)
    suspend fun getConvertedCurrency(
        @Header(Attributes.ACCESS_TOKEN) accessToken: String = accessKey,
        @Query(Attributes.HAVE) have: String,
        @Query(Attributes.WANT) want: String,
        @Query(Attributes.AMOUNT) amount: Double
    ): CurrencyResponse

}
@Keep
data class CurrencyResponse(
    @SerializedName("new_amount")
    val newAmount: Double,
    @SerializedName("new_currency")
    val newCurrency: String,
    @SerializedName("old_amount")
    val oldAmount: Int,
    @SerializedName("old_currency")
    val oldCurrency: String
)

const val BASE_URL = "https://api.api-ninjas.com/v1/"
val accessKey: String
    get() = getApiKey()

fun getApiKey(): String = "bKe9rRxKekxT/m1+RLSNAg==SGmk5un9bGeb8FTY"

object Endpoints {

    const val EMPTY = "."
    const val GET_CONVERT_CURRENCY = "convertcurrency"

}

object Attributes {

    const val ACCESS_TOKEN = "X-Api-Key"
    const val HAVE = "have"
    const val WANT = "want"
    const val AMOUNT = "amount"

}
sealed class Destinations(val route: String){

    object Main: Destinations(Routes.MAIN){

        fun templateRoute(): String{
            return route
        }

        fun requestRoute(): String{
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
            .fillMaxSize()
            .background(color = backColorPrimary),
        navController = navController,
        startDestination = Destinations.Main.route
    ) {
        composable(Destinations.Main.route) { MainDest(navController) }
    }

    SideEffect {
        systemUiController.run {
            setStatusBarColor(
                color = backColorSecondary,
                darkIcons = false
            )
            setNavigationBarColor(
                color = backColorPrimary,
                darkIcons = true
            )
        }
    }
}


enum class CountryM(
    val stringId: Int,
    val stringIdFullName: Int,
    val requestStr: String
) {
    USD(
        stringId = R.string.usd,
        stringIdFullName = R.string.usd_f,
        requestStr = "USD"
    ),
    EUR(
        stringId = R.string.eur,
        stringIdFullName = R.string.eur_f,
        requestStr = "EUR"
    ),
    RUB(
        stringId = R.string.rub,
        stringIdFullName = R.string.rub_f,
        requestStr = "RUB"
    ),
    JPY(
        stringId = R.string.jpy,
        stringIdFullName = R.string.jpy_f,
        requestStr = "JPY"
    ),
    RSD(
        stringId = R.string.rsd,
        stringIdFullName = R.string.rsd_f,
        requestStr = "RSD"
    ),
    AUD(
        stringId = R.string.aud,
        stringIdFullName = R.string.aud_f,
        requestStr = "AUD"
    ),
    GBP(
        stringId = R.string.gbp,
        stringIdFullName = R.string.gbp_f,
        requestStr = "GBP"
    ),
    BYN(
        stringId = R.string.byn,
        stringIdFullName = R.string.byn_f,
        requestStr = "BYN"
    ),
    UAH(
        stringId = R.string.uah,
        stringIdFullName = R.string.uah_f,
        requestStr = "UAH"
    )

}


val countries = CountryM.values().toList()


data class MainState(
    val haveExpandable: ExpandableElement<CountryM> = ExpandableElement(
        items = countries,
        currentItem = countries.first() ,
    ),
    val wantExpandable: ExpandableElement<CountryM> = ExpandableElement(
        items = countries,
        currentItem = countries.first(),
    ),
    val amount: String = "",
    val result: String = ""
)

data class ExpandableElement<Item>(
    val currentItem: Item,
    val expanded: Boolean = false,
    val items: List<Item> = emptyList()
)



@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainTopBar(modifier: Modifier = Modifier) {
    CenterAlignedTopAppBar(
        modifier = modifier,
        title = {
            Text(
                text = stringResource(id = R.string.app_name),
                color = backColorPrimary,
                style = header,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
        },
        colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
            containerColor = backColorSecondary
        )
    )
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    Column(
        modifier = modifier
            .padding(horizontal = 30.dp, vertical = 10.dp)
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        val haveCountry = viewState.haveExpandable
        Spacer(modifier = Modifier.weight(5f))
        ExposedCountry(
            currentItem = haveCountry.currentItem,
            expanded = haveCountry.expanded,
            onExpandedChange = {},
            menuItems = haveCountry.items,
            onItemClick = { haveItem ->
                viewModel.clickedHaveItem(haveItem)
            },
            onDismissRequest = {
                viewModel.dismissedHave()
            }
        ) { haveCurrentItem ->
            ConvertedTextField(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(60.dp)
                    .clip(miniShape)
                    .menuAnchor(),
                text = viewState.amount,
                onTextChanged = { text ->
                    viewModel.changedAmount(text)
                },
                currentCurrency = haveCurrentItem,
                onExpanded = {
                    viewModel.expandedHave(!viewState.haveExpandable.expanded)
                }
            )
        }
        Spacer(modifier = Modifier.weight(0.5f))
        MainButton(
            modifier = Modifier.fillMaxWidth(), onClick = {
                viewModel.clickedCovertCurrency()
            }
        )
        Spacer(modifier = Modifier.weight(0.5f))
        val wantCountry = viewState.wantExpandable
        ExposedCountry(
            currentItem = wantCountry.currentItem,
            expanded = wantCountry.expanded,
            onExpandedChange = {},
            menuItems = wantCountry.items,
            onItemClick = { wantItem ->
                viewModel.clickedWantItem(wantItem)
            },
            onDismissRequest = {
                viewModel.dismissedWant()
            }
        ) { wantCurrentItem ->
            ConvertedTextField(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(60.dp)
                    .clip(miniShape)
                    .menuAnchor(),
                text = viewState.result,
                onTextChanged = {},
                currentCurrency = wantCurrentItem,
                onExpanded = {
                    viewModel.expandedWant(!viewState.wantExpandable.expanded)
                },
                onlyRead = true
            )
        }
        Spacer(modifier = Modifier.weight(5f))
    }
}
@Composable
fun MainButton(modifier: Modifier = Modifier, onClick: () -> Unit) {
    FilledTonalButton(
        modifier = modifier,
        onClick = {
            onClick()
        },
        colors = ButtonDefaults.filledTonalButtonColors(
            containerColor = buttonColorPrimary,
            disabledContainerColor = buttonColorPrimary
        ),
        contentPadding = PaddingValues(10.dp),
        shape = defaultShape
    ) {
        Icon(
            imageVector = Icons.Default.SwapVert,
            contentDescription = null,
            tint = backColorPrimary
        )
    }
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExposedCountry(
    currentItem: CountryM,
    expanded: Boolean,
    onExpandedChange: (Boolean) -> Unit,
    menuItems: List<CountryM>,
    onItemClick: (CountryM) -> Unit,
    onDismissRequest: () -> Unit,
    element: @Composable ExposedDropdownMenuBoxScope.(currentItem: CountryM) -> Unit
) {
    ExposedDropdownMenuBox(
        modifier = Modifier.clip(miniShape),
        expanded = expanded,
        onExpandedChange = onExpandedChange
    ) {
        element(currentItem)
        ExposedDropdownMenu(
            modifier = Modifier.background(color = buttonColorSecondary, shape = miniShape),
            expanded = expanded,
            onDismissRequest = onDismissRequest
        ) {
            Spacer(modifier = Modifier.height(25.dp))
            menuItems.forEach { countryModel ->
                DropdownMenuItem(
                    modifier = Modifier
                        .padding(horizontal = 30.dp)
                        .fillMaxWidth()
                        .border(
                            width = 2.dp,
                            color = backColorPrimary,
                            shape = defaultShape
                        ),
                    text = {
                        FillingItem(
                            modifier = Modifier.fillMaxWidth(),
                            countryModel = countryModel
                        )
                    },
                    onClick = {
                        onItemClick(countryModel)
                    },
                    contentPadding = PaddingValues(vertical = 6.dp, horizontal = 10.dp)
                )
                Spacer(modifier = Modifier.height(10.dp))
            }
            Spacer(modifier = Modifier.height(15.dp))
        }
    }
}

@Composable
fun FillingItem(modifier: Modifier = Modifier, countryModel: CountryM) {
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Center
    ) {
        Text(
            text = stringResource(id = countryModel.stringId),
            style = currency,
            textAlign = TextAlign.Center,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            color = backColorPrimary
        )
        Spacer(modifier = Modifier.width(10.dp))
        Text(
            text = stringResource(id = countryModel.stringIdFullName),
            style = dropItemText,
            textAlign = TextAlign.Center,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            color = textColorSecondary
        )
    }
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExposedDropdownMenuBoxScope.ConvertedTextField(
    modifier: Modifier = Modifier,
    text: String,
    onTextChanged: (String) -> Unit,
    currentCurrency: CountryM,
    onExpanded: () -> Unit,
    onlyRead: Boolean = false
) {
    Row(modifier = modifier, verticalAlignment = Alignment.CenterVertically) {
        TextField(
            value = text,
            onValueChange = onTextChanged,
            colors = TextFieldDefaults.colors(
                unfocusedIndicatorColor = surfaceColor,
                focusedIndicatorColor = surfaceColor,
                unfocusedContainerColor = surfaceColor,
                focusedContainerColor = surfaceColor,
                unfocusedTextColor = textColorPrimary,
                focusedTextColor = textColorPrimary,
                cursorColor = textColorPrimary,
            ),
            singleLine = true,
            modifier = Modifier
                .weight(3f)
                .fillMaxHeight(),
            textStyle = converterField.copy(
                textAlign = TextAlign.End
            ),
            keyboardOptions = KeyboardOptions(
                keyboardType = KeyboardType.Number
            ),
            shape = RectangleShape,
            readOnly = onlyRead
        )
        FilledTonalButton(
            modifier = Modifier
                .fillMaxHeight()
                .weight(1.3f)
            ,
            onClick = {
                onExpanded()
            },
            shape = miniShape,
            colors = ButtonDefaults.filledTonalButtonColors(
                containerColor = buttonColorSecondary,
                disabledContainerColor = buttonColorSecondary
            ),
            contentPadding = PaddingValues(2.dp)
        ) {
            Text(
                text = stringResource(id = currentCurrency.stringId),
                color = backColorPrimary,
                style = currency,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
            Icon(
                imageVector = Icons.Default.KeyboardArrowDown,
                contentDescription = null,
                tint = backColorPrimary
            )
        }
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(private val api: ApiRepository) :
    BaseViewModel<MainState>(MainState()) {


    fun clickedCovertCurrency() = viewModelScope.launch(Dispatchers.IO) {
        val call = suspend {
            api.getConvertCurrency(
                have = stateValue.haveExpandable.currentItem.requestStr,
                want = stateValue.wantExpandable.currentItem.requestStr,
                amount = stateValue.amount.toDoubleOrNull() ?: updateState {
                    copy(amount = "1.0")
                }.run { 0.0 }
            )
        }
        call.loadAndHandleData(
            onSuccess = { currency ->
                updateState {
                    copy(
                        result = currency.value.toString()
                    )
                }
            },
        )
    }

    fun expandedWant(value: Boolean) = viewModelScope.launch {
        updateState {
            copy(
                wantExpandable = wantExpandable.copy(
                    expanded = value
                )
            )
        }
    }

    fun dismissedWant() = viewModelScope.launch {
        updateState {
            copy(
                wantExpandable = wantExpandable.copy(
                    expanded = false
                )
            )
        }
    }

    fun clickedWantItem(wantItem: CountryM) = viewModelScope.launch {
        updateState {
            copy(
                wantExpandable = wantExpandable.copy(
                    currentItem = wantExpandable.items.find { it == wantItem }!!,
                    expanded = false
                )
            )
        }
    }

    fun expandedHave(value: Boolean) = viewModelScope.launch {
        updateState {
            copy(
                haveExpandable = haveExpandable.copy(
                    expanded = value
                )
            )
        }
    }

    fun dismissedHave() = viewModelScope.launch {
        updateState {
            copy(
                haveExpandable = haveExpandable.copy(
                    expanded = false
                )
            )
        }
    }

    fun clickedHaveItem(haveItem: CountryM) = viewModelScope.launch {
        updateState {
            copy(
                haveExpandable = haveExpandable.copy(
                    currentItem = haveExpandable.items.find { it == haveItem }!!,
                    expanded = false
                )
            )
        }
    }

    fun changedAmount(text: String) = viewModelScope.launch {
        updateState {
            copy(
                amount = text
            )
        }
    }

}
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            MainTopBar()
        }
    ) {
        MainContent(
            modifier = Modifier
                .padding(it)
                .fillMaxSize(),
            viewModel = viewModel,
            viewState = viewState
        )
    }
}
@Composable
fun MainDest(navController: NavController){
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(viewModel = mainViewModel, viewState = viewState)
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
    <string name="usd">USD</string>
    <string name="eur">EUR</string>
    <string name="rub">RUB</string>
    <string name="rsd">RSD</string>
    <string name="jpy">JPY</string>
    <string name="aud">AUD</string>
    <string name="byn">BYN</string>
    <string name="uah">UAH</string>
    <string name="gbp_f">Pound Sterling</string>
    <string name="usd_f">Dollars</string>
    <string name="eur_f">Euro</string>
    <string name="rub_f">Ruble</string>
    <string name="rsd_f">Serbian Dinar</string>
    <string name="jpy_f">Japanese Yen</string>
    <string name="aud_f">Australian Dollar</string>
    <string name="byn_f">Belarusian Ruble</string>
    <string name="uah_f">Hryvnia</string>
    <string name="gbp">GBP</string>
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
    const val okhttp = "4.10.0"
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
