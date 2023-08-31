//
//  File.swift
//  
//
//  Created by admin on 08.08.2023.
//

import Foundation

struct EGWaterTracker: FileProviderProtocol {
    static var fileName: String = "EGWaterTracker.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.annotation.SuppressLint
import android.content.Context
import android.content.SharedPreferences
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid
import androidx.compose.foundation.lazy.staggeredgrid.StaggeredGridCells
import androidx.compose.foundation.lazy.staggeredgrid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.ClickableText
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.Divider
import androidx.compose.material.FloatingActionButton
import androidx.compose.material.Icon
import androidx.compose.material.TextField
import androidx.compose.material.TextFieldDefaults
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Cancel
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Shapes
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.ExperimentalTextApi
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.drawText
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Entity
import androidx.room.Insert
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
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.math.cos
import kotlin.math.sin

//generate
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val errorColor = Color(0xFF\(uiSettings.errorColor ?? "FFFFFF"))
val onSurfaceColor = Color(0xFF\(uiSettings.onSurfaceColor ?? "FFFFFF"))

//const
val colorGray = Color(0xFF43474B)

val Shape = Shapes(
    small = RoundedCornerShape(10.dp),
    medium = RoundedCornerShape(16.dp),
    large = RoundedCornerShape(50.dp)
)

val Typography = Typography(
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = 20.sp,
        lineHeight = 20.sp,
        letterSpacing = 0.4.sp,
        color = textColorPrimary
    )
)

object Constants {
    const val SHARED_PREFERENCES_NAME = "GOAL"
    const val VALUE = "VALUE"
    const val DEFAULT_VALUE = 2000
}

interface PojoMapper<Entity, DomainModel> {

    fun mapFromEntity(entity: Entity): DomainModel

    fun mapToEntity(domainModel: DomainModel): Entity

}

data class DrinkModel(
    val id: Long,
    val name: String,
    val amount: Int,
    val time: String
)

interface DrinksDatabaseRepository {
    fun getAllDrinks(time: String): Flow<List<DrinkModel>>
    suspend fun insertDrink(drinkModel: DrinkModel)
}

class GetAllDrinksUseCase @Inject constructor(private val repository: DrinksDatabaseRepository) {
    operator fun invoke(time: String) = repository.getAllDrinks(time)
}

class InsertDrinkUseCase @Inject constructor(private val repository: DrinksDatabaseRepository) {
    suspend operator fun invoke(drinkModel: DrinkModel) = repository.insertDrink(drinkModel)
}

@Dao
interface DrinksDao {
    @Query("SELECT * FROM drinks WHERE time =:time")
    fun getAllDrinks(time: String): Flow<List<DrinkEntity>>

    @Insert
    suspend fun insertDrink(drink: DrinkEntity)
}

@Database(entities = [DrinkEntity::class], version = 1, exportSchema = false)
abstract class DrinksDatabase : RoomDatabase() {
    abstract fun drinksDao(): DrinksDao

    companion object {
        const val DATABASE_NAME: String = "DRINK_DB"
    }
}

@Entity(tableName = "drinks")
data class DrinkEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val name: String,
    val amount: Int,
    val time: String
)

class DrinkMapper
@Inject
constructor() : PojoMapper<DrinkEntity, DrinkModel> {

    override fun mapFromEntity(entity: DrinkEntity): DrinkModel {
        return DrinkModel(
            id = entity.id,
            name = entity.name,
            amount = entity.amount,
            time = entity.time
        )
    }

    override fun mapToEntity(domainModel: DrinkModel): DrinkEntity {
        return DrinkEntity(
            id = domainModel.id,
            name = domainModel.name,
            amount = domainModel.amount,
            time = domainModel.time
        )
    }
}

