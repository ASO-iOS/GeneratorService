//
//  File.swift
//  
//
//  Created by admin on 15.08.2023.
//

import Foundation

struct KLColorSwatcher: FileProviderProtocol {
    static var fileName: String = "KLColorSwatcher.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Done
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
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
import \(packageName).R
import com.github.skydoves.colorpicker.compose.AlphaTile
import com.github.skydoves.colorpicker.compose.BrightnessSlider
import com.github.skydoves.colorpicker.compose.HsvColorPicker
import com.github.skydoves.colorpicker.compose.rememberColorPickerController
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.math.roundToInt

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val buttonTextColorSecondary = Color(0xFF\(uiSettings.buttonTextColorSecondary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

//other
const val transparencyCoef = 0.5f

val windowRoundedCorner = 16.dp
val windowContentRoundedCorner = 8.dp
val windowIconSize = 36.dp
val windowPadding = 32.dp

val alphaTileHeight = 24.dp
val hsvColorPickerSize = 200.dp
val brightnessSliderHeight = 24.dp
val textFieldHeight = 56.dp

val smallSpacerHeight = 24.dp

val layoutPadding = 16.dp

val borderWidth = 2.dp

val swatchSize = 150.dp

@Composable
fun ColorSwatcher(
    viewModel: MainViewModel = hiltViewModel()
) {
    ColorDialog()

    val swatches by viewModel.swatches.collectAsState()
    val context = LocalContext.current

    Surface(color = backColorPrimary) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(layoutPadding)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
            ) {
                swatches.forEach {
                    DraggableColorItem(swatch = it)
                }
            }
            Row(
                modifier = Modifier
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                OutlinedButton(
                    border = BorderStroke(borderWidth, buttonColorPrimary),
                    onClick = {
                        viewModel.removeAllSwatches()
                    }
                ) {
                    Icon(Icons.Default.Delete, null, tint = buttonTextColorPrimary)
                }
                OutlinedButton(
                    border = BorderStroke(borderWidth, buttonColorPrimary),
                    onClick = {
                        viewModel.addSwatch()
                    }
                ) {
                    Icon(Icons.Default.Add, null, tint = buttonTextColorPrimary)
                }
                OutlinedButton(
                    border = BorderStroke(borderWidth, buttonColorPrimary),
                    onClick = {
                        viewModel.saveSwatches()
                        Toast.makeText(
                            context,
                            context.getString(R.string.swatches_saved),
                            Toast.LENGTH_SHORT
                        ).show()
                    }
                ) {
                    Icon(Icons.Default.Done, null, tint = buttonTextColorPrimary)
                }
            }
        }
    }
}

