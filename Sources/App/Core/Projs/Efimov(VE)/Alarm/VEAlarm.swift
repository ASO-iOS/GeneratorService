//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import Foundation

struct VEAlarm: FileProviderProtocol {
    static var fileName: String = "VEAlarm.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.os.Build
import androidx.compose.animation.Animatable
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Alarm
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TimePicker
import androidx.compose.material3.TimePickerDefaults
import androidx.compose.material3.Typography
import androidx.compose.material3.rememberTimePickerState
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
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.app.NotificationCompat
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.room.ColumnInfo
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.Update
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import com.ramcosta.composedestinations.navigation.DestinationsNavigator
import com.ramcosta.composedestinations.navigation.popUpTo
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.destinations.AlarmListScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.AlarmScreenDestination
import \(packageName).presentation.fragments.main_fragment.destinations.SplashScreenDestination
import \(packageName).presentation.main_activity.MainActivity
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.UUID
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)

@Composable
fun AlarmMaterialTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        typography = Typography,
        content = content
    )
}

fun AlarmNoteEntity.toAlarmNote() = AlarmNote(
    alarmId = alarmId,
    timestamp = timestamp,
    title = title,
    isEnabled = isEnabled
)

fun AlarmNote.toEntity() = AlarmNoteEntity(
    alarmId = alarmId,
    timestamp = timestamp,
    isEnabled = isEnabled,
    title = title
)

class AlarmRepositoryImpl @Inject constructor(
    private val alarmNoteDao: AlarmNoteDao
): AlarmRepository {

    override fun fetchAlarmList(): Flow<List<AlarmNote>> =
        alarmNoteDao.selectAll().map { list ->
            list.map { item -> item.toAlarmNote() }
        }

    override suspend fun createAlarm(alarmNote: AlarmNote) {
        alarmNoteDao.insert(alarmNote.toEntity())
    }

    override suspend fun updateAlarm(alarmNote: AlarmNote) {
        alarmNoteDao.update(alarmNote.toEntity())
    }

    override suspend fun deleteAlarm(alarmNote: AlarmNote) {
        alarmNoteDao.delete(alarmNote.toEntity())
    }
}

@Dao
interface AlarmNoteDao {

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insert(entity: AlarmNoteEntity)

    @Update(onConflict = OnConflictStrategy.IGNORE)
    suspend fun update(entity: AlarmNoteEntity)

    @Delete
    suspend fun delete(entity: AlarmNoteEntity)

    @Query("SELECT * FROM $TABLE_ALARM_NOTE")
    fun selectAll(): Flow<List<AlarmNoteEntity>>
}

const val TABLE_ALARM_NOTE = "alarms"

@Entity(tableName = TABLE_ALARM_NOTE)
data class AlarmNoteEntity(
    @PrimaryKey
    @ColumnInfo("alarm_id") val alarmId: String,
    @ColumnInfo("timestamp") val timestamp: Long,
    @ColumnInfo("is_enabled") val isEnabled: Boolean,
    @ColumnInfo("title") val title: String?
)

@Database(
    entities = [AlarmNoteEntity::class],
    exportSchema = false,
    version = 1
)
abstract class AppDatabase: RoomDatabase() {
    abstract val alarmNoteDao: AlarmNoteDao
}

