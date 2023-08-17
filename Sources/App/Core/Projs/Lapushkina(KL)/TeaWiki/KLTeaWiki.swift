//
//  File.swift
//  
//
//  Created by admin on 17.08.2023.
//

import Foundation

struct KLTeaWiki: FileProviderProtocol {
    static var fileName: String = "KLTeaWiki.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.activity.OnBackPressedCallback
import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import com.bumptech.glide.integration.compose.ExperimentalGlideComposeApi
import com.bumptech.glide.integration.compose.GlideImage
import com.google.gson.annotations.SerializedName
import \(packageName).R
import \(packageName).repository.state.StateViewModel
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.AndroidEntryPoint
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import retrofit2.HttpException
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))

//other
val spacer = 32.dp
val itemPadding = 16.dp
val cardPadding = 8.dp
val cardElevation = 8.dp

val textPadding = 8.dp

val cardWidth = 50.dp
val cardHeight = 200.dp

val imageHeight = 200.dp

val startPadding = 24.dp

val smallFontSize = 16.sp
val mediumFontSize = 22.sp
val largeFontSize = 32.sp
val largeHeadlineFontSize = 32.sp
val fontFamily = FontFamily.SansSerif
val fontFamilyLarge = FontFamily.Monospace

val typography = Typography(
    displaySmall = TextStyle(
        color = textColorPrimary, fontFamily = fontFamily, fontSize = smallFontSize
    ),
    displayMedium = TextStyle(
        color = textColorPrimary, fontFamily = fontFamily, fontSize = mediumFontSize
    ),
    displayLarge = TextStyle(
        color = textColorPrimary, fontFamily = fontFamily, fontSize = largeFontSize
    ),
    headlineLarge = TextStyle(
        color = textColorSecondary, fontFamily = fontFamilyLarge, fontSize = largeHeadlineFontSize
    )
)

val colorScheme = lightColorScheme(
    primary = backColorPrimary,
    surface = surfaceColor
)

@Composable
fun TeaWikiTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = colorScheme,
        typography = typography,
        content = content
    )
}

@Composable
fun TeaWiki(
    stateModel: StateViewModel,
    viewModel: MainViewModel = hiltViewModel()
) {
    val tea = viewModel.tea.collectAsState(initial = listOf()).value
    val networkState = viewModel.networkState.collectAsState().value
    val context = LocalContext.current

    LaunchedEffect(key1 = networkState) {
        when (networkState) {
            is NetworkState.Loading -> {
                Toast.makeText(
                    context, context.getString(R.string.loading), Toast.LENGTH_SHORT
                ).show()
            }

            is NetworkState.Error -> {
                Toast.makeText(
                    context, context.getString(R.string.error), Toast.LENGTH_SHORT
                ).show()
            }

            is NetworkState.Success -> {}
        }
    }

    LazyVerticalGrid(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.primary),
        columns = GridCells.Fixed(2),
        content = {
            item(
                span = { GridItemSpan(maxLineSpan) }
            ) {
                Text(
                    text = stringResource(R.string.app_name),
                    style = MaterialTheme.typography.headlineLarge,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(textPadding),
                    textAlign = TextAlign.Center
                )
            }
            items(tea.size) { index ->
                TeaItem(stateModel, tea[index])
            }
        }
    )
}

@OptIn(ExperimentalGlideComposeApi::class)
@Composable
fun TeaItem(
    stateModel: StateViewModel,
    tea: TeaEntity
) {
    ElevatedCard(
        modifier = Modifier
            .width(cardWidth)
            .height(cardHeight)
            .padding(cardPadding),
        elevation = CardDefaults.cardElevation(cardElevation)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .fillMaxHeight()
                .clickable {
                    stateModel.setTeaState(tea.id)
                },
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            GlideImage(
                modifier = Modifier
                    .weight(0.8f)
                    .fillMaxWidth(),
                model = tea.image,
                contentDescription = null,
                contentScale = ContentScale.Crop
            )
            Text(
                text = tea.name,
                modifier = Modifier
                    .weight(0.2f)
                    .fillMaxWidth()
                    .padding(textPadding),
                textAlign = TextAlign.Center,
                style = MaterialTheme.typography.displaySmall
            )
        }
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val loadAllTeaUseCase: LoadAllTeaUseCase,
    private val getAllTeaUseCase: GetAllTeaUseCase
) : ViewModel() {

    private val _networkState: MutableStateFlow<NetworkState> =
        MutableStateFlow(NetworkState.Loading)
    val networkState = _networkState.asStateFlow()

    val tea = getAllTeaUseCase.invoke()

    init {
        loadData()
    }

    private fun loadData() {
        viewModelScope.launch {
            _networkState.value = loadAllTeaUseCase.invoke()
        }
    }

}