class DrinksRepositoryImpl @Inject constructor(
    private val drinksDao: DrinksDao,
    private val drinkMapper: DrinkMapper
) : DrinksDatabaseRepository {

    override fun getAllDrinks(time: String): Flow<List<DrinkModel>> {
        return drinksDao.getAllDrinks(time).map {
            it.map { drinkEntity ->
                drinkMapper.mapFromEntity(drinkEntity)
            }
        }
    }

    override suspend fun insertDrink(drinkModel: DrinkModel) =
        drinksDao.insertDrink(
            drinkMapper.mapToEntity(drinkModel)
        )
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Singleton
    @Provides
    fun provideSharedPreferences(
        @ApplicationContext context: Context
    ): SharedPreferences = context.getSharedPreferences(
        Constants.SHARED_PREFERENCES_NAME,
        Context.MODE_PRIVATE
    )

    @Provides
    @Singleton
    fun provideDatabase(
        @ApplicationContext context: Context
    ): DrinksDatabase =
        Room.databaseBuilder(
            context, DrinksDatabase::class.java,
            DrinksDatabase.DATABASE_NAME
        )
            .fallbackToDestructiveMigration()
            .build()


    @Provides
    @Singleton
    fun provideRepository(
        database: DrinksDatabase,
        drinkMapper: DrinkMapper,

        ): DrinksDatabaseRepository =
        DrinksRepositoryImpl(database.drinksDao(), drinkMapper)

}

@HiltViewModel
class MainViewModel @Inject constructor(
    private val getAllDrinksUseCase: GetAllDrinksUseCase,
    private val insertDrinkUseCase: InsertDrinkUseCase,
    private val sharedPrefs: SharedPreferences
) : ViewModel() {

    private val _drinks = MutableStateFlow<List<DrinkModel>>(listOf())
    val drinks = _drinks.asStateFlow()

    var _goal by mutableStateOf(sharedPrefs.getInt(Constants.VALUE, Constants.DEFAULT_VALUE))
        private set

    var progress by mutableStateOf(0f)
        private set

    private val df = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())

    @SuppressLint("SuspiciousIndentation")
    fun getAllDrinks() {
        val time = Calendar.getInstance().time
        getAllDrinksUseCase(df.format(time)).onEach {
            _drinks.value = it
            calculateProgress()
        }.launchIn(viewModelScope)
    }

    fun insertDrink(id: Long, name: String, amount: Int) {
        viewModelScope.launch {
            val time = Calendar.getInstance().time
            val drink = DrinkModel(
                id = id,
                name = name,
                amount = amount,
                time = df.format(time)
            )
            insertDrinkUseCase.invoke(drink)
        }
    }

    fun changeGoal(goal: Int) {
        _goal = goal
        sharedPrefs.edit().putInt(Constants.VALUE, goal).apply()
    }

    private fun calculateProgress() {
        var amount = 0
        drinks.value.forEach {
            amount += it.amount
        }
        progress = amount / _goal.toFloat()

    }

}

@Composable
fun EGWaterTracker() {
    val showDialogDrink = remember { mutableStateOf(false) }
    if (showDialogDrink.value) {
        CustomDialogDrink(value = "", setShowDialog = {
            showDialogDrink.value = it
        })
    }
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .padding(top = 20.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        MainContent()
    }
    Box(modifier = Modifier.fillMaxSize()) {
        FloatingActionButton(
            modifier = Modifier
                .padding(all = 20.dp)
                .align(alignment = Alignment.BottomEnd),
            backgroundColor = buttonColorSecondary,
            onClick = {
                showDialogDrink.value = true
            }
        ) {
            Icon(
                imageVector = Icons.Filled.Add,
                contentDescription = "Add",
                tint = textColorPrimary
            )
        }
    }
}

