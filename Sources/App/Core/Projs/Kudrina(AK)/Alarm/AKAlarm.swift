//
//  File.swift
//  
//
//  Created by admin on 10.08.2023.
//

import Foundation

struct AKAlarm: FileProviderProtocol {
    static var fileName: String = "AKAlarm.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Card
import androidx.compose.material.Icon
import androidx.compose.material.IconButton
import androidx.compose.material.Text
import androidx.compose.material3.DatePickerDefaults
import androidx.compose.material3.DatePickerDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.TimePicker
import androidx.compose.material3.TimePickerDefaults
import androidx.compose.material3.TimePickerLayoutType
import androidx.compose.material3.TimePickerState
import androidx.compose.material3.rememberTimePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.room.Delete
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
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch
import java.util.Calendar
import javax.inject.Inject
import javax.inject.Singleton


val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val onPrimaryColor = Color(0xFF\(uiSettings.onPrimaryColor ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

val paddingPrimary = 24.dp

fun alarmTextModification(hour: Int, minute: Int, context: Context): String {
    var currentHour = ""
    var currentMinute = ""

    if (hour.toString().length == 1) {
        currentHour += "0$hour"
    } else {
        currentHour += "$hour"
    }

    if (minute.toString().length == 1) {
        currentMinute += "0$minute"
    } else {
        currentMinute += "$minute"
    }

    return context.getString(R.string.alarm_text_for_display, currentHour, currentMinute)
}

class AlarmReciever : BroadcastReceiver() {

    override fun onReceive(p0: Context?, p1: Intent?) {

        //Log.v("MyAlarm", "Alarm is just fired")

        CoroutineScope(Dispatchers.Default).launch {
            val notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            val ringtone = RingtoneManager.getRingtone(p0, notification)
            ringtone.play()
            delay(10000)
            ringtone.stop()
        }
    }
}


lateinit var alarmManager: AlarmManager


fun setAlarm(timeFromUIHour: Int, timeFromUIMinute: Int, context: Context) {

    val calendar: Calendar = Calendar.getInstance()

    if (timeFromUIHour < calendar.get(Calendar.HOUR) || timeFromUIMinute < calendar.get(Calendar.MINUTE) && timeFromUIHour == calendar.get(
            Calendar.HOUR)) {
        calendar.set(
            calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH + 1),
            timeFromUIHour,
            timeFromUIMinute,
            0
        )
    } else {
        calendar.set(
            calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH),
            timeFromUIHour,
            timeFromUIMinute,
            0
        )
    }


    //getting the alarm manager
    alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    //creating a new intent specifying the broadcast receiver
    val intent = Intent(context, AlarmReciever::class.java)

    //creating a pending intent using the intent
    val pendingIntent = PendingIntent.getBroadcast(
        context,
        0,
        intent,
        PendingIntent.FLAG_MUTABLE
    )

    val timeToSet = calendar.timeInMillis


    alarmManager.setRepeating(AlarmManager.RTC, timeToSet, AlarmManager.INTERVAL_DAY, pendingIntent)
    Toast.makeText(context, R.string.alarm_toast_text, Toast.LENGTH_SHORT).show()
}

fun cancel(item: AlarmItem, context: Context) {

    alarmManager.cancel(
        PendingIntent.getBroadcast(
            context,
            item.hashCode(),
            Intent(context, AlarmReciever::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    )
}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val localRepository: LocalRepository
) : ViewModel() {

    var timePickerState by mutableStateOf(false)
        private set

    val alarms = localRepository.getData()


    fun addAlarm(alarm: String) {
        viewModelScope.launch {
            localRepository.putData(AlarmItem(timestamp = alarm))
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


}

@Composable
fun AddButton(openDialog: MutableState<Boolean>, viewModel: MainViewModel) {
    androidx.compose.material3.Button(
        onClick = {
            openDialog.value = !openDialog.value
            viewModel.showTimePicker()
        },
        colors = androidx.compose.material3.ButtonDefaults.buttonColors(
            containerColor = buttonColorPrimary
        ),
        modifier = Modifier.padding(top = 10.dp, bottom = 10.dp)
    ) {
        Text(
            text = stringResource(id = R.string.button_add_text),
            color = textColorPrimary,
            fontSize = 16.sp
        )
    }
}

@Composable
fun CardForList(item: AlarmItem, viewModel: MainViewModel) {
    Card(
        backgroundColor = onPrimaryColor,
        shape = RoundedCornerShape(50),
        modifier = Modifier
            .fillMaxWidth()
            .padding(start = paddingPrimary, end = paddingPrimary, bottom = 10.dp),

        ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {

            Text(
                text = item.timestamp,
                modifier = Modifier.padding(
                    start = 12.dp,
                    top = 6.dp,
                    bottom = 6.dp
                ),
                fontSize = 20.sp,
                color = textColorSecondary
            )

            val context = LocalContext.current
            IconButton(
                onClick = {
                    viewModel.removeAlarm(item)
                    cancel(item, context)
                }
            ) {
                Icon(
                    modifier = Modifier
                        .size(40.dp)
                        .padding(top = 6.dp, bottom = 6.dp, end = 6.dp),
                    painter = painterResource(id = R.drawable.icon_delete),
                    contentDescription = stringResource(id = R.string.delete_icon_desc),
                    tint = textColorSecondary
                )
            }
        }

    }
}

@Composable
fun ColumnForItems(listAlarms: List<AlarmItem>,viewModel:MainViewModel) {
    LazyColumn(
        modifier = Modifier.fillMaxWidth()
    ) {
        items(listAlarms) { alarm->
            CardForList(alarm, viewModel)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ConfirmButton(viewModel: MainViewModel = hiltViewModel(), state: TimePickerState) {
    val context = LocalContext.current
    androidx.compose.material3.Button(
        onClick = {
            viewModel.hideTimePicker()
            setAlarm(state.hour, state.minute, context)
            viewModel.addAlarm(alarmTextModification(state.hour, state.minute, context))
        },
        colors = androidx.compose.material3.ButtonDefaults.buttonColors(
            containerColor = buttonColorPrimary
        )
    ) {
        Text(
            text = stringResource(id = R.string.confirm_button_text),
            fontSize = 16.sp,
            color = textColorPrimary
        )
    }
}

@Composable
fun DismissButton(viewModel: MainViewModel = hiltViewModel()) {
    androidx.compose.material3.Button(
        onClick = {
            viewModel.hideTimePicker()
        },
        colors = androidx.compose.material3.ButtonDefaults.buttonColors(
            containerColor = buttonColorPrimary
        )
    ) {
        Text(
            text = stringResource(id = R.string.dismiss_button_text),
            fontSize = 16.sp,
            color = textColorPrimary
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AlarmScreen(viewModel: MainViewModel = hiltViewModel()) {

    val listAlarms = viewModel.alarms.collectAsState(initial = listOf()).value

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        horizontalAlignment = Alignment.CenterHorizontally,

        ) {

        val openDialog = rememberSaveable {
            mutableStateOf(false)
        }

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
                    containerColor = surfaceColor
                )
            ) {
                TimePicker(
                    modifier = Modifier
                        .align(Alignment.CenterHorizontally)
                        .padding(10.dp),
                    state = state,
                    layoutType = TimePickerLayoutType.Vertical,
                    colors = TimePickerDefaults.colors(
                        timeSelectorUnselectedContentColor = textColorSecondary,
                        timeSelectorSelectedContainerColor = primaryColor,
                        timeSelectorSelectedContentColor = textColorPrimary,
                        selectorColor = surfaceColor,
                        timeSelectorUnselectedContainerColor = onPrimaryColor,
                        clockDialColor = primaryColor,
                        clockDialUnselectedContentColor = textColorPrimary,
                        clockDialSelectedContentColor = primaryColor

                    )
                )
            }
        }


        AddButton(openDialog, viewModel)

        if (listAlarms.isEmpty()) {
            Text(
                text = stringResource(id = R.string.text_no_alarms),
                color = textColorSecondary,
                fontSize = 16.sp
            )
        } else {
            ColumnForItems(listAlarms, viewModel)
        }
    }

}

@Entity(tableName = "alarms")
data class AlarmItem(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,

    val timestamp: String
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
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
AlarmScreen()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="alarm_toast_text">Alarm is set</string>
    <string name="button_add_text">Добавить будильник</string>
    <string name="delete_icon_desc">delete</string>
    <string name="confirm_button_text">OK</string>
    <string name="dismiss_button_text">Назад</string>
    <string name="text_no_alarms">Нет будильников</string>
    <string name="two_dots">:</string>
    <string name="alarm_text_for_display">%1$s:%2$s</string>
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

    implementation Dependencies.room_runtime
    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx

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