@AndroidEntryPoint
class TeaFragment : Fragment() {

    private val stateViewModel by activityViewModels<StateViewModel>()
    private lateinit var teaId: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        teaId = arguments?.getString(TEA_ID) ?: ""

        activity?.onBackPressedDispatcher?.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                stateViewModel.setMainState()
            }
        })

    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setContent {
                TeaWikiTheme {
                    TeaScreen(teaId = teaId)
                }
            }
        }
    }

    companion object {
        private const val TEA_ID = "tea_id"

        fun newInstance(teaId: String) = TeaFragment().apply {
            arguments = Bundle().apply {
                putString(TEA_ID, teaId)
            }
        }
    }
}

@OptIn(ExperimentalGlideComposeApi::class)
@Composable
fun TeaScreen(
    viewModel: TeaViewModel = hiltViewModel(),
    teaId: String
) {
    val tea = viewModel.getTeaById(teaId).collectAsState(initial = TeaEntity()).value

    Column(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.primary)
            .fillMaxWidth()
            .fillMaxHeight()
            .verticalScroll(rememberScrollState())
            .padding(
                bottom = itemPadding
            ),
        verticalArrangement = Arrangement.spacedBy(spacer)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .wrapContentHeight()
        ) {
            GlideImage(
                modifier = Modifier
                    .height(imageHeight)
                    .fillMaxWidth(),
                model = tea.image,
                contentDescription = null,
                contentScale = ContentScale.Crop
            )
            Text(
                text = tea.name,
                modifier = Modifier
                    .fillMaxWidth()
                    .background(MaterialTheme.colorScheme.surface)
                    .padding(itemPadding),
                style = MaterialTheme.typography.displayLarge,
                textAlign = TextAlign.Center
            )
        }
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .wrapContentHeight(),
            verticalArrangement = Arrangement.spacedBy(itemPadding)
        ) {
            TeaAttribute(description = tea.type, res = R.string.type)
            tea.description?.let {
                TeaAttribute(description = it, res = R.string.description)
            }
            TeaAttribute(description = tea.origin, res = R.string.origin)
            TeaAttribute(description = tea.caffeine, res = R.string.caffeine)
            TeaAttribute(description = tea.tasteDescription, res = R.string.taste_description)
            tea.mainIngredients?.let {
                TeaAttribute(description = tea.mainIngredients, res = R.string.main_ingredients)
            }
        }
    }
}

@Composable
fun TeaAttribute(description: String, res: Int) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(
                start = startPadding,
                end = startPadding
            )
    ) {
        Text(
            text = stringResource(res),
            style = MaterialTheme.typography.displaySmall
        )
        Text(
            text = description,
            modifier = Modifier.fillMaxWidth(),
            style = MaterialTheme.typography.displayMedium
        )
    }
}

@HiltViewModel
class TeaViewModel @Inject constructor(
    private val getTeaByIdUseCase: GetTeaByIdUseCase
) : ViewModel() {

    fun getTeaById(id: String) = getTeaByIdUseCase.invoke(id)
}

data class TeaEntity(
    val id: String = "",
    val caffeine: String = "",
    val description: String? = "",
    val image: String? = "",
    val name: String = "",
    val origin: String = "",
    val tasteDescription: String = "",
    val mainIngredients: String? = "",
    val type: String = ""
)

interface Repository {

    suspend fun loadTea(): NetworkState
    fun getAllTea(): Flow<List<TeaEntity>>
    fun getTeaById(id: String): Flow<TeaEntity>
}

sealed class NetworkState {
    object Loading : NetworkState()
    object Success : NetworkState()
    object Error : NetworkState()
}

class LoadAllTeaUseCase @Inject constructor(
    private val repository: Repository
) {
    suspend operator fun invoke() = repository.loadTea()
}

class GetTeaByIdUseCase @Inject constructor(
    private val repository: Repository
) {
    operator fun invoke(id: String) = repository.getTeaById(id)
}

class GetAllTeaUseCase @Inject constructor(
    private val repository: Repository
) {
    operator fun invoke() = repository.getAllTea()
}

@Entity(tableName = "tea")
data class TeaDbModel(
    @PrimaryKey
    val id: String,
    val caffeine: String,
    val description: String?,
    val image: String?,
    val name: String,
    val origin: String,
    val tasteDescription: String,
    val mainIngredients: String?,
    val type: String
)