class AlarmWorkManager(
    @ApplicationContext private val context: Context,
    workerParams: WorkerParameters
): Worker(context, workerParams) {

    private val pendingIntent get() = PendingIntent.getActivity(
        context,
        Defaults.REQUEST_CODE_ALARM,
        Intent(context, MainActivity::class.java),
        PendingIntent.FLAG_IMMUTABLE
    )

    private val notificationManager get() =
        NotificationCompat.Builder(context, Defaults.TRACKING_CHANNEL_ID)
            .setAutoCancel(false)
            .setOngoing(false)
            .setSmallIcon(R.drawable.alarm_24)
            .setContentTitle(context.getString(R.string.alarm_message))
            .setContentText(context.getString(R.string.wake_up_message))
            .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM))
            .setVibrate(longArrayOf(1000, 1000, 1000, 1000))
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

    override fun doWork(): Result {
        val manager = context.getSystemService(NotificationManager::class.java)
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                Defaults.TRACKING_CHANNEL_ID,
                Defaults.NOTIFICATION_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            )
            manager.createNotificationChannel(channel)
        }

        manager.notify(Defaults.NOTIFY_TAG, notificationManager)
        return Result.success()
    }

    object Defaults {
        const val TRACKING_CHANNEL_ID = "tracking_channel_id"
        const val NOTIFICATION_CHANNEL_NAME = "notification_channel_name"
        const val NOTIFY_TAG = 122
        const val REQUEST_CODE_ALARM = 33
    }
}


class WorkManagerProvider @Inject constructor(
    @ApplicationContext private val context: Context
) {
    private val workManager get() = WorkManager.getInstance(context)

    fun delete(alarmNote: AlarmNote) {
        workManager.cancelAllWorkByTag(alarmNote.alarmId)
    }

    fun update(alarmNote: AlarmNote) {
        if(alarmNote.isEnabled) {
            WorkManager.getInstance(context).enqueue(
                OneTimeWorkRequestBuilder<AlarmWorkManager>()
                    .setInitialDelay(alarmNote.timestamp, TimeUnit.MILLISECONDS)
                    .addTag(alarmNote.alarmId)
                    .build()
            )
        }
        else
            workManager.cancelAllWorkByTag(alarmNote.alarmId)
    }

    fun save(alarmNote: AlarmNote, hours: Int, minutes: Int) {
        val delay = (hours * 60 * 60 + minutes * 60) * 1000L
        WorkManager.getInstance(context).enqueue(
            OneTimeWorkRequestBuilder<AlarmWorkManager>()
                .setInitialDelay(delay, TimeUnit.MILLISECONDS)
                .addTag(alarmNote.alarmId)
                .build()
        )
    }
}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @Provides
    @Singleton
    fun provideAppDatabase(@ApplicationContext context: Context): AppDatabase {
        return Room.databaseBuilder(
            context = context,
            klass = AppDatabase::class.java,
            name = "database.dp"
        ).build()
    }

    @Provides
    @Singleton
    fun provideAlarmRepository(database: AppDatabase): AlarmRepository {
        return AlarmRepositoryImpl(alarmNoteDao = database.alarmNoteDao)
    }

}

data class AlarmNote(
    val alarmId: String = UUID.randomUUID().toString(),
    val timestamp: Long,
    val title: String? = null,
    val isEnabled: Boolean = true
)

interface AlarmRepository {
    fun fetchAlarmList(): Flow<List<AlarmNote>>
    suspend fun createAlarm(alarmNote: AlarmNote)
    suspend fun updateAlarm(alarmNote: AlarmNote)
    suspend fun deleteAlarm(alarmNote: AlarmNote)
}

