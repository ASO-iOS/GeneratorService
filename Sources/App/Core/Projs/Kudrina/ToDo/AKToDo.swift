//
//  File.swift
//  
//
//  Created by admin on 11.08.2023.
//

import Foundation

struct AKToDo: FileProviderProtocol {
    static var fileName: String = "AKToDo.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CheckboxDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shadow
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.MutableLiveData
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
import androidx.room.Update
import com.todo.app.R
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFFFFDDB5)
val surfaceColor = Color(0xFFEAAC64)
val textColorPrimary = Color(0xFFFFFFFF)
val textColorSecondary = Color(0xFFFF8900)
val primaryColor = Color(0x66000000)
val onPrimaryColor = Color(0xFF747373)

val paddingPrimary = 20.dp

val textSizePrimary = 28.sp

fun String.timeIsCorrect(): Boolean {

    return when {
        this.length != 5  ->  false
        this[2] != ':'  ->  false
        this[0] !in '0'..'2'  ->  false
        this[1] !in '0'..'9'  ->  false
        this[3] !in '0'..'5'  ->  false
        this[4] !in '0'..'9'  ->  false
        this[0] == '2' && this[1] in '4'..'9' ->  false
        else -> true
    }

}

val randomTextList = listOf(
    R.string.random_text_1,
    R.string.random_text_2,
    R.string.random_text_3,
    R.string.random_text_4,
    R.string.random_text_5
)

fun getRandomGreeting(): Int {
    val randomNumber = (randomTextList.indices).random()
    return randomTextList[randomNumber]
}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val localRepository: LocalRepository
) : ViewModel() {

    val items = localRepository.getData()

    val greeting = MutableLiveData(getRandomGreeting())

    fun addItem(title: String, text: String, time: String, checked: Boolean = false) {
        viewModelScope.launch {
            localRepository.putData(
                Item(
                    title = title,
                    text = text,
                    time = time,
                    checked = checked
                )
            )
        }
    }

    fun removeItem(item: Item) {
        viewModelScope.launch {
            localRepository.deleteData(item)
        }
    }

    fun updateItem(item: Item) {
        viewModelScope.launch {
            localRepository.updateItem(item)
        }
    }

}

@Composable
fun MainUi(viewModel: MainViewModel = hiltViewModel()) {

    val listItems = viewModel.items.collectAsState(initial = listOf()).value

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
    ) {
        item {
            UIHeader(viewModel)
        }

        if (listItems.isNotEmpty()) {

            listItems.forEach { listItem ->
                item {
                    UIListCard(viewModel, listItem)
                }
            }

        } else {
            item {
                Text(
                    modifier = Modifier.fillMaxWidth(),
                    text = stringResource(id = R.string.no_data_text),
                    color = primaryColor,
                    fontSize = 16.sp,
                    textAlign = TextAlign.Center
                )
            }
        }
    }
}

@Composable
fun DialogInnerUi(titleText: MutableState<String>, mainTextText: MutableState<String>, timeText: MutableState<String>,) {

    Column(
        modifier = Modifier
            .fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(10.dp)

    ) {

        TextField(
            placeholder = {
                Text(
                    text = stringResource(id = R.string.hint_title),
                    color = primaryColor,
                    fontSize = 14.sp
                )
            },
            textStyle = TextStyle(
                fontSize = 18.sp,
                textDecoration = TextDecoration.None
            ),
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(10.dp)),
            value = titleText.value,
            singleLine = true,
            onValueChange = {
                titleText.value = it
            }
        )


        TextField(
            placeholder = {
                Text(
                    text = stringResource(id = R.string.hint_text),
                    color = primaryColor,
                    fontSize = 14.sp
                )
            },
            textStyle = TextStyle(
                fontSize = 18.sp,
                textDecoration = TextDecoration.None
            ),
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(10.dp)),
            value = mainTextText.value,
            singleLine = true,
            onValueChange = {
                mainTextText.value = it
            }
        )

        TextField(
            placeholder = {
                Text(
                    text = stringResource(id = R.string.hint_time),
                    color = primaryColor,
                    fontSize = 14.sp
                )
            },
            textStyle = TextStyle(
                fontSize = 18.sp,
                textDecoration = TextDecoration.None
            ),
            modifier = Modifier
                .clip(RoundedCornerShape(10.dp)),
            value = timeText.value,
            singleLine = true,
            onValueChange = {
                timeText.value = it
            }
        )


    }
}


