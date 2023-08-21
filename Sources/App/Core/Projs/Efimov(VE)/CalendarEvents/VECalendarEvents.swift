//
//  File.swift
//  
//
//  Created by admin on 8/21/23.
//

import Foundation

struct VECalendarEvents: FileProviderProtocol {
    static var fileName: String = "CalendarEvents.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Save
import androidx.compose.material.icons.filled.Update
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Divider
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
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
import com.kizitonwose.calendar.compose.WeekCalendar
import com.kizitonwose.calendar.compose.weekcalendar.rememberWeekCalendarState
import com.ramcosta.composedestinations.annotation.Destination
import com.ramcosta.composedestinations.annotation.RootNavGraph
import \(packageName).R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import java.time.DayOfWeek
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.format.TextStyle
import java.util.Locale
import javax.inject.Inject
import javax.inject.Singleton

val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))

val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))

fun UserEventEntity.toUserEvent() = UserEvent(id, content, date)

fun UserEvent.toEntity() = UserEventEntity(id, content, date)

class UserEventRepositoryImpl(
    private val userEventsDao: UserEventsDao
): UserEventRepository {

    override fun fetchEventsByDate(date: Long): Flow<List<UserEvent>> {
        return userEventsDao.selectEventsByDate(date).map { list ->
            list.map { it.toUserEvent() }
        }
    }
    override suspend fun createEvent(userEvent: UserEvent) {
        userEventsDao.insertEvent(userEvent.toEntity())
    }

    override suspend fun deleteEvent(userEvent: UserEvent) {
        userEventsDao.deleteEvent(userEvent.toEntity())
    }

    override suspend fun updateEvent(userEvent: UserEvent) {
        userEventsDao.updateEvent(userEvent.toEntity())
    }
}

const val TABLE_USER_EVENTS = "user_events"
@Entity(tableName = TABLE_USER_EVENTS)
data class UserEventEntity(
    @PrimaryKey(autoGenerate = true)
    @ColumnInfo("id") val id: Long,
    @ColumnInfo("content")val content: String,
    @ColumnInfo("date")val date: Long
)

@Database(
    entities = [UserEventEntity::class],
    version = 1,
    exportSchema = false
)

abstract class AppDatabase: RoomDatabase() {
    abstract val userEventsDao: UserEventsDao
}

@Dao
interface UserEventsDao {
    @Query("SELECT * FROM $TABLE_USER_EVENTS WHERE date == :date")
    fun selectEventsByDate(date: Long): Flow<List<UserEventEntity>>

    @Insert
    suspend fun insertEvent(userEvent: UserEventEntity)

    @Delete
    suspend fun deleteEvent(userEvent: UserEventEntity)

    @Update(onConflict = OnConflictStrategy.REPLACE)
    suspend fun updateEvent(userEvent: UserEventEntity)

}

@Module
@InstallIn(SingletonComponent::class)
class DataModule {

    @[Provides Singleton]
    fun provideAppDatabase(@ApplicationContext context: Context): AppDatabase {
        return Room.databaseBuilder(
            context = context,
            klass = AppDatabase::class.java,
            name = "appdatabase.db"
        ).build()
    }

    @[Provides Singleton]
    fun provideUserEventRepository(database: AppDatabase): UserEventRepository {
        return UserEventRepositoryImpl(
            userEventsDao = database.userEventsDao
        )
    }

}

data class UserEvent(
    val id: Long,
    val content: String,
    val date: Long
)

interface UserEventRepository {
    fun fetchEventsByDate(date: Long): Flow<List<UserEvent>>
    suspend fun createEvent(userEvent: UserEvent)
    suspend fun deleteEvent(userEvent: UserEvent)
    suspend fun updateEvent(userEvent: UserEvent)

}

class DeleteEventUseCase @Inject constructor(
    private val repository: UserEventRepository
) {
    suspend operator fun invoke(userEvent: UserEvent) {
        repository.deleteEvent(userEvent)
    }
}

class FetchEventsUseCase @Inject constructor(
    private val repository: UserEventRepository
) {
    operator fun invoke(date: Long) = repository.fetchEventsByDate(date)
}

