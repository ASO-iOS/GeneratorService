//
//  File.swift
//  
//
//  Created by admin on 31.10.2023.
//

import Foundation

struct KDGallery: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.util.Log
import androidx.lifecycle.viewModelScope
import androidx.paging.cachedIn
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import \(packageName).R
import androidx.compose.runtime.collectAsState
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import androidx.paging.PagingData
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emptyFlow
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.paging.compose.LazyPagingItems
import androidx.compose.ui.layout.ContentScale
import coil.compose.SubcomposeAsyncImage
import androidx.paging.LoadState
import androidx.paging.compose.collectAsLazyPagingItems
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.runtime.SideEffect
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import retrofit2.http.GET
import retrofit2.http.Query
import com.google.gson.annotations.SerializedName
import androidx.annotation.Keep
import androidx.paging.Pager
import androidx.paging.PagingConfig
import androidx.paging.PagingSource
import androidx.paging.PagingState
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import okhttp3.logging.HttpLoggingInterceptor.Level.BODY
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton
import dagger.Binds
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))

val headline1 = TextStyle(
    fontSize = 40.sp,
    fontWeight = FontWeight.Normal,
    fontFamily = Font(R.font.lilitaone_regular).toFontFamily()
)

val headline3 = TextStyle(
    fontFamily = Font(R.font.arvo_bold).toFontFamily(),
    fontSize = 24.sp,
    fontWeight = FontWeight.Bold
)

val headline4 = TextStyle(
    fontFamily = Font(R.font.arvo_bold).toFontFamily(),
    fontSize = 20.sp,
    fontWeight = FontWeight.Bold
)


val defaultShape = RoundedCornerShape(7.dp)
val buttonShape = RoundedCornerShape(25.dp)
val bottomBarShape = RoundedCornerShape(topStart = 50.dp, topEnd = 50.dp)

interface UseCase
abstract class AsyncUseCase(
    private val dispatcher: CoroutineDispatcher = Dispatchers.IO
): UseCase
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

fun Any?.logDebug(){
    if(this is Throwable?){
        Log.e(DEBUG, toString())
    }else{
        Log.i(DEBUG, toString())
    }
}


object DebugMessage {
    const val LOADING = "Loading"
    const val SUCCESS = "Success: "
    const val ERROR = "Error: "
    const val EMPTY = "Empty"
}



suspend inline fun<T> Result<T>.loadAndHandleData(
    haveDebug: Boolean = false,
    onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    if(haveDebug) DebugMessage.LOADING.logDebug()
    resultHandler(
        onSuccess = {result ->
            if(haveDebug) (DebugMessage.SUCCESS + result).logDebug()
            onSuccess(result)
        },
        onEmpty = {
            if(haveDebug) DebugMessage.EMPTY.logDebug()
            onEmpty()
        },
        onError = {error ->
            if(haveDebug) (DebugMessage.ERROR + error.message).logDebug()
            onError(error)
        }
    )
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
        else if(value.toString().isEmpty()){
            onEmpty()
        }
        else{
            onSuccess(value)
        }
    }
    onFailure { error ->
        onError(error)
    }
}

@Composable
fun LoadingIndicator(
    modifier: Modifier = Modifier,
    color: Color,
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
sealed interface UIState{

    object Success: UIState
    object Error: UIState
    object Empty: UIState
    object Loading: UIState
    object None: UIState

}
data class VKPhoto(
    val id: Int,
    val url: String,
    val height: Int,
    val width: Int
)



private const val RADIUS_VALUE = 1000000
interface ApiRepository {

    fun getPhotos(
        searchQuery: String,
        lat: String, long: String,
        startTime: Int = 0, endTime: Int = 0,
        sort: Int = 1,
        offset: Int,
        radius: Int = RADIUS_VALUE
    ): Flow<PagingData<VKPhoto>>

}

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
    fun provideOkHttpClient() =
        OkHttpClient.Builder()
            .addInterceptor(HttpLoggingInterceptor().apply { level = BODY })
            .build()

    @Provides
    @Singleton
    fun provideApi(okHttpClient: OkHttpClient): VKApi = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .client(okHttpClient)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(VKApi::class.java)

}
val VKRequest.mapToVKPhotos: List<VKPhoto>
    get() {
        val photos = response.items?.map { item ->
            val size = item.sizes.max()
            VKPhoto(
                id = item.id,
                url = size.url,
                height = size.height,
                width = size.width
            )
        }
        return photos ?: emptyList()
    }



