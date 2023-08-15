//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import Foundation

struct MBAlarm: FileProviderProtocol {
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            AlarmTheme {
                MBAlarm()
            }
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: ""),
            colorsData: ANDColorsData(additional: "")
        )
    }
    
    
    static var fileName = "MBAlarm.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.media.RingtoneManager
import android.os.Build
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.Composable
import androidx.core.app.NotificationCompat
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.work.Worker
import androidx.work.WorkerParameters
import \(packageName).R
import \(packageName).presentation.main_activity.MainActivity
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ColumnScope
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DarkMode
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DatePickerDefaults
import androidx.compose.material3.DatePickerDialog
import androidx.compose.material3.Divider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TimePicker
import androidx.compose.material3.TimePickerDefaults
import androidx.compose.material3.TimePickerState
import androidx.compose.material3.Typography
import androidx.compose.material3.rememberTimePickerState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.room.Delete
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.concurrent.TimeUnit
import javax.inject.Singleton

val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val mainTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val mainButtonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val mainTextSize = \(uiSettings.textSizePrimary ?? 18)
val mainPadding = \(uiSettings.paddingPrimary ?? 12)

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    ),
    displayMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 1.sp
    ),
    displaySmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W300,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    ),
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    )
)

@Composable
fun MBAlarm(viewModel: MainViewModel = hiltViewModel()) {
    AlarmTheme(darkTheme = viewModel.darkTheme) {
        Scaffold { paddingValues ->

            Column(
                modifier = Modifier
                    .background(color = backColor)
                    .padding(paddingValues),
                verticalArrangement = Arrangement.SpaceEvenly,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                AlarmsList()
                TimePickerDisplay()
                ButtonAdd()
            }
        }
    }
}

@Composable
fun AlarmView(alarmItem: AlarmItem, viewModel: MainViewModel = viewModel()) {
    val workManager = WorkManager.getInstance(LocalContext.current)
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = mainPadding.dp, vertical = mainPadding.dp)
                    .background(color = backColor),
        horizontalArrangement = Arrangement.SpaceEvenly,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = alarmItem.timestamp,
            style = MaterialTheme.typography.displayLarge,
            color = mainTextColor
        )
        IconButton(
            onClick = {
                viewModel.removeAlarm(alarmItem)
                workManager.cancelAllWorkByTag(alarmItem.id)
            },
            colors = IconButtonDefaults.iconButtonColors(
                contentColor = colorScheme.onSurface
            )
        ) {
            Icon(
                imageVector = Icons.Default.Delete,
                contentDescription = "Remove alarm",
                tint = mainTextColor
            )
        }
    }
}