class SaveEventUseCase @Inject constructor(
    private val repository: UserEventRepository
) {
    suspend operator fun invoke(userEvent: UserEvent) {
        repository.createEvent(userEvent)
    }
}

class UpdateEventUseCase @Inject constructor(
    private val repository: UserEventRepository
) {
    suspend operator fun invoke(userEvent: UserEvent) {
        repository.updateEvent(userEvent)
    }
}

private val dateFormatter = DateTimeFormatter.ofPattern("dd")
@Composable
fun Day(
    date: LocalDate,
    isSelected: Boolean,
    onClick: (LocalDate) -> Unit
) {
    val boxColor = if(isSelected) buttonColorPrimary else buttonColorSecondary
    val textColorCondition = date != LocalDate.now()

    Box(
        modifier = Modifier
            .fillMaxWidth()
            .wrapContentHeight()
            .padding(5.dp)
            .clickable { onClick(date) }
            .clip(shape = RoundedCornerShape(10))
            .background(boxColor),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier.padding(vertical = 10.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(6.dp, Alignment.CenterVertically),
        ) {
            Text(
                text = date.dayOfWeek.displayText(),
                fontSize = 12.sp,
                color = if(textColorCondition) textColorPrimary else textColorSecondary,
                fontWeight = FontWeight.Bold,
            )
            Text(
                text = dateFormatter.format(date),
                fontSize = 14.sp,
                color = textColorPrimary,
                fontWeight = FontWeight.Bold,
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun UserEventItem(
    userEvent: UserEvent,
    onEventClick: (userEvent: UserEvent) -> Unit,
    onRemoveClick: (userEvent: UserEvent) -> Unit
) {
    Card(
        onClick = { onEventClick(userEvent) },
        colors = CardDefaults.cardColors(
            containerColor = surfaceColor
        )
    ) {
        ListItem(
            headlineContent = {
                Text(
                    modifier = Modifier
                        .padding(horizontal = 10.dp, vertical = 20.dp),
                    text = userEvent.content,
                    color = textColorPrimary,
                    fontSize = 20.sp
                )
            },
            trailingContent = {
                IconButton(
                    onClick = { onRemoveClick(userEvent) }
                ) {
                    Icon(
                        modifier = Modifier.size(20.dp),
                        imageVector = Icons.Default.Close,
                        contentDescription = null,
                        tint = textColorPrimary
                    )
                }
            },
            colors = ListItemDefaults.colors(
                containerColor = surfaceColor
            )
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@RootNavGraph(start = true)
@Destination
@Composable
fun CalendarScreen(
    viewModel: CalendarViewModel = hiltViewModel()
) {
    val uiState = viewModel.uiState.collectAsState().value
    var isDialogShow by remember { mutableStateOf(false) }
    var selectedDateLong by remember { mutableStateOf(LocalDate.now().dayOfYear.toLong()) }
    var selectedUserEvent: UserEvent? by remember { mutableStateOf(null) }

    if(isDialogShow) {
        AddEditEventDialog(
            onDismiss = { isDialogShow = false },
            onSavePressed = { content -> viewModel.saveEvent(content, selectedDateLong) },
            onUpdatePressed = { userEvent ->
                viewModel.updateEvent(userEvent)
                selectedUserEvent = null
            },
            userEvent = selectedUserEvent
        )
    }

    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        modifier = Modifier.fillMaxWidth(),
                        text = stringResource(id = R.string.calendar_title),
                        color = textColorPrimary,
                        fontSize = 30.sp,
                        textAlign = TextAlign.Center
                    )
                },
                colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
                    containerColor = backColorPrimary
                )
            )
        },
        bottomBar = {
            BottomAppBar(
                containerColor = backColorPrimary,
                actions = {},
                floatingActionButton = {
                    FloatingActionButton(
                        onClick = { isDialogShow = true },
                        containerColor = buttonColorPrimary
                    ) {
                        Icon(
                            imageVector = Icons.Default.Add,
                            contentDescription = null,
                            tint = textColorPrimary
                        )
                    }
                }
            )
        }
    ) { scaffoldPaddings ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(scaffoldPaddings),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            TopCalendar(
                onSelectedChanged = {
                    selectedDateLong = it
                    viewModel.dateFlow.value = it
                }
            )
            Box(
                modifier = Modifier.fillMaxSize(),
                contentAlignment = Alignment.Center
            ) {
                when(uiState) {
                    is UiCalendarState.Loading -> CircularProgressIndicator(
                        color = textColorPrimary
                    )
                    is UiCalendarState.NoItems -> Text(
                        text = stringResource(id = R.string.no_items),
                        color = textColorPrimary,
                        fontSize = 20.sp
                    )
                    is UiCalendarState.Events -> UserEventList(
                        events = uiState.events,
                        onEventClick = { event ->
                            selectedUserEvent = event
                            isDialogShow = true
                        },
                        onRemoveClick = { viewModel.removeEvent(it) }
                    )
                }
            }
        }
    }
}