class PhotoPagingSource(
    private val offsetKey: Int,
    private val backendQuery: suspend (offset: Int) -> VKRequest
) : PagingSource<Int, VKPhoto>() {


    override suspend fun load(params: LoadParams<Int>): LoadResult<Int, VKPhoto> {
        return try {
            val key = params.key ?: 0
            val photos = backendQuery(key).mapToVKPhotos
            LoadResult.Page(
                data = photos,
                prevKey = null,
                nextKey = key.plus(offsetKey)
            )
        } catch (ex: Exception) {
            LoadResult.Error(ex)
        }
    }

    override fun getRefreshKey(state: PagingState<Int, VKPhoto>): Int {
        return state.anchorPosition?.let { position ->
            state.pages[position - 1].nextKey ?: state.pages[position + 1].prevKey
        } ?: 0
    }
}
class ApiRepositoryImpl @Inject constructor(private val apiVK: VKApi) : ApiRepository {
    override fun getPhotos(
        searchQuery: String,
        lat: String, long: String,
        startTime: Int, endTime: Int,
        sort: Int,
        offset: Int,
        radius: Int
    ): Flow<PagingData<VKPhoto>> {
        return Pager(
            config = PagingConfig(
                pageSize = offset,
                enablePlaceholders = true,
                maxSize = 1000
            ),
            initialKey = 0,
            pagingSourceFactory = {
                PhotoPagingSource(
                    offsetKey = offset,
                    backendQuery = { offset ->
                        apiVK.getPhotos(
                            sort = sort, count = offset,
                            endTime = endTime, startTime = startTime,
                            lat = lat, long = long,
                            offset = offset,
                            searchQuery = searchQuery, radius = radius
                        )
                    }
                )
            }
        ).flow
    }
}



@Keep
data class Item(
    @SerializedName("album_id")
    val albumId: Int,
    @SerializedName("date")
    val date: Int,
    @SerializedName("id")
    val id: Int,
    @SerializedName("owner_id")
    val ownerId: Int,
    @SerializedName("sizes")
    val sizes: List<Size>,
    @SerializedName("text")
    val text: String,
    @SerializedName("has_tags")
    val hasTags: Boolean
)
@Keep
data class Response(
    @SerializedName("count")
    val count: Int,
    @SerializedName("items")
    val items: List<Item>?
)

fun avgSum(height: Int, width: Int): Double = ((height + width).toDouble() / 2)

@Keep
data class Size(
    @SerializedName("height")
    val height: Int,
    @SerializedName("type")
    val type: String,
    @SerializedName("url")
    val url: String,
    @SerializedName("width")
    val width: Int
) : Comparable<Size> {
    override fun compareTo(other: Size): Int {
        val me: Double = avgSum(height, width)
        val alien: Double = avgSum(other.height, other.width)
        return me.compareTo(alien)
    }
}
@Keep
data class VKRequest(
    @SerializedName("response")
    val response: Response,
)

const val BASE_URL = "https://api.vk.com/method/"
val accessKey: String = Data.getToken()


object Data {

    fun getToken(): String = "35296966352969663529696656363c3f0b335293529696651f5c0944fb14563a574ba5d"
}

const val Version = "5.131"

object Call {

    const val EMPTY_GET = "."
    const val GET_PHOTOS = "photos.search"

}

object Params {

