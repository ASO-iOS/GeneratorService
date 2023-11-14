//
//  File.swift
//  
//
//  Created by admin on 11/13/23.
//

import Foundation

struct KDNotes: FileProviderProtocol {
    
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import android.content.Context
import android.util.Log
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight.Companion.Bold
import androidx.compose.ui.text.font.FontWeight.Companion.ExtraBold
import androidx.compose.ui.text.font.FontWeight.Companion.Normal
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
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
import \(packageName).R
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import dagger.Binds
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

val mainHeader = TextStyle(
    fontSize = 20.sp,
    fontWeight = Bold
)

val mainDesc = TextStyle(
    fontSize = 17.sp,
    fontWeight = Normal
)

val noteHeader = TextStyle(
    fontSize = 28.sp,
    fontWeight = ExtraBold
)

val noteDesc = TextStyle(
    fontSize = 20.sp,
    fontWeight = Normal
)


abstract class BaseViewModel<State, Effect>(initState: State) : ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    private val _effects: Channel<Effect> = Channel()
    val effects: Flow<Effect> = _effects.receiveAsFlow()

    fun sendEffect(effect: Effect) = viewModelScope.launch {
        _effects.send(effect)
    }

    protected val state: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State) {
        _viewState.value = viewState.value.changeState()
    }


}


const val DEBUG = "AppDebug"

fun Any?.logDebug(prefix: String = "", postfix: String = "") {
    val debugMessage = "$prefix $this $postfix"
    if (this is Throwable?) {
        Log.e(DEBUG, debugMessage)
    } else {
        Log.i(DEBUG, debugMessage)
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


@Module
@InstallIn(SingletonComponent::class)
object RoomModule {
    private const val ROOM_DATABASE = "room-database"

    @Provides
    @Singleton
    fun provideDatabase(@ApplicationContext appContext: Context): AppDatabase{
        return Room.databaseBuilder(appContext, AppDatabase::class.java, ROOM_DATABASE)
            .build()
    }


}

@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    abstract fun provideRoomRepository(roomRepositoryImpl: RoomRepositoryImpl): RoomRepository

}

@Database(entities = [Note::class], version = 1)
abstract class AppDatabase: RoomDatabase() {

    abstract fun noteDao(): NoteDao

}

@Dao
interface NoteDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertNote(note: Note): Long

    @Query("SELECT * FROM note WHERE id = :noteId")
    suspend fun selectNoteById(noteId: Long): Note?

    @Query("SELECT * FROM note")
    fun selectAllNotes(): Flow<List<Note>>

    @Update
    suspend fun updateNote(note: Note)

    @Delete
    suspend fun deleteNote(note: Note)
}
class RoomRepositoryImpl @Inject constructor(db: AppDatabase) : RoomRepository {

    private val noteDao = db.noteDao()

    override suspend fun createNote(): Long {
        return noteDao.insertNote(Note())
    }

    override suspend fun getNoteById(noteId: Long): Note {
        return noteDao.selectNoteById(noteId) ?: noteDao.selectNoteById(createNote())!!
    }

    override fun getNotes(): Flow<List<Note>> {
        return noteDao.selectAllNotes()
    }

    override suspend fun changeNote(note: Note) {
        noteDao.updateNote(note)
    }

    override suspend fun deleteNote(note: Note) {
        noteDao.deleteNote(note)
    }


}

@Entity(tableName = "note")
data class Note(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val header: String = "",
    val desc: String = ""
)

interface RoomRepository {

    suspend fun createNote(): Long

    suspend fun getNoteById(noteId: Long): Note

    fun getNotes(): Flow<List<Note>>

    suspend fun changeNote(note: Note)
    suspend fun deleteNote(note: Note)
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

    object Note: Destinations(Routes.Note){

        fun openNote(id: Long): String{
            return route.replace(Routes.ROUTE_NOTE_ID, id.toString())
        }

    }

}

object Routes {

    const val MAIN = "main"


    const val NOTE_ID = "id"
    const val ROUTE_NOTE_ID = "{$NOTE_ID}"
    const val Note = "note/$ROUTE_NOTE_ID"

}