@OptIn(ExperimentalTextApi::class)
@Composable
fun CustomProgressBar(progress: Float) {
    val textMeasurer = rememberTextMeasurer()
    val context = LocalContext.current

    Canvas(modifier = Modifier
        .padding(vertical = 30.dp, horizontal = 40.dp)
        .fillMaxWidth()
        .aspectRatio(1f), onDraw = {
        drawArc(
            color = onSurfaceColor,
            startAngle = 140f,
            sweepAngle = 260f,
            useCenter = false,
            style = Stroke(30.dp.toPx(), cap = StrokeCap.Round),
            size = Size(size.width, size.height)
        )
        drawArc(
            color = primaryColor,
            startAngle = 140f,
            sweepAngle = progress * 260f,
            useCenter = false,
            style = Stroke(30.dp.toPx(), cap = StrokeCap.Round),
            size = Size(size.width, size.height)
        )
        val angleInDegrees = (progress * 260.0) + 50.0
        val radius = (size.height / 2)
        val x = -(radius * sin(Math.toRadians(angleInDegrees))).toFloat() + (size.width / 2)
        val y = (radius * cos(Math.toRadians(angleInDegrees))).toFloat() + (size.height / 2)
        drawText(
            textMeasurer = textMeasurer,
            text = context.getString(R.string.progress, (progress * 100).toInt()),
            style = TextStyle(
                fontSize = 40.sp,
                color = textColorSecondary,
            ),
            topLeft = Offset(size.width / 2 - 80, size.height / 2 - 80)
        )
        drawCircle(
            color = textColorSecondary,
            radius = 10f,
            center = Offset(x, y)
        )
    })

}

@Composable
fun CustomDialogDrink(
    value: String,
    setShowDialog: (Boolean) -> Unit,
    viewModel: MainViewModel = hiltViewModel()
) {

    val txtFieldError = remember { mutableStateOf("") }
    val txtFieldName = remember { mutableStateOf(value) }
    val txtFieldAmount = remember { mutableStateOf(value) }
    val context = LocalContext.current
    Dialog(onDismissRequest = { setShowDialog(false) }) {
        Surface(
            shape = Shape.medium,
            color = surfaceColor
        ) {
            Box(
                contentAlignment = Alignment.Center
            ) {
                Column(modifier = Modifier.padding(20.dp)) {

                    ContentDialog(stringResource(R.string.add_new_drink), setShowDialog)
                    InputRaw(
                        label = stringResource(R.string.name),
                        txtFieldError = txtFieldError.value,
                        txtField = txtFieldName.value,
                        inputType = KeyboardType.Text,
                        onValueChange = {
                            txtFieldName.value = it
                        })

                    InputRaw(
                        label = stringResource(R.string.amount_),
                        txtFieldError = txtFieldError.value,
                        txtField = txtFieldAmount.value,
                        inputType = KeyboardType.Number,
                        onValueChange = {
                            txtFieldAmount.value = it
                        })

                    Button(
                        onClick = {

                            if (txtFieldName.value.isEmpty() or txtFieldAmount.value.isEmpty()) {
                                txtFieldError.value = context.getString(R.string.dialog_error)
                                return@Button
                            }

                            viewModel.insertDrink(
                                id = 0,
                                name = txtFieldName.value,
                                amount = txtFieldAmount.value.toInt()
                            )
                            setShowDialog(false)
                        },
                        shape = Shape.large,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(50.dp)
                            .padding(horizontal = 40.dp),

                        colors = ButtonDefaults.buttonColors(containerColor = primaryColor)
                    ) {
                        Text(text = stringResource(R.string.btn_done))
                    }
                }
            }
        }
    }
}

@Composable
fun CustomDialogGoal(
    value: String,
    setShowDialog: (Boolean) -> Unit,
    viewModel: MainViewModel = hiltViewModel()
) {

    val txtFieldError = remember { mutableStateOf("") }
    val txtFieldGoal = remember { mutableStateOf(value) }
    val context = LocalContext.current

    Dialog(onDismissRequest = { setShowDialog(false) }) {
        Surface(
            shape = Shape.medium,
            color = surfaceColor
        ) {
            Box(
                contentAlignment = Alignment.Center
            ) {
                Column(modifier = Modifier.padding(20.dp)) {

                    ContentDialog(stringResource(R.string.set_new_goal), setShowDialog)
                    InputRaw(
                        label = stringResource(R.string.value),
                        txtFieldError = txtFieldError.value,
                        txtField = txtFieldGoal.value,
                        inputType = KeyboardType.Number,
                        onValueChange = {
                            txtFieldGoal.value = it
                        })

                    Button(
                        onClick = {
                            if (txtFieldGoal.value.isEmpty()) {
                                txtFieldError.value = context.getString(R.string.dialog_error)
                                return@Button
                            }

                            viewModel.changeGoal(txtFieldGoal.value.toInt())
                            setShowDialog(false)
                        },
                        shape = Shape.large,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(50.dp)
                            .padding(horizontal = 40.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = primaryColor)

                    ) {
                        Text(text = stringResource(R.string.btn_done))
                    }
                }
            }
        }
    }
}