@Keep
data class TeaDto(
    @SerializedName("caffeine")
    val caffeine: String,
    @SerializedName("description")
    val description: String?,
    @SerializedName("_id")
    val id: String,
    @SerializedName("image")
    val image: String?,
    @SerializedName("name")
    val name: String,
    @SerializedName("origin")
    val origin: String,
    @SerializedName("tasteDescription")
    val tasteDescription: String,
    @SerializedName("mainIngredients")
    val mainIngredients: String,
    @SerializedName("type")
    val type: String
)

interface ApiService {

    @GET("all")
    suspend fun getAllTea(): List<TeaDto>
}

class TeaMapper @Inject constructor() {

    fun mapTeaDbModelToEntity(db: TeaDbModel) = TeaEntity(
        id = db.id,
        caffeine = db.caffeine,
        description = db.description,
        image = db.image,
        name = db.name,
        origin = db.origin,
        tasteDescription = db.tasteDescription,
        type = db.type,
        mainIngredients = db.mainIngredients
    )

    private fun mapTeaDtoToDbModel(dto: TeaDto) = TeaDbModel(
        id = dto.id,
        caffeine = dto.caffeine,
        description = dto.description,
        image = dto.image,
        name = dto.name,
        origin = dto.origin,
        tasteDescription = dto.tasteDescription,
        type = dto.type,
        mainIngredients = dto.mainIngredients
    )

    fun mapTeaListDtoToDbModel(dto: List<TeaDto>) = dto.map {
        mapTeaDtoToDbModel(it)
    }

    fun mapTeaListDbModelToEntity(db: List<TeaDbModel>) = db.map {
        mapTeaDbModelToEntity(it)
    }
}

class RepositoryImpl @Inject constructor(
    private val database: AppDatabase,
    private val apiService: ApiService,
    private val mapper: TeaMapper
) : Repository {

    override suspend fun loadTea(): NetworkState {
        return try {
            val teaListDto = apiService.getAllTea()
            database.dao().insertTea(mapper.mapTeaListDtoToDbModel(teaListDto))

            NetworkState.Success
        } catch (e: IOException) {
            NetworkState.Error
        } catch (e: HttpException) {
            NetworkState.Error
        }
    }

    override fun getAllTea(): Flow<List<TeaEntity>> {
        return database.dao().getAllTea().map {
            mapper.mapTeaListDbModelToEntity(it)
        }
    }

    override fun getTeaById(id: String): Flow<TeaEntity> {
        return database.dao().getTeaById(id).map {
            mapper.mapTeaDbModelToEntity(it)
        }
    }
}

@Dao
interface TeaDao {

    @Query("SELECT * FROM tea")
    fun getAllTea(): Flow<List<TeaDbModel>>

    @Query("SELECT * FROM tea WHERE id = :id")
    fun getTeaById(id: String): Flow<TeaDbModel>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertTea(list: List<TeaDbModel>)
}

@Database(entities = [TeaDbModel::class], version = 1, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun dao(): TeaDao
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    private const val BASE_URL = "https://boonakitea.cyclic.app/api/"

    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): AppDatabase {
        return Room
            .databaseBuilder(appContext, AppDatabase::class.java, "database-main")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(
        database: AppDatabase,
        apiService: ApiService,
        mapper: TeaMapper
    ): Repository = RepositoryImpl(database, apiService, mapper)

    @Singleton
    @Provides
    fun provideRetrofit(): Retrofit = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    @Singleton
    @Provides
    fun provideApiService(retrofit: Retrofit): ApiService = retrofit.create(ApiService::class.java)
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: "", content: """
                TeaWikiTheme {
                    TeaWiki(stateViewModel)
                }
"""),
            mainActivityData: ANDMainActivity(imports: """
import \(mainData.packageName).presentation.fragments.main_fragment.TeaFragment
""", extraFunc: "", content: "", extraStates: """
                        is FragmentState.TeaState -> replace(TeaFragment.newInstance(it.teaId))
"""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="error">Could not load data…</string>
    <string name="loading">Loading…</string>
    <string name="origin">Origin:</string>
    <string name="type">Type:</string>
    <string name="caffeine">Caffeine:</string>
    <string name="description">Description:</string>
    <string name="taste_description">Taste:</string>
    <string name="main_ingredients">Main Ingredients:</string>
"""),
            colorsData: ANDColorsData(additional: "")
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
    implementation Dependencies.room_runtime
    implementation Dependencies.room_ktx
    implementation Dependencies.converter_gson
    implementation Dependencies.glide_compose
    kapt Dependencies.room_compiler
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
    const val glide_compose = "1.0.0-alpha.1"
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
    const val glide_compose = "com.github.bumptech.glide:compose:${Versions.glide_compose}"
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