@Composable
fun ButtonAdd(viewModel: MainViewModel = viewModel()) {
    Button(
        modifier = Modifier
            .fillMaxWidth()
            .padding(
                start = mainPadding.dp,
                end = mainPadding.dp,
                bottom = mainPadding.dp,
                top = mainPadding.dp
            )
                    .background(color = backColor)
            .shadow(
                elevation = 4.dp,
                ambientColor = colorScheme.onSurface
            ),
        shape = RoundedCornerShape(8.dp),
        border = BorderStroke(
            width = 3.dp,
            color = colorScheme.onBackground
        ),
        colors = ButtonDefaults.buttonColors(
            containerColor = mainButtonColor,
            contentColor = mainTextColor
        ),
        onClick = {
            viewModel.showTimePicker()
        }
    ) {
        Text(
            text = "Add alarm",
            style = MaterialTheme.typography.displayMedium,
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TimePickerDisplay(
    viewModel: MainViewModel = viewModel(),
) {
    val state = rememberTimePickerState(is24Hour = true)

    if (viewModel.timePickerState) {
        DatePickerDialog(
            onDismissRequest = {
                viewModel.hideTimePicker()
            },
            confirmButton = {
                ConfirmButton(state = state)
            },
            dismissButton = {
                DismissButton()
            },
            colors = DatePickerDefaults.colors(
                containerColor = colorScheme.surface
            )
        ) {
            TimePicker(
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .padding(mainPadding.dp)
                    .background(color = backColor),
                state = state,
                colors = TimePickerDefaults.colors(
                    selectorColor = colorScheme.surface,
                    timeSelectorSelectedContainerColor = colorScheme.onPrimary,
                    timeSelectorSelectedContentColor = colorScheme.onSurface,
                    timeSelectorUnselectedContainerColor = colorScheme.onPrimary,
                    timeSelectorUnselectedContentColor = colorScheme.onSurface,
                    clockDialColor = colorScheme.onPrimary,
                    clockDialSelectedContentColor = colorScheme.onSurface,
                    clockDialUnselectedContentColor = colorScheme.onSurface
                )
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun ConfirmButton(viewModel: MainViewModel = viewModel(), state: TimePickerState) {
    val context = LocalContext.current
    Button(
        onClick = {
            viewModel.setAlarm(state = state, context = context)
        },
        colors = ButtonDefaults.buttonColors(
            containerColor = colorScheme.surface
        )
    ) {
        Text(
            text = "Confirm",
            style = MaterialTheme.typography.displayMedium,
            color = colorScheme.onSurface
        )
    }
}

@Composable
fun DismissButton(viewModel: MainViewModel = viewModel()) {
    Button(
        onClick = {
            viewModel.hideTimePicker()
        },
        colors = ButtonDefaults.buttonColors(
            containerColor = colorScheme.surface
        )
    ) {
        Text(
            text = "Dismiss",
            style = MaterialTheme.typography.displayMedium,
            color = colorScheme.onSurface
        )
    }
}

@Composable
fun ColumnScope.AlarmsList(viewModel: MainViewModel = viewModel()) {
    val listAlarms = viewModel.alarms.collectAsState(initial = listOf()).value
    LazyColumn(
        modifier = Modifier
            .fillMaxSize(0.9f)
                    .background(color = backColor)
            .weight(1f),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        if (listAlarms.isEmpty()) {
            item {
                Spacer(modifier = Modifier.padding(32.dp))
                Text(text = "No alarm clock has been set yet", color = mainTextColor, fontSize = mainTextSize.sp)
            }
        } else {
            items(
                items = listAlarms,
                key = { listItem ->
                    listItem.id
                }
            ) { alarmItem ->
                AlarmView(alarmItem = alarmItem)
                Divider()
            }
        }


    }
}

@Composable
fun ButtonChangeTheme(viewModel: MainViewModel = viewModel()) {
    IconButton(
        onClick = {
            viewModel.changeTheme()
        },
        colors = IconButtonDefaults.iconButtonColors(
            contentColor = colorScheme.onSurface
        )
    ) {
        Icon(
            imageVector = Icons.Default.DarkMode,
            contentDescription = "Change mode",
        )
    }
}

@Composable
fun AlarmTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    viewModel: MainViewModel = viewModel(),
    content: @Composable () -> Unit
) {
//    val colorScheme = when (viewModel.darkTheme) {
//        false -> LightColorScheme
//        true -> DarkColorScheme
//    }
//
//    val systemUiController = rememberSystemUiController()
//
//    SideEffect {
//        systemUiController.setNavigationBarColor(
//            color = colorScheme.background,
//            darkIcons = !darkTheme
//        )
//        systemUiController.setStatusBarColor(
//            color = colorScheme.background,
//            darkIcons = !darkTheme
//        )
//    }

    MaterialTheme(
//        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}

@Entity(tableName = "alarms")
data class AlarmItem(
    val timestamp: String,
    @PrimaryKey
    val id: String
)

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Singleton
    @Provides
    fun provideDatabase(@ApplicationContext appContext: Context): Database {
        return Room
            .databaseBuilder(appContext, Database::class.java, "database-name")
            .build()
    }

    @Singleton
    @Provides
    fun provideRepository(database: Database): LocalRepository = LocalRepositoryImpl(database)

    @Singleton
    @Provides
    fun provideSharedPreferences(
        @ApplicationContext context: Context
    ): SharedPreferences = context.getSharedPreferences(
        Constants.SHARED_PREFERENCES_NAME,
        Context.MODE_PRIVATE
    )
}

object Constants {

    const val THEME_KEY = "THEME_KEY"

    const val SHARED_PREFERENCES_NAME = "SHARED_PREFERENCES_NAME"

}

@androidx.room.Dao
interface Dao {

    @Query("SELECT * FROM alarms")
    fun getAllAlarms(): Flow<List<AlarmItem>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAlarmIntoDatabase(recordingItem: AlarmItem)

    @Delete
    suspend fun removeAlarmFromDatabase(recordingItem: AlarmItem)
}


@androidx.room.Database(entities = [AlarmItem::class], version = 1)
abstract class Database : RoomDatabase() {
    abstract fun dao(): Dao
}

interface LocalRepository {

    fun getData(): Flow<List<AlarmItem>>

    suspend fun putData(alarmItem: AlarmItem)

    suspend fun deleteData(alarmItem: AlarmItem)

}

class LocalRepositoryImpl @Inject constructor(
    private val database: Database
) : LocalRepository {

    override fun getData(): Flow<List<AlarmItem>> =
        database.dao().getAllAlarms()

    override suspend fun putData(alarmItem: AlarmItem) =
        database.dao().insertAlarmIntoDatabase(alarmItem)


    override suspend fun deleteData(alarmItem: AlarmItem) =
        database.dao().removeAlarmFromDatabase(alarmItem)

}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val localRepository: LocalRepository,
    private val sharedPrefs: SharedPreferences
) : ViewModel() {

    var timePickerState by mutableStateOf(false)
        private set

    val alarms = localRepository.getData()

    var darkTheme by mutableStateOf(sharedPrefs.getBoolean(Constants.THEME_KEY, false))
        private set

    fun changeTheme() {
        darkTheme = !darkTheme
        sharedPrefs.edit().putBoolean(Constants.THEME_KEY, darkTheme).apply()
    }

    private fun addAlarm(alarmItem: AlarmItem) {
        viewModelScope.launch {
            localRepository.putData(alarmItem)
        }
    }

    fun removeAlarm(alarmItem: AlarmItem) {
        viewModelScope.launch {
            localRepository.deleteData(alarmItem)
        }
    }

    fun hideTimePicker() {
        timePickerState = false
    }

    fun showTimePicker() {
        timePickerState = true
    }

    @OptIn(ExperimentalMaterial3Api::class)
    fun setAlarm(state: TimePickerState, context: Context) {
        val delay = (state.hour * 60 * 60 + state.minute * 60) * 1000L
        val timestamp = SimpleDateFormat("HH:mm dd.MM")
            .format(System.currentTimeMillis() + delay)

        val tag = System.currentTimeMillis().toString()

        WorkManager.getInstance(context).enqueue(
            OneTimeWorkRequestBuilder<TimerWorkManager>()
                .setInitialDelay(delay, TimeUnit.MILLISECONDS)
                .addTag(tag)
                .build()
        )
        addAlarm(AlarmItem(timestamp = timestamp, id = tag))
        hideTimePicker()
    }

}

class TimerWorkManager(
    private val context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    override fun doWork(): Result {
        val builder = NotificationCompat.Builder(context, "tracking_channel")
            .setAutoCancel(false)
            .setOngoing(false)
            .setSmallIcon(R.drawable.baseline_access_alarm_24)
            .setContentTitle("Alarm")
            .setContentText("Wake Up!")
            .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM))
            .setVibrate(longArrayOf(1000, 1000, 1000, 1000))
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "tracking_channel", "name",
                NotificationManager.IMPORTANCE_HIGH
            )
            manager.createNotificationChannel(channel)
        }

        manager.notify(1, builder.build())

        return Result.success()
    }

    private val pendingIntent = PendingIntent.getActivity(
        context,
        0,
        Intent(context, MainActivity::class.java),
        PendingIntent.FLAG_IMMUTABLE
    )

}
"""
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
    implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
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
    
}