@Composable
fun AppNavigation() {
    val navController = rememberNavController()

    Surface(
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColorPrimary)
    ) {
        NavHost(
            navController = navController,
            startDestination = Destinations.Main.route
        ) {
            composable(Destinations.Main.route) {
                MainDest(navController = navController)
            }
            composable(
                Destinations.Note.route,
                arguments = listOf(navArgument(Routes.NOTE_ID) { type = NavType.LongType })
            ) {
                NoteDest(navController = navController)
            }
        }
    }
}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NoteField(
    modifier: Modifier = Modifier,
    value: String,
    onValueChange: (String) -> Unit,
    textStyle: TextStyle,
    contentPadding: PaddingValues
) {
    val interactionSource = remember { MutableInteractionSource() }
    BasicTextField(
        modifier = modifier,
        value = value,
        onValueChange = onValueChange,
        interactionSource = interactionSource,
        textStyle = textStyle,
        cursorBrush = SolidColor(textColorPrimary),
    ) { innerTextField ->
        TextFieldDefaults.DecorationBox(
            value = value,
            innerTextField = innerTextField,
            enabled = true,
            singleLine = false,
            visualTransformation = VisualTransformation.None,
            interactionSource = interactionSource,
            colors = TextFieldDefaults.colors(
                unfocusedTextColor = textColorPrimary,
                focusedTextColor = textColorPrimary,
                cursorColor = textColorPrimary,
                unfocusedContainerColor = backColorSecondary,
                focusedContainerColor = backColorSecondary,
                unfocusedIndicatorColor = backColorSecondary,
                focusedIndicatorColor = backColorSecondary
            ),
            shape = RectangleShape,
            contentPadding = contentPadding
        )
    }

}
@Composable
fun NoteContent(
    modifier: Modifier = Modifier,
    viewModel: NoteViewModel,
    viewState: NoteState
) {
    Column(modifier = modifier) {
        val note = viewState.note
        val fieldModifier = Modifier
            .fillMaxWidth()
        fun Modifier.border() = border(width = 1.dp, color = textColorPrimary)
        NoteField(
            modifier = fieldModifier.border(),
            value = note.header,
            onValueChange = { headerText ->
                viewModel.changeHeader(headerText)
            },
            textStyle = noteHeader.copy(textAlign = TextAlign.Center, color = textColorPrimary),
            contentPadding = PaddingValues(14.dp)
        )
        NoteField(
            modifier = fieldModifier.weight(1f).border(),
            value = note.desc,
            onValueChange = { descText ->
                viewModel.changeDesc(descText)
            },
            textStyle = noteDesc.copy(color = textColorPrimary),
            contentPadding = PaddingValues(10.dp)
        )
    }
}
data class NoteState(
    val note: Note = Note(-1L,"", "")
)
sealed interface NoteEffect {

}
@HiltViewModel
class NoteViewModel @Inject constructor(
    private val roomRepository: RoomRepository,
    savedStateHandle: SavedStateHandle
) : BaseViewModel<NoteState, NoteEffect>(NoteState()) {

    init {
        savedStateHandle.get<Long>(Routes.NOTE_ID)?.let { noteId ->
            getNoteById(noteId)
        }
    }

    private fun getNoteById(noteId: Long) = viewModelScope.launch {
        val note = roomRepository.getNoteById(noteId)
        updateState {
            copy(
                note = note
            )
        }
    }

    fun changeDesc(descText: String) = viewModelScope.launch {
        updateState {
            copy(
                note = note.copy(
                    desc = descText
                )
            )
        }
    }

    fun changeNote() = viewModelScope.launch {
        roomRepository.changeNote(state.note)
    }

    fun changeHeader(headerText: String) = viewModelScope.launch {
        updateState {
            copy(
                note = note.copy(
                    header = headerText
                )
            )
        }
    }

}
@Composable
fun NoteScreen(viewModel: NoteViewModel, viewState: NoteState) {
    Scaffold(
        containerColor = backColorSecondary
    ) { paddingValues ->
        NoteContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(vertical = 20.dp, horizontal = 12.dp),
            viewModel = viewModel,
            viewState = viewState
        )
    }
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                else -> {}
            }
        }
    }
    val systemUiController = rememberSystemUiController()
    SideEffect {
        systemUiController.setSystemBarsColor(
            color = backColorSecondary,
            darkIcons = false
        )
    }
    DisposableEffect(viewState.note) {
        onDispose {
            viewModel.changeNote()
        }
    }
}
@Composable
fun NoteDest(navController: NavController) {
    val viewModel = hiltViewModel<NoteViewModel>()
    val viewState = viewModel.viewState.collectAsState().value
    NoteScreen(viewModel = viewModel, viewState = viewState)
}
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun NotesLazyColumn(
    modifier: Modifier = Modifier,
    notes: List<Note>,
    onNoteClick: (Note) -> Unit,
    onDeleteNote: (Note) -> Unit
) {
    LazyColumn(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(vertical = 20.dp, horizontal = 12.dp)
    ) {
        items(notes, key = { note -> note.id }) { note ->
            NoteCard(
                note = note,
                modifier = Modifier
                    .fillMaxWidth()
                    .background(color = primaryColor, shape = RoundedCornerShape(8.dp))
                    .clickable {
                        onNoteClick(note)
                    }
                    .animateItemPlacement()
                    .padding(horizontal = 20.dp, vertical = 10.dp),
                onDelete = {
                    onDeleteNote(note)
                }
            )
        }
    }
}
@Composable
fun NoteCard(
    modifier: Modifier = Modifier,
    note: Note,
    onDelete: () -> Unit
) {
    Row(modifier = modifier, verticalAlignment = Alignment.CenterVertically) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = with(note) { if (header == "") stringResource(R.string.empty_note) else header },
                style = mainHeader,
                color = textColorPrimary,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
            Spacer(modifier = Modifier.height(2.dp))
            Text(
                text = note.desc, style = mainDesc,
                color = textColorPrimary,
                maxLines = 1, overflow = TextOverflow.Ellipsis
            )
        }
        Spacer(modifier = Modifier.height(4.dp))
        Icon(
            modifier = Modifier
                .size(36.dp)
                .clickable {
                    onDelete()
                },
            imageVector = Icons.Default.Delete, contentDescription = null,
            tint = backColorSecondary
        )
        Spacer(modifier = Modifier.height(4.dp))
    }
}
@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    NotesLazyColumn(
        notes = viewState.notes,
        modifier = modifier,
        onNoteClick = { note ->
            viewModel.sendEffect(MainEffect.NavigateToNote(note.id))
        },
        onDeleteNote = { note ->
            viewModel.deleteNote(note)
        }
    )
}

