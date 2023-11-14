//
//  File.swift
//  
//
//  Created by admin on 11/10/23.
//

import Foundation

struct KDTodo: FileProviderProtocol {
    
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import android.content.Context
import android.util.Log
import androidx.annotation.StringRes
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Entity
import androidx.room.Insert
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
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))

val header = TextStyle(
    fontSize = 34.sp,
    fontWeight = FontWeight.ExtraBold,
)

val newTaskHeader = TextStyle(
    fontSize = 28.sp,
    fontWeight = FontWeight.Bold,
)

val newTaskButton = TextStyle(
    fontSize = 24.sp,
    fontWeight = FontWeight.Bold,
)

val taskStyle = TextStyle(
    fontSize = 20.sp,
    fontWeight = FontWeight.Medium,
)

val snackbar = TextStyle(
    fontSize = 16.sp,
    fontWeight = FontWeight.Light,
)

val headline6 = TextStyle(

)

val miniShape = RoundedCornerShape(10.dp)
val defaultShape = RoundedCornerShape(20.dp)

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

fun Any?.logDebug(prefix: String = "", postfix: String = "") {
    if (this is Throwable?) {
        Log.e(DEBUG, toString())
    } else {
        Log.i(DEBUG, toString())
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

sealed interface UIState{

    object Success: UIState
    object Error: UIState
    object Empty: UIState
    object Loading: UIState
    object None: UIState

}

@Module
@InstallIn(SingletonComponent::class)
object RoomModule {
    private const val ROOM_DATABASE = "room-database-v1"

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
interface RoomRepository {

    suspend fun addTask(task: Task): Result<Unit>

    suspend fun getTasks(): Result<List<Task>>

    suspend fun deleteTask(task: Task): Result<Unit>

    suspend fun updateTask(task: Task): Result<Unit>

}


@Database(entities = [Task::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun taskDao(): TaskDao

}
@Entity(tableName = "task")
data class Task(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val text: String,
    val completed: Boolean
)


@Dao
interface TaskDao {

    @Insert
    suspend fun insertTasks(vararg tasks: Task)

    @Update
    suspend fun updateTask(vararg tasks: Task)

    @Delete
    suspend fun deleteTask(vararg tasks: Task)

    @Query("SELECT * FROM task")
    suspend fun getAll(): List<Task>


}
class RoomRepositoryImpl @Inject constructor(db: AppDatabase) : RoomRepository {

    private val taskDao = db.taskDao()
    override suspend fun addTask(task: Task): Result<Unit> = runCatching {
        taskDao.insertTasks(task)
    }

    override suspend fun getTasks(): Result<List<Task>> = runCatching {
        taskDao.getAll()
    }

    override suspend fun deleteTask(task: Task): Result<Unit> = runCatching {
        taskDao.deleteTask(task)
    }

    override suspend fun updateTask(task: Task): Result<Unit> = runCatching {
        taskDao.updateTask(task)
    }


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

}

object Routes {

    const val MAIN = "main"

}

@Composable
fun AppNavigation() {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()

    NavHost(
        modifier = Modifier.fillMaxSize().background(color = backColorPrimary),
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
fun MainContent(
    modifier: Modifier = Modifier,
    viewModel: MainViewModel,
    viewState: MainState
) {
    TasksLazyColumn(
        completedTasks = viewState.completedTasks,
        noCompletedTasks = viewState.noCompletedTasks,
        modifier = modifier,
        viewModel = viewModel
    )

}
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NewTaskDialog(
    modifier: Modifier = Modifier,
    onDismiss: () -> Unit,
    newTaskText: String,
    onNewTaskChange: (String) -> Unit,
    onCreate: () -> Unit
) {
    AlertDialog(
        onDismissRequest = {
            onDismiss()
        },
        modifier = modifier
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Text(
                text = stringResource(R.string.new_task),
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                color = textColorSecondary,
                style = newTaskHeader
            )
            OutlinedTextField(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth(0.8f),
                value = newTaskText,
                onValueChange = onNewTaskChange,
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = textColorSecondary,
                    unfocusedBorderColor = textColorSecondary,
                    focusedTextColor = textColorSecondary,
                    unfocusedTextColor = textColorSecondary,
                    cursorColor = textColorSecondary,
                    focusedContainerColor = backColorPrimary,
                    unfocusedContainerColor = backColorPrimary
                ),
                shape = defaultShape,
                textStyle = taskStyle,
            )
            FilledTonalButton(
                modifier = Modifier.fillMaxWidth(0.75f),
                onClick = {
                    onCreate()
                },
                shape = defaultShape,
                colors = ButtonDefaults.filledTonalButtonColors(
                    containerColor = backColorPrimary,
                    disabledContainerColor = backColorPrimary,
                    contentColor = textColorSecondary,
                    disabledContentColor = textColorSecondary
                ),
                contentPadding = PaddingValues(
                    vertical = 12.dp, horizontal = 10.dp
                )
            ) {
                Text(
                    text = stringResource(R.string.create_task),
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    style = newTaskButton
                )
            }
        }
    }
}
@Composable
fun TaskCard(
    modifier: Modifier = Modifier, task: Task,
    onDeleteTask: (Task) -> Unit,
    onCompleteTask: (Task) -> Unit
) {
    Row(modifier = modifier, verticalAlignment = Alignment.CenterVertically) {
        val completeIcon = if (task.completed) Icons.Default.Check else Icons.Default.Close
        IconButton(
            onClick = {
                onCompleteTask(task)
            }, modifier = Modifier
                .padding(10.dp)
                .background(color = backColorPrimary, shape = CircleShape)
        ) {
            Icon(
                imageVector = completeIcon,
                contentDescription = null,
                tint = textColorPrimary,
                modifier = Modifier.size(30.dp)
            )
        }
        Text(
            modifier = Modifier
                .weight(1f)
                .padding(horizontal = 10.dp),
            text = task.text,
            overflow = TextOverflow.Ellipsis,
            color = textColorPrimary,
            style = taskStyle,
            textAlign = TextAlign.Start
        )
        IconButton(
            onClick = {
                onDeleteTask(task)
            },
            modifier = Modifier
                .padding(10.dp)
                .background(color = backColorPrimary, shape = CircleShape)
        ) {
            Icon(
                imageVector = Icons.Default.Delete,
                contentDescription = null,
                tint = textColorPrimary,
                modifier = Modifier.size(30.dp)
            )
        }
    }
}
@Composable
fun TasksLazyColumn(
    modifier: Modifier = Modifier,
    noCompletedTasks: List<Task>,
    completedTasks: List<Task>,
    viewModel: MainViewModel
) {
    val taskCardModifier =
        Modifier
            .fillMaxWidth()
            .background(shape = defaultShape, color = backColorSecondary)
            .padding(4.dp)
    LazyColumn(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(4.dp),
        contentPadding = PaddingValues(vertical = 20.dp, horizontal = 16.dp)
    ) {
        items(noCompletedTasks) { noCompletedTask ->
            TaskCard(
                task = noCompletedTask,
                modifier = taskCardModifier,
                onDeleteTask = { task: Task ->
                    viewModel.deleteTask(task)
                },
                onCompleteTask = { task: Task ->
                    viewModel.updateTask(task)
                }
            )
        }
        if (completedTasks.isNotEmpty()) {
            item {
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    modifier = Modifier.fillMaxWidth(),
                    text = stringResource(R.string.completed_tasks),
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    color = textColorSecondary,
                    style = newTaskButton.copy(fontSize = 22.sp),
                    textAlign = TextAlign.Start
                )
            }
            items(completedTasks) { completedTask ->
                TaskCard(
                    task = completedTask,
                    modifier = taskCardModifier,
                    onDeleteTask = { task: Task ->
                        viewModel.deleteTask(task)
                    },
                    onCompleteTask = { task: Task ->
                        viewModel.updateTask(task)
                    }
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppBar() {
    CenterAlignedTopAppBar(
        title = {
            Text(
                text = stringResource(id = R.string.app_name),
                maxLines = 1,
                overflow = TextOverflow.Visible,
                color = textColorPrimary,
                style = header
            )
        },
        colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
            containerColor = backColorPrimary
        )
    )
}
data class MainState(
    val openNewTask: Boolean = false,
    val newTaskText: String = "",
    @StringRes
    val snackbarMessageId: Int = 0,
    val noCompletedTasks: List<Task> = emptyList(),
    val completedTasks: List<Task> = emptyList()
)

sealed interface MainEffect{

    class Snackbar(val messageId: Int): MainEffect

}
@Composable
fun MainDest(navController: NavController){
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(
        viewModel = mainViewModel,
        viewState = viewState
    )
}
@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState) {
    val snackbarHostState = remember { SnackbarHostState() }
    Scaffold(
        containerColor = backColorPrimary,
        topBar = {
            AppBar()
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    viewModel.openNewTask()
                },
                containerColor = backColorSecondary,
                contentColor = backColorPrimary,
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = null,
                    modifier = Modifier.size(35.dp)
                )
            }
        },
        snackbarHost = {
            InfoSnackbar(
                state = snackbarHostState,
            )
        }
    ) { paddingValues ->
        if (viewState.openNewTask) {
            NewTaskDialog(
                modifier = Modifier
                    .fillMaxHeight(0.75f)
                    .fillMaxWidth()
                    .background(color = backColorSecondary, shape = defaultShape)
                    .padding(horizontal = 4.dp, vertical = 18.dp),
                onDismiss = {
                    viewModel.dismissNewTask()
                },
                newTaskText = viewState.newTaskText,
                onNewTaskChange = { text ->
                    viewModel.changeNewTaskText(text)
                },
                onCreate = {
                    viewModel.createTask()
                }
            )
        }
        MainContent(
            modifier = Modifier
                .padding(paddingValues)
                .fillMaxSize(),
            viewModel = viewModel,
            viewState = viewState
        )
    }
    val context = LocalContext.current
    LaunchedEffect(Unit) {
        viewModel.effect.collect { effect ->
            when (effect) {
                is MainEffect.Snackbar -> {
                    snackbarHostState.showSnackbar(
                        message = context.getString(effect.messageId)
                    )
                }
            }
        }
    }
}

@Composable
fun InfoSnackbar(
    state: SnackbarHostState,
) {
    SnackbarHost(
        hostState = state,
        modifier = Modifier
            .background(color = backColorSecondary, shape = defaultShape)

    ) { data ->
        Text(
            modifier = Modifier.padding(20.dp),
            text = data.visuals.message,
            color = textColorPrimary,
            maxLines = 2,
            overflow = TextOverflow.Ellipsis,
            style = snackbar
        )
    }
}

@HiltViewModel
class MainViewModel @Inject constructor(private val roomRepository: RoomRepository) :
    BaseViewModel<MainState>(MainState()) {

    private val _effects: Channel<MainEffect> =
        Channel(
            capacity = 5,
            onBufferOverflow = BufferOverflow.SUSPEND,
        )

    val effect = _effects.receiveAsFlow()


    private fun sendEffect(effect: MainEffect) = viewModelScope.launch {
        _effects.send(effect)
    }


    init {
        getTasks()
    }

    fun dismissNewTask() = viewModelScope.launch {
        updateState {
            copy(
                openNewTask = false
            )
        }
    }

    fun openNewTask() = viewModelScope.launch {
        updateState {
            copy(
                openNewTask = true
            )
        }
    }

    fun updateMessageId(messageId: Int){
        updateState {
            copy(
                snackbarMessageId = messageId
            )
        }
    }

    fun changeNewTaskText(text: String) = viewModelScope.launch {
        updateState {
            copy(
                newTaskText = text
            )
        }
    }

    fun createTask() = viewModelScope.launch(Dispatchers.IO) {
        if (stateValue.newTaskText.isNotEmpty()) {
            val task = Task(
                text = stateValue.newTaskText,
                completed = false
            )
            val call = suspend {
                roomRepository.addTask(
                    task
                )
            }
            call.loadAndHandleData(
                onLoading = {
                    updateState {
                        copy(
                            openNewTask = false,
                            newTaskText = ""
                        )
                    }
                },
                onSuccess = {
                    sendEffect(
                        MainEffect.Snackbar(
                            messageId = R.string.snackbar_success
                        )
                    )
                    getTasks()
                },
                onError = {
                    sendEffect(
                        MainEffect.Snackbar(R.string.snackbar_error)
                    )
                }
            )
        } else {
            sendEffect(
                MainEffect.Snackbar(R.string.snackbar_error)
            )
        }
    }

    private fun getTasks() = viewModelScope.launch(Dispatchers.IO) {
        val call = suspend {
            roomRepository.getTasks()
        }
        call.loadAndHandleData(
            onSuccess = { tasks ->
                updateState {
                    copy(
                        completedTasks = tasks.filter { it.completed },
                        noCompletedTasks = tasks.filter { !it.completed }
                    )
                }
            }
        )
    }

    fun deleteTask(task: Task) = viewModelScope.launch(Dispatchers.IO) {
        roomRepository.deleteTask(task)
        updateState {
            copy(
                completedTasks = completedTasks - task,
                noCompletedTasks = noCompletedTasks - task
            )
        }
    }

    fun updateTask(task: Task) = viewModelScope.launch(Dispatchers.IO) {
        roomRepository.updateTask(task.copy(completed = !task.completed))
        getTasks()
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: .init(imports: "", content: """
            AppNavigation()
"""),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: .init(additional: """
    <string name="new_task">Task</string>
    <string name="create_task">Create</string>
    <string name="snackbar_success">Task created</string>
    <string name="snackbar_error">Failed to create a task</string>
    <string name="snackbar_empty">Enter the text</string>
    <string name="completed_tasks">Completed tasks:</string>
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
