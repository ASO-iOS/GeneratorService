//
//  File.swift
//  
//
//  Created by admin on 8/18/23.
//

import Foundation

struct KLMoodTracker: FileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
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
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import javax.inject.Inject
import javax.inject.Singleton

//generator
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "ffffff"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "ffffff"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "ffffff"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "ffffff"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "ffffff"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "ffffff"))

//other
val layoutPadding = 24.dp

val itemSpacer = 16.dp
val dialogSpacer = 24.dp
val dialogPadding = 24.dp

val roundedCorner = 8.dp

val cardHeight = 80.dp
val cardPadding = 24.dp

val montserratLight = FontFamily(
    Font(R.font.montserrat_light)
)

val montserratMedium = FontFamily(
    Font(R.font.montserrat_medium)
)

val smallFontSize = 12.sp
val mediumFontSize = 16.sp
val largeFontSize = 24.sp

val typography = Typography(
    displaySmall = TextStyle(
        fontFamily = montserratLight, fontSize = smallFontSize, color = textColorPrimary
    ),
    displayMedium = TextStyle(
        fontFamily = montserratMedium, fontSize = mediumFontSize, color = textColorPrimary
    ),
    displayLarge = TextStyle(
        fontFamily = montserratMedium, fontSize = largeFontSize, color = textColorPrimary
    ),
)

val colorScheme = lightColorScheme(
    background = backColorPrimary,
    surface = surfaceColor,
    primaryContainer = buttonColorPrimary,
    onPrimaryContainer = buttonTextColorPrimary,
    primary = primaryColor,
    secondary = buttonTextColorPrimary
)

@Composable
fun MoodTrackerTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = colorScheme,
        typography = typography,
        content = content
    )
}

@Composable
fun MainScreen() {
    val viewModel = hiltViewModel<MainViewModel>()

    val context = LocalContext.current

    LaunchedEffect(key1 = context) {
        viewModel.message.collect { event ->
            when (event) {
                is MessageEvent.HasTodayMood -> {
                    Toast.makeText(
                        context,
                        context.getString(R.string.has_today_mood),
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }
    }

    MainScreenContent(
        state = viewModel.state,
        onEvent = viewModel::onEvent
    )
}

@Composable
fun MainScreenContent(
    state: MainState,
    onEvent: (MainEvent) -> Unit
) {
    val openDialog = remember { mutableStateOf(false) }
    val dialogMood = remember { mutableStateOf<MoodEntity?>(null) }

    if (openDialog.value) {
        MoodDialog(
            onDismiss = {
                openDialog.value = false
            },
            onEvent = onEvent,
            dialogMood.value
        )
    }

    Column(
        modifier = Modifier
            .background(MaterialTheme.colorScheme.background)
            .fillMaxSize()
            .padding(layoutPadding),
        verticalArrangement = Arrangement.spacedBy(32.dp)
    ) {
        Text(
            modifier = Modifier.fillMaxWidth(),
            textAlign = TextAlign.Center,
            text = stringResource(id = R.string.your_mood),
            style = MaterialTheme.typography.displayLarge
        )
        LazyColumn(
            modifier = Modifier.weight(1f),
            verticalArrangement = Arrangement.spacedBy(itemSpacer)
        ) {
            items(items = state.moods, key = { it.id }, itemContent = { item ->
                MoodItem(
                    mood = item,
                    onClick = {
                        onEvent(MainEvent.LookAtMood(item))
                        dialogMood.value = item
                        openDialog.value = true
                    }
                )
            })
        }
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.End
        ) {
            FloatingActionButton(
                shape = CircleShape,
                onClick = {
                    if (!state.hasTodayMood) {
                        dialogMood.value = null
                        openDialog.value = true
                    } else {
                        onEvent(MainEvent.ShowHasTodayMoodMessage)
                    }
                },
                containerColor = MaterialTheme.colorScheme.primaryContainer
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }
        }
    }
}

@Composable
fun MoodDialog(
    onDismiss: () -> Unit,
    onEvent: (MainEvent) -> Unit,
    mood: MoodEntity?
) {
    val comment = remember { mutableStateOf(mood?.comment ?: "") }
    val moodIcon = remember { mutableStateOf(mood?.mood ?: Mood.NEUTRAL) }

    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(
            dismissOnBackPress = true,
            dismissOnClickOutside = true
        )
    ) {
        Column(
            modifier = Modifier
                .clip(RoundedCornerShape(roundedCorner))
                .background(MaterialTheme.colorScheme.surface)
                .padding(dialogPadding),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(dialogSpacer)
        ) {
            IconRow(
                moodChosen = moodIcon.value,
                onMoodIconChosen = { mood ->
                    moodIcon.value = mood
                }
            )

            OutlinedTextField(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(180.dp),
                value = comment.value,
                onValueChange = {
                    comment.value = it
                },
                label = { Text(stringResource(id = R.string.comments_about_day), color = textColorPrimary) },
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = textColorPrimary,
                unfocusedBorderColor = textColorPrimary,
                unfocusedContainerColor = MaterialTheme.colorScheme.surface,
                focusedContainerColor = MaterialTheme.colorScheme.surface,
                focusedTextColor = textColorPrimary,
                unfocusedTextColor = textColorPrimary,
                disabledTextColor = textColorPrimary
            )
            )

            OutlinedButton(
                modifier = Modifier
                    .fillMaxWidth(),
                onClick = {
                    if (mood != null) {
                        onEvent(MainEvent.EditMood(mood = moodIcon.value, comment = comment.value))
                    } else {
                        onEvent(MainEvent.AddMood(mood = moodIcon.value, comment = comment.value))
                    }
                    onDismiss()
                },
                border = BorderStroke(1.dp, textColorPrimary)
            ) {
                Text(
                    text = stringResource(id = R.string.save),
                    style = MaterialTheme.typography.displayMedium
                )
            }

        }
    }
}