@Composable
fun AlarmListItem(
    alarmNote: AlarmNote,
    onDeleteClick: () -> Unit,
    onEnabledChanged: (enable: Boolean) -> Unit
) {
    var isEnabled by remember { mutableStateOf(alarmNote.isEnabled) }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp),
        shape = RoundedCornerShape(20),
        elevation = CardDefaults.cardElevation(10.dp),
        colors = CardDefaults.cardColors(
            containerColor = surfaceColor
        )
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceAround
        ) {
            IconButton(onClick = onDeleteClick) {
                Icon(
                    modifier = Modifier.size(30.dp),
                    imageVector = Icons.Default.Close,
                    contentDescription = null,
                    tint = textColorPrimary
                )
            }
            Column {
                alarmNote.title?.let { title ->
                    Text(
                        modifier = Modifier.align(Alignment.CenterHorizontally),
                        text = title,
                        style = MaterialTheme.typography.titleMedium,
                        color = textColorPrimary
                    )
                    Spacer(modifier = Modifier.height(10.dp))
                }
                Text(
                    modifier = Modifier.align(Alignment.CenterHorizontally),
                    text = alarmNote.timestamp.toTime(),
                    style = MaterialTheme.typography.titleLarge,
                    color = textColorPrimary,
                    fontSize = 36.sp
                )
                Spacer(modifier = Modifier.height(5.dp))
                Text(
                    modifier = Modifier.align(Alignment.CenterHorizontally),
                    text = alarmNote.timestamp.toDate(),
                    style = MaterialTheme.typography.titleMedium,
                    color = textColorPrimary
                )
            }
            Switch(
                checked = alarmNote.isEnabled,
                onCheckedChange = {
                    isEnabled = it
                    onEnabledChanged(isEnabled)
                },
                colors = SwitchDefaults.colors(
                    checkedThumbColor = textColorPrimary,
                    checkedTrackColor = buttonColorPrimary
                )
            )
        }
    }
}

@SuppressLint("SimpleDateFormat")
private fun Long.toTime(): String {
    return SimpleDateFormat("HH:mm").format(this)
}

@SuppressLint("SimpleDateFormat")
private fun Long.toDate(): String {
    return SimpleDateFormat("dd.MM").format(this)
}

@Destination
@Composable
fun AlarmListScreen(
    viewModel: AlarmListViewModel = hiltViewModel(),
    navigator: DestinationsNavigator
) {
    val state = viewModel.state

    Scaffold(
        bottomBar = {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 10.dp)
                    .background(backColorPrimary),
                contentAlignment = Alignment.Center
            ) {
                FloatingActionButton(
                    modifier = Modifier.size(70.dp),
                    onClick = { navigator.navigate(AlarmScreenDestination()) },
                    containerColor = buttonColorPrimary
                ) {
                    Icon(
                        modifier = Modifier.size(30.dp),
                        imageVector = Icons.Default.Add,
                        contentDescription = null,
                        tint = textColorPrimary
                    )
                }
            }
        }
    ) { paddings ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary),
            contentAlignment = Alignment.Center
        ) {
            when(state) {
                is UiAlarmListState.Loading -> LinearProgressIndicator()
                is UiAlarmListState.Error -> ShowError(
                    resId = state.resId,
                    onTryAgainClick = viewModel::fetchAlarmList
                )
                is UiAlarmListState.NoItems -> Text(
                    text = stringResource(id = R.string.no_items),
                    style = MaterialTheme.typography.titleLarge,
                    color = textColorPrimary
                )
                is UiAlarmListState.Success -> ShowAlarmList(
                    items = state.alarmList,
                    onDeleteClick = viewModel::delete,
                    onEnabledChanged = { item, value ->
                        viewModel.update(item.copy(isEnabled = value))
                    },
                    paddingValues = paddings
                )
            }
        }
    }
}

@Composable
private fun ShowError(
    resId: Int,
    onTryAgainClick: () -> Unit
) {
    Column(
        modifier = Modifier.padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically)
    ) {
        Text(
            text = stringResource(id = resId),
            style = MaterialTheme.typography.titleLarge,
            color = textColorPrimary
        )
        IconButton(onClick = onTryAgainClick) {
            Icon(
                modifier = Modifier.size(200.dp),
                imageVector = Icons.Default.Refresh,
                contentDescription = null,
                tint = textColorPrimary
            )
        }
    }
}