@Composable
fun Dialog(
    dialogState: MutableState<Boolean>,
    onSubmit: (List<String>) -> Unit,
) {

    val titleText = rememberSaveable {
        mutableStateOf("")
    }

    val mainTextText = rememberSaveable {
        mutableStateOf("")
    }

    val timeText = rememberSaveable {
        mutableStateOf("")
    }


    AlertDialog(
        modifier = Modifier
            .clip(RoundedCornerShape(10.dp))
            .wrapContentHeight(),
        containerColor = Color.White,
        onDismissRequest = {
            dialogState.value = false
        },
        confirmButton = {
            val context = LocalContext.current
            TextButton(onClick = {

                if (titleText.value.isNotEmpty() && mainTextText.value.isNotEmpty()) {

                    if (timeText.value.isEmpty() || timeText.value.timeIsCorrect()) {
                        onSubmit(listOf(titleText.value, mainTextText.value, timeText.value))
                        dialogState.value = false
                    }

                } else {
                    if (timeText.value.isNotEmpty() && !timeText.value.timeIsCorrect()) {
                        Toast.makeText(context, R.string.time_input_error, Toast.LENGTH_SHORT)
                            .show()
                    } else {
                        Toast.makeText(context, R.string.text_input_error, Toast.LENGTH_SHORT)
                            .show()
                    }

                }

            }) {
                Text(
                    text = stringResource(id = R.string.ok_button),
                    color = textColorSecondary,
                    fontSize = 16.sp
                )
            }
        },
        dismissButton = {
            TextButton(onClick = {
                dialogState.value = false
            }) {
                Text(
                    text = stringResource(id = R.string.close_button),
                    color = textColorSecondary,
                    fontSize = 16.sp
                )
            }
        },
        title = {
            DialogInnerUi(titleText, mainTextText ,timeText)
        }
    )
}

@Composable
fun DeleteIcon() {
    Icon(
        modifier = Modifier
            .padding(5.dp)
            .size(28.dp),
        painter = painterResource(id = R.drawable.trash),
        contentDescription = stringResource(id = R.string.delete_button_desc),
        tint = Color.White
    )
}

@Composable
fun TitleAndTimeText(item: Item) {
    Box(
        modifier = Modifier
            .padding(end = 100.dp, bottom = 4.dp)
    ) {
        Text(
            modifier = Modifier.padding(end = 50.dp),
            text = item.title,
            fontSize = 20.sp,
            color = textColorPrimary,
            maxLines = 2,
            overflow = TextOverflow.Ellipsis
        )

        if (item.time.isNotEmpty()) {
            Text(
                modifier = Modifier
                    .border(
                        BorderStroke(1.dp, primaryColor),
                        RoundedCornerShape(15)
                    )
                    .padding(
                        start = 4.dp,
                        end = 4.dp,
                        top = 1.dp,
                        bottom = 1.dp
                    )
                    .align(Alignment.CenterEnd),
                text = item.time,
                fontSize = 12.sp,
                color = primaryColor
            )
        }
    }
}

@Composable
fun CardCheckBox(checkedState: MutableState<Boolean>, viewModel: MainViewModel, item:Item) {
    Checkbox(
        checked = checkedState.value,
        onCheckedChange = {
            checkedState.value = it
            viewModel.updateItem(Item(item.id, item.title, item.text, item.time, it))
        },
        modifier = Modifier.padding(5.dp),
        colors = CheckboxDefaults.colors(
            checkedColor = backColorPrimary,
            checkmarkColor = textColorSecondary,
            uncheckedColor = backColorPrimary
        )
    )
}