@Composable
fun ColorDialog(
    viewModel: MainViewModel = hiltViewModel()
) {
    if (!viewModel.colorDialogState) return

    val pickedSwatch = viewModel.currentSwatch
    val controller = rememberColorPickerController()

    val label = remember { mutableStateOf(pickedSwatch.label) }

    Dialog(
        onDismissRequest = {
            viewModel.hideColorDialog()
        },
        properties = DialogProperties(
            dismissOnBackPress = true,
            dismissOnClickOutside = true
        )
    ) {
        Surface(
            shape = RoundedCornerShape(windowRoundedCorner),
            color = surfaceColor
        ) {
            Column(
                modifier = Modifier
                    .padding(layoutPadding),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.SpaceAround
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.Delete,
                        contentDescription = null,
                        tint = buttonColorSecondary,
                        modifier = Modifier
                            .size(windowIconSize)
                            .clickable {
                                viewModel.hideColorDialog()
                                viewModel.removeSwatch(pickedSwatch)
                            }
                    )
                    Icon(
                        imageVector = Icons.Default.Cancel,
                        contentDescription = null,
                        tint = buttonColorSecondary,
                        modifier = Modifier
                            .size(windowIconSize)
                            .clickable {
                                viewModel.hideColorDialog()
                            }
                    )
                }
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(smallSpacerHeight),
                    modifier = Modifier.padding(
                        start = windowPadding,
                        top = windowPadding,
                        end = windowPadding
                    )
                ) {
                    AlphaTile(
                        modifier = Modifier
                            .clip(RoundedCornerShape(windowContentRoundedCorner))
                            .fillMaxWidth()
                            .height(alphaTileHeight),
                        controller = controller
                    )
                    HsvColorPicker(
                        modifier = Modifier
                            .size(hsvColorPickerSize),
                        initialColor = Color(pickedSwatch.color.toULong()),
                        controller = controller
                    )
                    BrightnessSlider(
                        modifier = Modifier
                            .clip(RoundedCornerShape(windowContentRoundedCorner))
                            .fillMaxWidth()
                            .height(brightnessSliderHeight),
                        controller = controller
                    )
                    TextField(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(textFieldHeight),
                        colors = TextFieldDefaults.colors(
                            unfocusedContainerColor = surfaceColor.copy(transparencyCoef),
                            focusedContainerColor = surfaceColor.copy(transparencyCoef),
                            focusedTextColor = textColorPrimary,
                            unfocusedTextColor = textColorPrimary,
                            focusedLabelColor = textColorPrimary,
                            unfocusedLabelColor = textColorPrimary
                        ),
                        value = label.value,
                        singleLine = true,
                        onValueChange = { label.value = it },
                        label = { Text(stringResource(R.string.swatch_name)) }
                    )
                    OutlinedButton(
                        modifier = Modifier
                            .fillMaxWidth(),
                        colors = ButtonDefaults.outlinedButtonColors(
                            containerColor = buttonColorSecondary
                        ),
                        onClick = {
                            val updatedSwatch = pickedSwatch.copy(
                                color = controller.selectedColor.value.value.toString(),
                                label = label.value
                            )
                            viewModel.editSwatch(updatedSwatch)
                            viewModel.hideColorDialog()
                        },
                        border = BorderStroke(0.dp, Color.Transparent)
                    ) {
                        Text(
                            stringResource(R.string.save_button),
                            color = buttonTextColorSecondary
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun DraggableColorItem(
    viewModel: MainViewModel = hiltViewModel(),
    swatch: ColorSwatch
) {

    var x by remember { mutableStateOf(swatch.x) }
    var y by remember { mutableStateOf(swatch.y) }

    Box(
        modifier = Modifier
            .offset { IntOffset(x.roundToInt(), y.roundToInt()) }
            .clip(CircleShape)
            .background(Color(swatch.color.toULong()).copy(transparencyCoef))
            .size(swatchSize)
            .pointerInput(Unit) {
                detectDragGestures { change, dragAmount ->
                    change.consume()
                    x += dragAmount.x
                    y += dragAmount.y
                }
            }
            .clickable {
                viewModel.showColorDialog(swatch.id)
            },
        contentAlignment = Alignment.Center
    ) {
        Text(text = swatch.label)
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val repository: Repository
) : ViewModel() {

    var currentSwatch by mutableStateOf(ColorSwatch(-1))
        private set

    private var _swatches = MutableStateFlow(emptyList<ColorSwatch>())
    val swatches = _swatches.asStateFlow()

    var colorDialogState by mutableStateOf(false)
        private set

    init {
        getSwatches()
    }

    private fun getSwatches() {
        viewModelScope.launch {
            repository.getSwatches().flowOn(Dispatchers.IO).collect { list ->
                _swatches.update { list }
            }
        }
    }

    fun saveSwatches() {
        viewModelScope.launch {
            repository.saveSwatches(swatches.value)
        }
    }

    fun editSwatch(updatedSwatch: ColorSwatch) {
        val list = swatches.value.toMutableList()
        val position = list.indexOfFirst { it.id == updatedSwatch.id }
        list[position] = updatedSwatch
        _swatches.update { list }
    }

    fun addSwatch() {
        val list = swatches.value.toMutableList()
        list.add(
            ColorSwatch(
                id = list.size,
                color = Color.Gray.value.toString(),
                label = "",
                x = 0f,
                y = 0f
            )
        )
        _swatches.update { list }
    }

    fun removeSwatch(swatch: ColorSwatch) {
        val list = swatches.value.toMutableList()
        list.removeIf {it.id == swatch.id}
        _swatches.update { list }
    }

    fun removeAllSwatches() {
        _swatches.update { emptyList() }
    }

    fun hideColorDialog() {
        colorDialogState = false
    }

    fun showColorDialog(id: Int) {
        colorDialogState = true
        currentSwatch = swatches.value.first { swatch -> swatch.id == id }
    }
}

interface Repository {

    fun getSwatches(): Flow<List<ColorSwatch>>

    suspend fun saveSwatches(list: List<ColorSwatch>)
}

@Entity(tableName = "swatches")
data class ColorSwatch(
    @PrimaryKey
    val id: Int,
    val color: String = Color.DarkGray.value.toString(),
    val label: String = "",
    val x: Float = 0f,
    val y: Float = 0f
)

@Database(entities = [ColorSwatch::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun dao(): ColorDao
}

@Dao
interface ColorDao {

    @Query("SELECT * FROM swatches")
    fun getSwatches(): Flow<List<ColorSwatch>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun saveSwatches(list: List<ColorSwatch>)

    @Query("DELETE FROM swatches")
    suspend fun removeAllSwatches()
}

class RepositoryImpl @Inject constructor(
    private val database: AppDatabase
) : Repository {

    override fun getSwatches(): Flow<List<ColorSwatch>> {
        return database.dao().getSwatches()
    }

    override suspend fun saveSwatches(list: List<ColorSwatch>) {
        database.dao().removeAllSwatches()
        database.dao().saveSwatches(list)
    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): AppDatabase {
        return Room
            .databaseBuilder(appContext, AppDatabase::class.java, "database-main")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(database: AppDatabase): Repository = RepositoryImpl(database)
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    ColorSwatcher()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="save_button">Save</string>
    <string name="swatch_name">Swatch Name</string>
    <string name="swatches_saved">Saved</string>
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
    implementation Dependencies.color_picker
    implementation Dependencies.compose_lifecycle_runtime
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
    implementation Dependencies.room_runtime
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
    const val compose_lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime-compose:2.6.0-beta01"

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
    const val color_picker = "com.github.skydoves:colorpicker-compose:1.0.4"

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