@Composable
private fun ShowAlarmList(
    items: List<AlarmNote>,
    onDeleteClick: (item: AlarmNote) -> Unit,
    onEnabledChanged: (item: AlarmNote, value: Boolean) -> Unit,
    paddingValues: PaddingValues
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(
                top = 10.dp,
                bottom = paddingValues.calculateBottomPadding() + 10.dp
            ),
        contentPadding = PaddingValues(vertical = 5.dp),
        verticalArrangement = Arrangement.spacedBy(20.dp)
    ) {
        items(items) { alarmNote ->
            AlarmListItem(
                alarmNote = alarmNote,
                onDeleteClick = { onDeleteClick(alarmNote) },
                onEnabledChanged = { onEnabledChanged(alarmNote, it) }
            )
        }
    }
}

@HiltViewModel
class AlarmListViewModel @Inject constructor(
    private val repository: AlarmRepository,
    private val workManagerProvider: WorkManagerProvider
): ViewModel() {

    var state by mutableStateOf<UiAlarmListState>(UiAlarmListState.Loading)
        private set

    init {
        fetchAlarmList()
    }

    fun fetchAlarmList() {
        state = UiAlarmListState.Loading

        viewModelScope.launch {
            kotlin.runCatching { repository.fetchAlarmList() }
                .onSuccess { flowList ->
                    flowList.collect {  list ->
                        state = if(list.isNotEmpty())
                            UiAlarmListState.Success(list)
                        else
                            UiAlarmListState.NoItems
                    }
                }
                .onFailure { state = UiAlarmListState.Error(R.string.unexepected_error) }
        }
    }

    fun delete(alarmNote: AlarmNote) {
        viewModelScope.launch {
            repository.deleteAlarm(alarmNote)
            workManagerProvider.delete(alarmNote)
        }
    }

    fun update(alarmNote: AlarmNote) {
        viewModelScope.launch {
            repository.updateAlarm(alarmNote)
            workManagerProvider.update(alarmNote)
        }
    }
}

sealed class UiAlarmListState {
    object Loading: UiAlarmListState()
    object NoItems: UiAlarmListState()
    class Error(val resId: Int): UiAlarmListState()
    class Success(val alarmList: List<AlarmNote>): UiAlarmListState()
}

