//
//  File.swift
//  
//
//  Created by admin on 15.08.2023.
//

import Foundation

struct KLDSWeapon: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.widget.Toast
import androidx.annotation.Keep
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Embedded
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import \(packageName).R
import com.google.gson.annotations.SerializedName
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import javax.inject.Inject
import javax.inject.Singleton

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val paddingPrimary = 8.dp

//other
val layoutPadding = 8.dp
val itemPadding = 14.dp

val smallFontSize = 14.sp
val mediumFontSize = 18.sp
val largeFontSize = 24.sp
val largeHeadlineFontSize = 32.sp
val fontFamily = FontFamily.SansSerif
val fontFamilyLarge = FontFamily.Monospace

@Composable
fun DSWeapon(
    viewModel: MainViewModel = hiltViewModel()
) {

    val weapon = viewModel.weapon.collectAsState(initial = listOf()).value
    val networkState = viewModel.networkState.collectAsState().value
    val context = LocalContext.current

    SideEffect {
        if (networkState is NetworkState.Error) {
            Toast.makeText(
                context,
                context.getString(R.string.error),
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    Column(
        modifier = Modifier
            .background(backColorPrimary)
    ) {
        Text(
            text = stringResource(R.string.app_name),
            color = textColorPrimary,
            fontSize = largeHeadlineFontSize,
            fontFamily = fontFamilyLarge,
            modifier = Modifier
                .fillMaxWidth()
                .padding(layoutPadding),
            textAlign = TextAlign.Center
        )
        LazyColumn(
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(paddingPrimary)
        ) {
            items(items = weapon, itemContent = { item ->
                WeaponItem(item)
            })
        }
    }
}

@Composable
fun BonusItem(res: Int, bns: String?) {
    bns?.let {
        Text(
            text = stringResource(res, it),
            color = textColorPrimary,
            fontSize = mediumFontSize,
            fontFamily = fontFamily
        )
    }
}

@Composable
fun ReqItem(res: Int, req: Int) {
    Text(
        text = stringResource(res, req),
        color = textColorPrimary,
        fontSize = mediumFontSize,
        fontFamily = fontFamily
    )
}

@Composable
fun WeaponItem(
    weapon: WeaponEntity
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .wrapContentHeight()
            .background(surfaceColor)
            .padding(itemPadding)
    ) {
        Column(
            modifier = Modifier
                .weight(1f)
                .fillMaxHeight(),
            verticalArrangement = Arrangement.SpaceAround
        ) {
            Text(
                text = weapon.weaponType,
                color = textColorSecondary,
                fontSize = smallFontSize,
                fontFamily = fontFamily
            )
            Text(
                text = weapon.name,
                color = textColorPrimary,
                fontSize = largeFontSize,
                fontFamily = fontFamily
            )
            Row(
                horizontalArrangement = Arrangement.spacedBy(paddingPrimary)
            ) {
                BonusItem(res = R.string.bns_str, bns = weapon.bnsStr)
                BonusItem(res = R.string.bns_dex, bns = weapon.bnsDex)
                BonusItem(res = R.string.bns_fth, bns = weapon.bnsFaith)
                BonusItem(res = R.string.bns_int, bns = weapon.bnsInt)
            }
            Text(
                text = stringResource(R.string.weight, weapon.weight),
                color = textColorPrimary,
                fontSize = mediumFontSize,
                fontFamily = fontFamily
            )
        }
        Column(
            modifier = Modifier
                .weight(0.3f)
                .fillMaxHeight(),
            horizontalAlignment = Alignment.Start,
            verticalArrangement = Arrangement.Center
        ) {
            ReqItem(res = R.string.req_str, req = weapon.reqStr)
            ReqItem(res = R.string.req_dex, req = weapon.reqDex)
            ReqItem(res = R.string.req_fth, req = weapon.reqFaith)
            ReqItem(res = R.string.req_int, req = weapon.reqInt)
        }
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val loadWeaponUseCase: LoadWeaponUseCase,
    getAllWeaponUseCase: GetAllWeaponUseCase
) : ViewModel() {

    private val _networkState: MutableStateFlow<NetworkState> = MutableStateFlow(NetworkState.Loading)
    val networkState = _networkState.asStateFlow()

    val weapon = getAllWeaponUseCase.invoke()

    init {
        loadData()
    }

    private fun loadData() {
        viewModelScope.launch {
            _networkState.value = loadWeaponUseCase.invoke()
        }
    }
}

data class WeaponEntity(
    val id: Int,
    val reqFaith: Int,
    val reqStr: Int,
    val reqInt: Int,
    val reqDex: Int,
    val weaponType: String,
    val weight: Float,
    val name: String,
    val bnsFaith: String?,
    val bnsStr: String?,
    val bnsInt: String?,
    val bnsDex: String?
)

interface Repository {

    suspend fun loadWeapon(): NetworkState
    fun getAllWeapon(): Flow<List<WeaponEntity>>
}

sealed class NetworkState {
    object Loading : NetworkState()
    object Success : NetworkState()
    object Error : NetworkState()
}

class GetAllWeaponUseCase @Inject constructor(
    private val repository: Repository
) {
    operator fun invoke() = repository.getAllWeapon()
}

class LoadWeaponUseCase @Inject constructor(
    private val repository: Repository
) {
    suspend operator fun invoke() = repository.loadWeapon()
}

interface ApiService {

    @GET("ds-weapons-api/")
    suspend fun getQuote(): Response<List<WeaponDto>>
}

@Entity(tableName = "weapon")
data class WeaponDbModel(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    @Embedded(prefix = "bonus_")
    val bonus: Bonus,
    val name: String,
    @Embedded(prefix = "reqs_")
    val requirements: Requirements,
    val weaponType: String,
    val weight: Float
)

@Keep
data class WeaponDto(
    @SerializedName("bonus")
    val bonus: Bonus,
    @SerializedName("name")
    val name: String,
    @SerializedName("requirements")
    val requirements: Requirements,
    @SerializedName("weapon_type")
    val weaponType: String,
    @SerializedName("weight")
    val weight: Float
)

@Keep
data class Requirements(
    @SerializedName("dexterity")
    val dexterity: Int,
    @SerializedName("faith")
    val faith: Int,
    @SerializedName("intelligence")
    val intelligence: Int,
    @SerializedName("strength")
    val strength: Int
)

@Keep
data class Bonus(
    @SerializedName("dexterity")
    val dexterity: String?,
    @SerializedName("faith")
    val faith: String?,
    @SerializedName("intelligence")
    val intelligence: String?,
    @SerializedName("strength")
    val strength: String?
)

class WeaponMapper @Inject constructor() {

    private fun mapWeaponDtoToDbModel(dto: WeaponDto) = WeaponDbModel(
        bonus = dto.bonus,
        name = dto.name,
        requirements = dto.requirements,
        weaponType = dto.weaponType,
        weight = dto.weight
    )

    private fun mapWeaponDbModelToEntity(dbModel: WeaponDbModel) = WeaponEntity(
        id = dbModel.id,
        bnsDex = dbModel.bonus.dexterity,
        bnsFaith = dbModel.bonus.faith,
        bnsInt = dbModel.bonus.intelligence,
        bnsStr = dbModel.bonus.strength,
        name = dbModel.name,
        reqDex = dbModel.requirements.dexterity,
        reqFaith = dbModel.requirements.faith,
        reqStr = dbModel.requirements.strength,
        reqInt = dbModel.requirements.intelligence,
        weaponType = dbModel.weaponType,
        weight = dbModel.weight
    )

    fun mapListWeaponDtoToDbModel(dto: List<WeaponDto>) = dto.map {
        mapWeaponDtoToDbModel(it)
    }

    fun mapListWeaponDbModelToEntity(dbModel: List<WeaponDbModel>) = dbModel.map {
        mapWeaponDbModelToEntity(it)
    }
}

@Database(entities = [WeaponDbModel::class], version = 1, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {
    abstract fun dao(): WeaponDao
}

class RepositoryImpl(
    private val database: AppDatabase,
    private val apiService: ApiService,
    private val mapper: WeaponMapper
) : Repository {

    override suspend fun loadWeapon(): NetworkState {
        val response = apiService.getQuote()

        return if (response.isSuccessful) {
            response.body()?.let {
                val list = mapper.mapListWeaponDtoToDbModel(it)

                database.dao().deleteWeapon()
                database.dao().insertWeapon(list)

            }
            NetworkState.Success
        } else {
            NetworkState.Error
        }
    }

    override fun getAllWeapon(): Flow<List<WeaponEntity>> {
        return database.dao().getAllWeapon()
            .map { return@map mapper.mapListWeaponDbModelToEntity(it) }
    }
}

@Dao
interface WeaponDao {

    @Query("SELECT * FROM weapon")
    fun getAllWeapon(): Flow<List<WeaponDbModel>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertWeapon(weapon: List<WeaponDbModel>)

    @Query("DELETE FROM weapon")
    suspend fun deleteWeapon()
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    private const val BASE_URL = "https://jgalat.github.io/"

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
        mapper: WeaponMapper
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
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    DSWeapon()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="req_dex">Dex: %d</string>
    <string name="req_fth">Fth: %d</string>
    <string name="req_str">Str: %d</string>
    <string name="req_int">Int: %d</string>
    <string name="weight">Weight: %.1f</string>
    <string name="bns_dex">Dex: %s</string>
    <string name="bns_fth">Fth: %s</string>
    <string name="bns_str">Str: %s</string>
    <string name="bns_int">Int: %s</string>
    <string name="error">Could not load data</string>
"""), colorsData: ANDColorsData(additional: ""))
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
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson
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