@Composable
fun IconRow(
    moodChosen: Mood,
    onMoodIconChosen: (Mood) -> Unit
) {
    val moods = Mood.values()

    Row(
        modifier = Modifier
            .fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        moods.forEach { mood ->
            if (mood == moodChosen) {
                IconItem(
                    mood = mood,
                    tint = MaterialTheme.colorScheme.secondary,
                    onMoodIconChosen = onMoodIconChosen
                )
            } else {
                IconItem(
                    mood = mood,
                    tint = MaterialTheme.colorScheme.primary,
                    onMoodIconChosen = onMoodIconChosen
                )
            }
        }
    }
}

@Composable
fun IconItem(
    mood: Mood,
    tint: Color,
    onMoodIconChosen: (Mood) -> Unit
) {
    Icon(
        modifier = Modifier.clickable { onMoodIconChosen(mood) },
        painter = painterResource(id = mood.imageRes),
        contentDescription = null,
        tint = tint
    )
}

@Composable
fun MoodItem(
    mood: MoodEntity,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .height(cardHeight)
            .clip(RoundedCornerShape(roundedCorner))
            .background(MaterialTheme.colorScheme.surface)
            .clickable {
                onClick()
            }
            .padding(
                start = cardPadding,
                end = cardPadding
            ),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(
            modifier = Modifier.width(200.dp)
        ) {
            Text(
                text = mood.date,
                style = MaterialTheme.typography.displaySmall
            )
            Text(
                text = mood.comment,
                maxLines = 1,
                overflow = TextOverflow.Clip,
                style = MaterialTheme.typography.displayMedium
            )
        }
        Icon(
            modifier = Modifier.size(48.dp),
            painter = painterResource(id = mood.mood.imageRes),
            contentDescription = null,
            tint = MaterialTheme.colorScheme.secondary
        )
    }
}

sealed class MainEvent {
    data class LookAtMood(val mood: MoodEntity) : MainEvent()
    data class EditMood(val mood: Mood, val comment: String) : MainEvent()
    data class AddMood(val mood: Mood, val comment: String) : MainEvent()

    object ShowHasTodayMoodMessage : MainEvent()
}

data class MainState(
    val moods: List<MoodEntity> = emptyList(),
    val currentMood: MoodEntity? = null,
    val hasTodayMood: Boolean = false
)

@HiltViewModel
class MainViewModel @Inject constructor(
    private val addMoodUseCase: AddMoodUseCase,
    private val getAllMoods: GetAllMoods,
    private val hasTodayMoodUseCase: HasTodayMoodUseCase
) : ViewModel() {

    var state by mutableStateOf(MainState())
        private set

    val message = MutableSharedFlow<MessageEvent>()

    init {
        getMoods()
        hasTodayMood()
    }

    fun onEvent(event: MainEvent) {
        when (event) {
            is MainEvent.LookAtMood -> {
                state = state.copy(
                    currentMood = event.mood
                )
            }

            is MainEvent.AddMood -> {
                viewModelScope.launch {
                    addMoodUseCase(
                        MoodEntity(
                            mood = event.mood,
                            comment = event.comment,
                            date = getTodayDate()
                        )
                    )
                    state = state.copy(
                        hasTodayMood = true
                    )
                }
            }

            is MainEvent.EditMood -> {
                state.currentMood?.let {
                    it.mood = event.mood
                    it.comment = event.comment
                    viewModelScope.launch {
                        addMoodUseCase(it)
                    }
                }
                state = state.copy(
                    currentMood = null
                )
            }

            is MainEvent.ShowHasTodayMoodMessage -> {
                viewModelScope.launch {
                    message.emit(MessageEvent.HasTodayMood)
                }
            }
        }
    }

    private fun getMoods() {
        viewModelScope.launch {
            getAllMoods().flowOn(Dispatchers.IO).collect { list ->
                state = state.copy(
                    moods = list
                )
            }
        }
    }

    private fun hasTodayMood() {
        viewModelScope.launch {
            state = state.copy(
                hasTodayMood = hasTodayMoodUseCase(getTodayDate())
            )
        }
    }

    private fun getTodayDate(): String {
        val sdf = SimpleDateFormat(DATE_PATTERN, Locale.getDefault())
        sdf.timeZone = TimeZone.getDefault()
        return sdf.format(Date())
    }

    companion object {
        private const val DATE_PATTERN = "dd.MM.yyyy"
    }
}