@Destination
@Composable
fun AlarmScreen(
    navigator: DestinationsNavigator,
    viewModel: AlarmViewModel = hiltViewModel()
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(horizontal = 20.dp, vertical = 40.dp),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .clip(shape = RoundedCornerShape(20))
                .background(backColorSecondary)
                .padding(10.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            TimePickerWithButtons(
                onCancelClick = navigator::popBackStack,
                onSaveClick = { title, hours, minutes ->
                    viewModel.save(title, hours, minutes)
                    navigator.popBackStack()
                }
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun TimePickerWithButtons(
    onCancelClick: () -> Unit,
    onSaveClick: (title: String?, hours: Int, minutes: Int) -> Unit
) {

    val timeState = rememberTimePickerState(is24Hour = true)
    var title by remember { mutableStateOf("") }

    Column(
        verticalArrangement = Arrangement.spacedBy(10.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        TimePicker(
            state = timeState,
            colors = TimePickerDefaults.colors(
                containerColor = backColorSecondary,
                selectorColor = textColorPrimary,
                clockDialSelectedContentColor = backColorPrimary,
                clockDialColor = backColorSecondary
            )
        )

        TextField(
            value = title,
            onValueChange = { title = it },
            label = {
                Text(
                    text = stringResource(id = R.string.title_label),
                    style = MaterialTheme.typography.bodyLarge,
                    color = textColorPrimary
                )
            },
            singleLine = true
        )
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceAround
        ) {
            Button(
                onClick = onCancelClick,
                colors = ButtonDefaults.buttonColors(
                    containerColor = buttonColorPrimary
                )
            ) {
                Text(text = stringResource(id = R.string.cancel))
            }
            Button(
                onClick = { onSaveClick(title, timeState.hour, timeState.minute) },
                colors = ButtonDefaults.buttonColors(
                    containerColor = buttonColorPrimary
                )
            ) {
                Text(text = stringResource(id = R.string.save))
            }
        }
    }
}

@HiltViewModel
class AlarmViewModel @Inject constructor(
    private val repository: AlarmRepository,
    private val workManagerProvider: WorkManagerProvider
): ViewModel() {

    fun save(title: String?, hours: Int, minutes: Int) {
        viewModelScope.launch {
            val delay = (hours * 60 * 60 + minutes * 60) * 1000L
            val timestamp = System.currentTimeMillis() + delay

            val alarmNote = AlarmNote(
                timestamp = timestamp,
                title = title
            )

            repository.createAlarm(alarmNote)
            workManagerProvider.save(alarmNote, hours, minutes)
        }
    }
}

@RootNavGraph(start = true)
@Destination
@Composable
fun SplashScreen(
    navigator: DestinationsNavigator
) {
    val initColor = backColorPrimary
    val targetColor = backColorSecondary

    val duration = 1000

    val animateShape = remember { Animatable(initialValue = 60f) }
    val animateColor = remember { Animatable(initColor) }

    LaunchedEffect(key1 = animateShape) {
        animateShape.animateTo(
            targetValue = 0f,
            animationSpec = tween(
                durationMillis = duration,
                easing = LinearEasing
            )
        )
        navigator.navigate(AlarmListScreenDestination()) {
            popUpTo(SplashScreenDestination) { inclusive = true }
        }
    }

    LaunchedEffect(key1 = animateColor) {
        animateColor.animateTo(
            targetValue = targetColor,
            animationSpec = tween(
                durationMillis = duration,
                easing = LinearEasing
            )
        )
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .size(250.dp)
                .clip(shape = RoundedCornerShape(20))
                .border(
                    width = Dp(animateShape.value),
                    color = animateColor.asState().value,
                    shape = RoundedCornerShape(20)
                )
                .background(backColorSecondary),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Icon(
                modifier = Modifier.size(100.dp),
                imageVector = Icons.Default.Alarm,
                contentDescription = null,
                tint = textColorPrimary
            )
            Text(
                text = stringResource(id = R.string.app_name),
                style = MaterialTheme.typography.titleLarge,
                color = textColorPrimary,
                fontSize = 28.sp
            )
        }
    }
}



"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        
        return ANDData(mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.ramcosta.composedestinations.DestinationsNavHost
""", content: """
    AlarmMaterialTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            DestinationsNavHost(navGraph = NavGraphs.root)
        }
    }
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="save">Save</string>
    <string name="cancel">Cancel</string>
    <string name="title_label">Alarm title here…</string>
    <string name="unexepected_error">Unexpected error</string>
    <string name="alarm_message">Alarm</string>
    <string name="wake_up_message">Wake up!</string>
    <string name="no_items">Empty</string>
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

plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'dagger.hilt.android.plugin'
    id 'com.google.devtools.ksp' version '1.8.10-1.0.9'
    id 'org.jetbrains.kotlin.plugin.serialization' version '1.8.10'
    id 'kotlin-kapt'
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
            minifyEnabled false
            shrinkResources false
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
    implementation Dependencies.compose_destinations_core
    ksp Dependencies.compose_destinations_ksp
}
"""
        let moduleGradleName = "build.gradle"
        
        let dependencies = """
package dependencies

object Application {
    const val id = "com.vagavagusdevelop.alarmmaterial"
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
    const val hilt = "2.45"
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

    const val compose_destination = "1.8.42-beta"
    const val moshi = "1.15.0"

    const val kotlin_serialization = "1.5.1"
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

    const val compose_destinations_core = "io.github.raamcosta.compose-destinations:core:${Versions.compose_destination}"
    const val compose_destinations_ksp = "io.github.raamcosta.compose-destinations:ksp:${Versions.compose_destination}"

    const val moshi = "com.squareup.moshi:moshi-kotlin:${Versions.moshi}"

    const val kotlinx_serialization = "org.jetbrains.kotlinx:kotlinx-serialization-json:${Versions.kotlin_serialization}"
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