    const val ACCESS_TOKEN = "access_token"
    const val V = "v"
    const val Q = "q"
    const val OFFSET = "offset"
    const val LAT = "lat"
    const val LONG = "long"
    const val COUNT = "count"
    const val START_TIME = "start_time"
    const val END_TIME = "end_time"
    const val SORT = "sort"
    const val RADIUS = "radius"

}
interface VKApi {


    @GET(Call.GET_PHOTOS)
    suspend fun getPhotos(
        @Query(Params.ACCESS_TOKEN) accessToken: String = accessKey,
        @Query(Params.V) v: String = Version,
        @Query(Params.Q) searchQuery: String,
        @Query(Params.LAT) lat: String,
        @Query(Params.LONG) long: String,
        @Query(Params.START_TIME) startTime: Int,
        @Query(Params.END_TIME) endTime: Int,
        @Query(Params.SORT) sort: Int,
        @Query(Params.OFFSET) offset: Int,
        @Query(Params.COUNT) count: Int,
        @Query(Params.RADIUS) radius: Int
    ): VKRequest

}
sealed class Destinations(val route: String){

    object Main: Destinations(Routes.MAIN)

}

object Routes {

    const val MAIN = "main"

}

@Composable
fun AppNavigation() {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = Destinations.Main.route
    ){
        composable(Destinations.Main.route){ MainDest(navController) }
    }

    SideEffect {
        systemUiController.setSystemBarsColor(
            color = backColorPrimary,
            darkIcons = true
        )
    }
}
@Composable
fun CountryButton(
    modifier: Modifier = Modifier,
    country: Country,
    onClick: (Country) -> Unit,
    checkingSelection: (Country) -> Boolean
) {
    val selected = checkingSelection(country)
    Button(
        modifier = modifier,
        onClick = {
            onClick(country)
        },
        colors = ButtonDefaults.buttonColors(
            containerColor = if (selected) buttonColorPrimary else backColorSecondary,
            disabledContainerColor = if (selected) buttonColorPrimary else backColorSecondary,
        ),
        shape = buttonShape
    ) {
        Text(text = country.title, color = backColorPrimary, style = headline4)
    }
}