data class MainState(
    val notes: List<Note> = emptyList()
)
sealed interface MainEffect {

    class NavigateToNote(val id: Long): MainEffect

}

@HiltViewModel
class MainViewModel @Inject constructor(private val roomRepository: RoomRepository) :
    BaseViewModel<MainState, MainEffect>(MainState()) {

    init {
        loadNotes()
    }

    fun createNote() = viewModelScope.launch {
        sendEffect(MainEffect.NavigateToNote(roomRepository.createNote()))
    }

    private fun loadNotes() = viewModelScope.launch {
        roomRepository.getNotes().collect { notes ->
            updateState {
                copy(
                    notes = notes
                )
            }
        }

    }

    fun deleteNote(note: Note) = viewModelScope.launch {
        roomRepository.deleteNote(note)
    }


}
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState, onNoteNavigate: (Long) -> Unit) {
    Scaffold(
        containerColor = backColorPrimary,
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    viewModel.createNote()
                },
                containerColor = backColorSecondary,
                contentColor = textColorPrimary
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = null,
                    modifier = Modifier.size(40.dp)
                )
            }
        }
    ) { paddingValues ->
        MainContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize(),
            viewModel = viewModel,
            viewState = viewState
        )
    }
    LaunchedEffect(Unit) {
        viewModel.effects.collect { effect ->
            when (effect) {
                is MainEffect.NavigateToNote -> {
                    onNoteNavigate(effect.id)
                }
            }
        }
    }
    val systemUiController = rememberSystemUiController()
    SideEffect {
        systemUiController.setSystemBarsColor(
            color = backColorPrimary,
            darkIcons = false
        )
    }
}
@Composable
fun MainDest(navController: NavController) {
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(viewModel = mainViewModel, viewState = viewState) { id ->
        navController.navigate(Destinations.Note.openNote(id))
    }
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
            stringsData: .init(additional: """
    <string name="empty_note">Empty</string>
"""),
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