@Composable
private fun UserEventList(
    events: List<UserEvent>,
    onEventClick: (userEvent: UserEvent) -> Unit,
    onRemoveClick: (userEvent: UserEvent) -> Unit
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(top = 5.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp),
        contentPadding = PaddingValues(10.dp)
    ) {
        items(events) { event ->
            UserEventItem(
                userEvent = event,
                onEventClick = onEventClick,
                onRemoveClick = onRemoveClick
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun AddEditEventDialog(
    onDismiss: () -> Unit,
    onSavePressed: (eventContent: String) -> Unit,
    onUpdatePressed: (userEvent: UserEvent) -> Unit,
    userEvent: UserEvent? = null
) {
    var eventContent by remember { mutableStateOf(userEvent?.content ?: "") }
    val bottomSheetState = rememberModalBottomSheetState(skipPartiallyExpanded = false)
    val focusRequest = remember { FocusRequester() }

    LaunchedEffect(key1 = Unit) {
        focusRequest.requestFocus()
    }

    ModalBottomSheet(
        modifier = Modifier.fillMaxHeight(0.5f),
        sheetState = bottomSheetState,
        onDismissRequest = onDismiss,
        containerColor = surfaceColor,
        shape = RoundedCornerShape(topStartPercent = 10, topEndPercent = 10)
    ) {
        ListItem(
            colors = ListItemDefaults.colors(
                containerColor = surfaceColor
            ),
            headlineContent = {
                OutlinedTextField(
                    modifier = Modifier.focusRequester(focusRequest),
                    value = eventContent,
                    onValueChange = { eventContent = it },
                    label = {
                        Text(
                            text = stringResource(id = R.string.event_name_label),
                            color = textColorPrimary,
                            fontSize = 30.sp
                        )
                    },
                    colors = OutlinedTextFieldDefaults.colors(
                        focusedBorderColor = textColorPrimary
                    )
                )
            },
            trailingContent = {
                FloatingActionButton(
                    onClick = {
                        when(userEvent) {
                            null -> if(eventContent.isNotEmpty()) onSavePressed(eventContent)
                            else -> onUpdatePressed(userEvent.copy(content = eventContent))
                        }

                        onDismiss()
                    },
                    containerColor = buttonColorPrimary
                ) {
                    Icon(
                        modifier = Modifier.size(40.dp),
                        imageVector = if(userEvent == null) Icons.Default.Save else Icons.Default.Update,
                        contentDescription = null,
                        tint = textColorPrimary
                    )
                }
            }
        )
    }
}

@Composable
private fun TopCalendar(
    onSelectedChanged: (selectedDate: Long) -> Unit
) {
    val currentDate = remember { LocalDate.now() }
    val startDate = remember { currentDate.minusDays(500) }
    val endDate = remember { currentDate.plusDays(500) }
    var selection by remember { mutableStateOf(currentDate) }

    Column(
        modifier = Modifier.fillMaxWidth()
    ) {
        val state = rememberWeekCalendarState(
            startDate = startDate,
            endDate = endDate,
            firstVisibleWeekDate = currentDate,
        )

        WeekCalendar(
            state = state,
            dayContent = { day ->
                Day(
                    date = day.date,
                    isSelected = selection == day.date,
                    onClick = { clicked ->
                        if (selection != clicked) {
                            selection = clicked
                            onSelectedChanged(day.date.dayOfYear.toLong())
                        }
                    }
                )
            }
        )

        Divider(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp),
            color = textColorPrimary
        )
    }
}

@OptIn(ExperimentalCoroutinesApi::class)
@HiltViewModel
class CalendarViewModel @Inject constructor(
    private val fetchEventsUseCase: FetchEventsUseCase,
    private val saveEventUseCase: SaveEventUseCase,
    private val deleteEventUseCase: DeleteEventUseCase,
    private val updateEventUseCase: UpdateEventUseCase
) : ViewModel() {

    val dateFlow = MutableStateFlow(LocalDate.now().dayOfYear.toLong())

    private val _uiState = MutableStateFlow<UiCalendarState>(UiCalendarState.Loading)
    val uiState = _uiState.asStateFlow()

    init {
        viewModelScope.launch {
            dateFlow
                .flatMapLatest { date -> fetchEventsUseCase(date) }
                .collect { list ->
                    if (list.isEmpty())
                        _uiState.value = UiCalendarState.NoItems
                    else
                        _uiState.value = UiCalendarState.Events(list)
                }
        }
    }

    fun saveEvent(content: String, date: Long) {
        val userEvent = UserEvent(
            id = 0,
            content = content,
            date = date
        )

        viewModelScope.launch {
            saveEventUseCase(userEvent)
        }
    }

    fun updateEvent(userEvent: UserEvent) {
        viewModelScope.launch {
            updateEventUseCase(userEvent)
        }
    }

    fun removeEvent(event: UserEvent) {
        viewModelScope.launch {
            deleteEventUseCase(event)
        }
    }
}

sealed class UiCalendarState {
    object Loading: UiCalendarState()
    object NoItems: UiCalendarState()
    class Events(val events: List<UserEvent>): UiCalendarState()
}

fun DayOfWeek.displayText(uppercase: Boolean = false): String {
    return getDisplayName(TextStyle.SHORT, Locale.ENGLISH).let { value ->
        if (uppercase) value.uppercase(Locale.ENGLISH) else value
    }
}

"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(imports: """
import androidx.compose.material.Surface
""", content: """
    Surface {
        CalendarScreen()
    }
"""),
            mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""),
            themesData: ANDThemesData(isDefault: true, content: ""),
            stringsData: ANDStringsData(additional: """
    <string name="calendar_title">Check your events</string>
    <string name="no_items">No events</string>
    <string name="event_name_label">Event name</string>
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

plugins {
    id 'com.google.devtools.ksp' version '1.8.10-1.0.9'
}
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
        coreLibraryDesugaringEnabled true
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
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_destinations_core
    ksp Dependencies.compose_destinations_ksp
    implementation Dependencies.calendar_compose
    implementation Dependencies.room_ktx
    implementation Dependencies.room_runtime
    ksp Dependencies.room_compiler
    coreLibraryDesugaring Dependencies.desugar
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

    const val compose_destination = "1.8.42-beta"
    const val moshi = "1.15.0"

    const val kotlin_serialization = "1.5.1"
    const val datastore_preferences = "1.0.0"

    const val calendar_compose = "2.3.0"

    const val desugar_version = "1.1.8"
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

    const val compose_destinations_core = "io.github.raamcosta.compose-destinations:core:${Versions.compose_destination}"
    const val compose_destinations_ksp = "io.github.raamcosta.compose-destinations:ksp:${Versions.compose_destination}"

    const val moshi = "com.squareup.moshi:moshi-kotlin:${Versions.moshi}"

    const val kotlinx_serialization = "org.jetbrains.kotlinx:kotlinx-serialization-json:${Versions.kotlin_serialization}"

    const val data_store = "androidx.datastore:datastore-preferences:${Versions.datastore_preferences}"

    const val calendar_compose = "com.kizitonwose.calendar:compose:${Versions.calendar_compose}"

    const val desugar = "com.android.tools:desugar_jdk_libs:${Versions.desugar_version}"
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