@Composable
fun CountryList(
    modifier: Modifier = Modifier,
    countries: List<Country>,
    onCountryItemClick: (Country) -> Unit,
    onButtonSelected: (Country) -> Boolean
) {
    LazyColumn(
        modifier = modifier.fillMaxSize(),
        contentPadding = PaddingValues(top = 24.dp, bottom = 40.dp, start = 20.dp, end = 20.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        items(countries) { country ->
            CountryButton(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(59.dp),
                country = country,
                onClick = onCountryItemClick,
                checkingSelection = onButtonSelected
            )
        }
    }
}
@Composable
fun MainContent(modifier: Modifier = Modifier, viewModel: MainViewModel, viewState: MainState) {
    val lazyPaddingPhotos = viewState.pagingPhotos.collectAsLazyPagingItems()
    when (lazyPaddingPhotos.loadState.refresh) {
        is LoadState.Error -> {
            viewModel.updateScreenState(UIState.Error)
        }
        LoadState.Loading -> {
            viewModel.updateScreenState(UIState.Loading)
        }
        is LoadState.NotLoading -> {
            if (lazyPaddingPhotos.itemSnapshotList.isEmpty()) {
                viewModel.updateScreenState(UIState.Empty)
            } else viewModel.updateScreenState(UIState.Success)
        }
    }
    when (viewState.screenState) {
        UIState.Loading -> {
            LoadingIndicator(
                color = textColorSecondary,
                modifier = modifier,
                width = 4.dp,
                size = 40.dp
            )
        }
        UIState.Success -> {
            PhotosGreed(
                modifier = modifier,
                photos = lazyPaddingPhotos
            )
        }
        else -> {}
    }
}
@Composable
fun MainTopBar(modifier: Modifier = Modifier) {
    Row(
        modifier = modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.Center,
    ) {
        Text(text = stringResource(R.string.app_name), color = textColorSecondary, style = headline1)
    }
}
@Composable
fun PhotoCard(modifier: Modifier = Modifier, photo: VKPhoto) {
    Box(modifier = modifier
        .clip(defaultShape)) {
        SubcomposeAsyncImage(
            modifier = Modifier
                .height(200.dp)
                .fillMaxWidth()
                .clip(defaultShape),
            model = photo.url,
            contentDescription = null,
            contentScale = ContentScale.Crop,
            loading = {
                LoadingIndicator(color = textColorSecondary)
            }
        )
    }
}
@Composable
fun PhotosGreed(modifier: Modifier = Modifier, photos: LazyPagingItems<VKPhoto>) {
    LazyVerticalGrid(
        modifier = modifier.fillMaxSize(),
        columns = GridCells.Fixed(2),
        contentPadding = PaddingValues(horizontal = 20.dp, vertical = 12.dp),
        horizontalArrangement = Arrangement.spacedBy(10.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        items(photos.itemCount) { index ->
            PhotoCard(photo = photos[index]!!)
        }
    }
}

val countriesData = listOf<Country>(
    Country(
        title = "Россия",
        "55.7522",
        "37.6156",
    ),
    Country(
        title = "Беларусь",
        "53.9",
        "27.5667",
    ),
    Country(
        title = "Грузия",
        "41.693083", "44.801561"
    ),
    Country(
        title = "Швецария",
        "46.947978", "7.440386"
    ),
    Country(
        title = "Армения",
        "40.177628", "44.512546"
    ),
    Country(
        "Сербия",
        "44.816236", "20.460467"

    )
)

data class MainState(
    val pagingPhotos: Flow<PagingData<VKPhoto>> = emptyFlow(),
    val screenState: UIState = UIState.Success,
    val openBottomSheet: Boolean = false,
    val search: String = "",
    val countries: List<Country> = countriesData,
    val currentCountry: Country = countries.first(),
    val memory: MainMemory = MainMemory(search, currentCountry)
)

data class MainMemory(
    val search: String,
    val currentCountry: Country
)

data class Country(
    val title: String,
    val latitude: String,
    val longitude: String,
)
@Composable
fun MainDest(navController: NavController){
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(
        viewModel = mainViewModel,
        viewState = viewState
    )
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    Scaffold(
        topBar = {
            MainTopBar(modifier = Modifier.padding(top = 36.dp, bottom = 12.dp))
        },
        bottomBar = {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(80.dp)
                    .clip(shape = bottomBarShape)
                    .background(color = backColorPrimary)
                    .padding(top = 16.dp, bottom = 10.dp)
                    .padding(horizontal = 35.dp),
            ) {
                Button(
                    modifier = Modifier.fillMaxSize(),
                    onClick = {
                        viewModel.openBottomSheet()
                    },
                    content = {
                        Icon(
                            imageVector = Icons.Default.Settings,
                            contentDescription = null,
                            tint = backColorPrimary
                        )
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = stringResource(R.string.settings),
                            style = headline3,
                            color = backColorPrimary
                        )
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = textColorSecondary,
                        disabledContainerColor = textColorSecondary,
                    )
                )
            }
        },
        containerColor = backColorPrimary
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .padding(top = paddingValues.calculateTopPadding())
                .fillMaxSize()
        ) {
            MainContent(
                modifier = Modifier.fillMaxSize(),
                viewModel = viewModel, viewState = viewState
            )
            if (viewState.openBottomSheet) {
                ModalBottomSheet(
                    modifier = Modifier
                        .fillMaxHeight(0.65f)
                        .padding(top = 30.dp),
                    onDismissRequest = {
                        viewModel.disableBottomSheet()
                    },
                    containerColor = backColorPrimary,
                    shape = bottomBarShape
                ) {
                    BasicTextField(
                        value = viewState.search,
                        onValueChange = { newStr ->
                            viewModel.changeSearchField(newStr)
                        },
                        modifier = Modifier
                            .padding(horizontal = 20.dp)
                            .fillMaxWidth()
                            .height(59.dp)
                            .background(
                                color = backColorSecondary,
                                shape = buttonShape
                            )
                            .padding(horizontal = 10.dp),
                        maxLines = 1,
                        textStyle = headline4.copy(color = textColorSecondary),
                        cursorBrush = SolidColor(textColorSecondary),
                        keyboardOptions = KeyboardOptions(
                            imeAction = ImeAction.Send,
                        ),
                        keyboardActions = KeyboardActions(
                            onSend = {
                                viewModel.disableBottomSheet()
                                viewModel.checkingForChanges()
                            },
                        )
                    ) { innerTextField ->
                        Row(
                            modifier = Modifier.fillMaxSize(),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Icon(
                                imageVector = Icons.Default.Search,
                                contentDescription = null,
                                tint = textColorSecondary,
                                modifier = Modifier.size(30.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Box(contentAlignment = Alignment.CenterStart) {
                                if (viewState.search.isEmpty()) {
                                    Text(
                                        text = "Поиск по ключевым словам",
                                        style = headline4.copy(color = textColorSecondary)
                                    )
                                }
                                innerTextField()
                            }
                        }
                    }
                    CountryList(
                        modifier = Modifier.padding(top = 10.dp, bottom = 6.dp),
                        countries = viewState.countries,
                        onCountryItemClick = { country ->
                            viewModel.clickCountryButton(country)
                        },
                        onButtonSelected = { country ->
                            viewModel.checkSelectedButton(country)
                        }
                    )
                }
            }
        }
    }
    LaunchedEffect(key1 = viewState.openBottomSheet) {
        viewModel.checkingForChanges()
    }
}


@HiltViewModel
class MainViewModel @Inject constructor(private val vkRepository: ApiRepository) :
    BaseViewModel<MainState>(MainState()) {

    init {
        loadPhotos()
    }

    private fun loadPhotos() = viewModelScope.launch(Dispatchers.IO) {
        with(stateValue.currentCountry) {
            updateState {
                copy(
                    pagingPhotos = vkRepository.getPhotos(
                        searchQuery = search,
                        lat = latitude,
                        long = longitude,
                        offset = 30
                    ).cachedIn(viewModelScope)
                )
            }
        }
    }

    fun openBottomSheet() = viewModelScope.launch {
        updateState {
            copy(
                openBottomSheet = true,
                memory = MainMemory(search, currentCountry)
            )
        }
    }

    fun disableBottomSheet() = viewModelScope.launch {
        updateState {
            copy(
                openBottomSheet = false
            )
        }
    }

    fun changeSearchField(newStr: String) = viewModelScope.launch {
        updateState {
            copy(
                search = newStr
            )
        }
    }

    fun clickCountryButton(country: Country) = viewModelScope.launch {
        updateState {
            copy(
                currentCountry = stateValue.countries.first { it == country }!!
            )
        }
    }

    fun checkSelectedButton(country: Country): Boolean {
        return stateValue.currentCountry == country
    }

    fun checkingForChanges() = viewModelScope.launch {
        val memory = stateValue.memory
        val haveChanges =
            memory.currentCountry != stateValue.currentCountry || memory.search != stateValue.search
        if (haveChanges) {
            loadPhotos()
        }

    }

    fun updateScreenState(state: UIState) = viewModelScope.launch {
        updateState {
            copy(
                screenState = state
            )
        }
    }


}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
                    AppNavigation()
        """
            ),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: ANDStringsData(
                additional: """
    <string name="settings">Settings</string>
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
    //implementation Dependencies.compose_material
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

    implementation("io.coil-kt:coil-compose:2.4.0")
    implementation Dependencies.paging
    implementation Dependencies.pagingCompose
    implementation Dependencies.okhttp_login_interceptor

    //DI
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_hilt_nav

    //Internet
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson

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
    
    
}