sealed class MessageEvent {
    object HasTodayMood: MessageEvent()
}

enum class Mood(
    val imageRes: Int
) {
    SAD(R.drawable.sad_face),
    NEUTRAL(R.drawable.neutral_face),
    GOOD(R.drawable.smile_face),
    HAPPY(R.drawable.happy_face)
}

interface Repository {
    fun getAllMoods(): Flow<List<MoodEntity>>
    suspend fun addMood(mood: MoodEntity)
    suspend fun hasTodayMood(date: String): Boolean
}

data class MoodEntity(
    val id: Int = 0,
    val date: String = "",
    var mood: Mood = Mood.NEUTRAL,
    var comment: String = ""
)

class AddMoodUseCase @Inject constructor(
    private val repository: Repository
) {
    suspend operator fun invoke(mood: MoodEntity) = repository.addMood(mood)
}

class GetAllMoods @Inject constructor(
    private val repository: Repository
) {
    operator fun invoke() = repository.getAllMoods()
}

class HasTodayMoodUseCase @Inject constructor(
    private val repository: Repository
) {
    suspend operator fun invoke(date: String) = repository.hasTodayMood(date)
}

@Dao
interface MoodDao {

    @Query("SELECT * FROM mood")
    fun getAllMoods(): Flow<List<MoodDbModel>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun addMood(moodDbModel: MoodDbModel)

    @Query("SELECT * FROM mood WHERE date = :date")
    suspend fun getMoodByDate(date: String): MoodDbModel?
}

@Database(entities = [MoodDbModel::class], version = 1, exportSchema = false)
abstract class MoodDatabase : RoomDatabase() {
    abstract fun dao(): MoodDao
}

@Entity(tableName = "mood")
data class MoodDbModel(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val mood: String,
    val date: String,
    val comment: String
)

class MoodMapper @Inject constructor() {

    private fun mapMoodDbModelToEntity(dbModel: MoodDbModel) = MoodEntity(
        id = dbModel.id,
        date = dbModel.date,
        mood = Mood.valueOf(dbModel.mood),
        comment = dbModel.comment
    )

    fun mapMoodEntityToDbModel(entity: MoodEntity) = MoodDbModel(
        id = entity.id,
        date = entity.date,
        mood = entity.mood.name,
        comment = entity.comment
    )

    fun mapListMoodDbModelToEntity(db: List<MoodDbModel>) = db.map {
        mapMoodDbModelToEntity(it)
    }
}

class RepositoryImpl @Inject constructor(
    private val database: MoodDatabase,
    private val mapper: MoodMapper
) : Repository {

    override fun getAllMoods(): Flow<List<MoodEntity>> {
        return database.dao().getAllMoods().map {
            return@map mapper.mapListMoodDbModelToEntity(it)
        }
    }

    override suspend fun addMood(mood: MoodEntity) {
        database.dao().addMood(mapper.mapMoodEntityToDbModel(mood))
    }

    override suspend fun hasTodayMood(date: String): Boolean {
        return database.dao().getMoodByDate(date) != null
    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): MoodDatabase {
        return Room
            .databaseBuilder(appContext, MoodDatabase::class.java, "database-main")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(
        database: MoodDatabase,
        mapper: MoodMapper
    ): Repository = RepositoryImpl(database, mapper)
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
                MoodTrackerTheme {
                    MainScreen()
                }
"""),
                mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
                themesData: ANDThemesData(isDefault: true, content: ""),
                stringsData: ANDStringsData(additional: """
    <string name="save">Save</string>
    <string name="your_mood">Your Mood</string>
    <string name="has_today_mood">You have already added mood today</string>
    <string name="comments_about_day">Comments about day:</string>
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
    implementation Dependencies.room_ktx
    implementation Dependencies.room_runtime
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    kapt Dependencies.room_compiler

}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = """
package dependencies

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
object Build {
    const val build_tools = "com.android.tools.build:gradle:${Versions.gradle}"
    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    const val hilt_plugin = "com.google.dagger:hilt-android-gradle-plugin:${Versions.hilt}"
}
object Application {
    const val id = "\(packageName)"
    const val version_code = 1
    const val version_name = "1.0"
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