@Composable
fun ContentDialog(label: String, setShowDialog: (Boolean) -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = label,
            style = Typography.displayLarge
        )
        Icon(
            imageVector = Icons.Filled.Cancel,
            contentDescription = "",
            tint = colorGray,
            modifier = Modifier
                .width(30.dp)
                .height(30.dp)
                .clickable { setShowDialog(false) }
        )
    }
}

@Composable
fun InputRaw(
    label: String,
    txtFieldError: String,
    txtField: String,
    inputType: KeyboardType,
    onValueChange: (String) -> Unit
) {
    TextField(
        modifier =
        Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp)
            .border(
                BorderStroke(
                    width = 2.dp,
                    color = if (txtFieldError.isEmpty()) buttonColorSecondary else errorColor
                ),
                shape = Shape.large
            ),
        colors = TextFieldDefaults.textFieldColors(
            textColor = textColorPrimary,
            backgroundColor = surfaceColor,
            focusedIndicatorColor = surfaceColor,
            unfocusedIndicatorColor = surfaceColor
        ),
        placeholder = { Text(text = label) },
        value = txtField,
        keyboardOptions = KeyboardOptions(keyboardType = inputType),
        onValueChange = onValueChange
    )
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun MainContent(viewModel: MainViewModel = hiltViewModel()) {
    LaunchedEffect(key1 = Unit) {
        viewModel.getAllDrinks()
    }
    val consumedDrinks = viewModel.drinks.collectAsState().value
    val goal = viewModel._goal
    val progress = viewModel.progress

    val showDialogGoal = remember { mutableStateOf(false) }
    if (showDialogGoal.value)
        CustomDialogGoal(value = "", setShowDialog = {
            showDialogGoal.value = it
        })

    ClickableText(
        text = AnnotatedString(stringResource(id = R.string.current_goal, goal)),
        style = Typography.displayLarge,
        onClick = { showDialogGoal.value = true }
    )

    CustomProgressBar(progress = progress)

    Text(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp),
        text = stringResource(R.string.label_list),
        style = Typography.displayLarge,
        color = textColorPrimary
    )

    Divider(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 5.dp, horizontal = 20.dp)
            .width(5.dp),
        color = onSurfaceColor
    )

    LazyVerticalStaggeredGrid(
        columns = StaggeredGridCells.Adaptive(100.dp),
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(10.dp),
        horizontalArrangement = Arrangement.spacedBy(5.dp),
    ) {
        items(consumedDrinks) { item ->
            DrinkItem(drink = item)

        }
    }

}


@Composable
fun DrinkItem(drink: DrinkModel) {
    Card(
        modifier = Modifier.padding(vertical = 5.dp),
        shape = Shape.small,
        colors = CardDefaults.cardColors(onSurfaceColor),
        elevation = CardDefaults.cardElevation()
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(10.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = drink.name,
                style = Typography.displayLarge,
                color = textColorPrimary
            )
            Divider(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 20.dp, horizontal = 2.dp)
                    .width(1.dp),
                color = textColorPrimary
            )
            Text(
                text = stringResource(id = R.string.amount, drink.amount),
                style = Typography.displayLarge,
                color = textColorPrimary
            )
        }
    }
}


"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    EGWaterTracker()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
            <string name="btn_done">Done</string>
            <string name="dialog_error">Field can not be empty</string>
            <string name="current_goal">Your goal: %1$d ml</string>
            <string name="label_list">Your drinks today</string>
            <string name="progress">%1$d%%</string>
            <string name="amount">%1$d ml</string>
            <string name="add_new_drink">Add new drink</string>
            <string name="name">Name</string>
            <string name="amount_">Amount</string>
            <string name="set_new_goal">Set new goal</string>
            <string name="value">Value</string>
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
            signingConfig signingConfigs.debug
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
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
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