@Composable
fun UIHeader(viewModel: MainViewModel) {


    Box(
        modifier = Modifier
            .fillMaxWidth()
    ) {
        Image(
            modifier = Modifier.fillMaxWidth(),
            contentScale = ContentScale.Crop,
            painter = painterResource(id = R.drawable.main_img),
            contentDescription = stringResource(id = R.string.main_img_desc)
        )

        Text(
            modifier = Modifier.padding(paddingPrimary),
            text = stringResource(id = viewModel.greeting.value ?: 0),
            fontSize = textSizePrimary,
            color = textColorPrimary,
            style = TextStyle(
                shadow = Shadow(
                    color = onPrimaryColor,
                    offset = Offset(5f, 5f),
                    blurRadius = 5f
                )
            )
        )

        val openDialog = rememberSaveable {
            mutableStateOf(false)
        }

        if (openDialog.value) {
            Dialog(
                openDialog, onSubmit = {listOfElementsForCard ->
                    if (listOfElementsForCard.size>=3) {
                        viewModel.addItem(listOfElementsForCard[0].trim(), listOfElementsForCard[1].trim(), listOfElementsForCard[2].trim())
                    }
                }
            )
        }

        Image(
            modifier = Modifier
                .padding(10.dp)
                .size(36.dp)
                .align(Alignment.BottomEnd)
                .clickable {
                    openDialog.value = true
                },
            painter = painterResource(id = R.drawable.add_button),
            contentDescription = stringResource(id = R.string.add_button_desc)
        )
    }
}

@Composable
fun UIListCard(viewModel: MainViewModel, item: Item) {

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(start = paddingPrimary, end = paddingPrimary, top = 10.dp),
        colors = CardDefaults.cardColors(
            containerColor = surfaceColor,
        ),
        shape = RoundedCornerShape(16.dp),
        elevation = CardDefaults.cardElevation(
            defaultElevation = 10.dp
        )
    ) {
        val checkedState = rememberSaveable {
            mutableStateOf(
                item.checked
            )
        }
        Row(
            modifier = Modifier
                .fillMaxSize(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            CardCheckBox(checkedState, viewModel, item)

            Box(
                modifier = Modifier.fillMaxWidth()
            ) {


                Row(
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Column() {
                        Row(
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            TitleAndTimeText(item)
                        }

                        Text(
                            modifier = Modifier.padding(end = 42.dp, bottom = 4.dp),
                            text = item.text,
                            fontSize = 15.sp,
                            color = textColorPrimary,
                            maxLines = 2,
                            overflow = TextOverflow.Ellipsis
                        )
                    }
                }

                IconButton(
                    modifier = Modifier.align(Alignment.CenterEnd),
                    onClick = {
                        viewModel.removeItem(item)
                    }
                ) {
                    DeleteIcon()
                }
            }
        }

    }
}

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

    @Query("SELECT * FROM items")
    fun getAllItems(): Flow<List<Item>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertItemIntoDatabase(item: Item)

    @Delete
    suspend fun removeItemFromDatabase(item: Item)

    @Update
    suspend fun updateItem(item: Item)
}

@androidx.room.Database(entities = [Item::class], version = 1)
abstract class Database : RoomDatabase() {
    abstract fun dao(): Dao
}

@Entity(tableName = "items")
data class Item(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,

    val title: String,

    val text: String,

    val time: String,

    val checked: Boolean,
)

interface LocalRepository {

    fun getData(): Flow<List<Item>>

    suspend fun putData(item: Item)

    suspend fun deleteData(item: Item)

    suspend fun updateItem(item: Item)

}

class LocalRepositoryImpl @Inject constructor(
    private val database: Database
) : LocalRepository {

    override fun getData(): Flow<List<Item>> =
        database.dao().getAllItems()

    override suspend fun putData(item: Item) =
        database.dao().insertItemIntoDatabase(item)


    override suspend fun deleteData(item: Item) =
        database.dao().removeItemFromDatabase(item)

    override suspend fun updateItem(item: Item) =
        database.dao().updateItem(item)

}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    MainUi()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="random_text_1">Привет!</string>
    <string name="random_text_2">Хорошего дня!</string>
    <string name="random_text_3">Удачного дня!</string>
    <string name="random_text_4">У тебя все получится!</string>
    <string name="random_text_5">Продуктивного дня!</string>

    <string name="delete_button_desc">delete button</string>
    <string name="main_img_desc">main image</string>
    <string name="add_button_desc">add button</string>

    <string name="time_input_error">Неверно введено время</string>
    <string name="text_input_error">Поля с заголовком и текстом должны быть заполнены</string>

    <string name="ok_button">Ок</string>
    <string name="close_button">Закрыть</string>

    <string name="hint_title">Заголовок</string>
    <string name="hint_text">Текст</string>
    <string name="hint_time">10:00</string>

    <string name="no_data_text">Пока нет дел</string>
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

    kapt Dependencies.room_compiler
    implementation Dependencies.room_ktx
    implementation Dependencies.room_runtime
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
