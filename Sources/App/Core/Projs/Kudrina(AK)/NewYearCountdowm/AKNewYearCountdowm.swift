//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct AKNewYearCountdowm: FileProviderProtocol {
    static var fileName: String = "AKNewYearCountdowm.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.runtime.withFrameMillis
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Canvas
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.graphics.PaintingStyle
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import \(packageName).R
import \(packageName).presentation.fragments.main_fragment.ConfettiState.Companion.sizeChanged
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.isActive
import java.util.Calendar
import javax.inject.Inject
import kotlin.math.roundToInt

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))


val ConfetiiColor1 = Color(0xFFE4D01E)
val ConfetiiColor2 = Color(0xFF3CE41E)
val ConfetiiColor3 = Color(0xFFD01EE4)
val ConfetiiColor4 = Color(0xFF1E4FE4)
val ConfetiiColor5 = Color(0xFFE41E1E)


val MainFont = FontFamily(
    Font(R.font.main_font)
)

fun updateTime(viewModel: MainViewModel, context: Context) {

    // Current Date
    val currentDate = Calendar.getInstance()

    // New Year Date
    val eventDate = Calendar.getInstance()
    eventDate[Calendar.YEAR] = 2023
    eventDate[Calendar.MONTH] = 11 // 0-11 so 1 less
    eventDate[Calendar.DAY_OF_MONTH] = 31
    eventDate[Calendar.HOUR_OF_DAY] = 23
    eventDate[Calendar.MINUTE] = 59
    eventDate[Calendar.SECOND] = 59

    // Find how many milliseconds until the event
    val diff = eventDate.timeInMillis - currentDate.timeInMillis
    if (diff>0) {
        // Change the milliseconds to days, hours, minutes and seconds
        val days = diff / (24 * 60 * 60 * 1000)
        val hours = diff / (1000 * 60 * 60) % 24
        val minutes = diff / (1000 * 60) % 60
        val seconds = (diff / 1000) % 60

        viewModel.setDataForDisplay(context.getString(R.string.countdown, days.toString(), hours.toString(), minutes.toString(), seconds.toString()))
    } else {
        viewModel.setTimerDone(true)
    }

}

private val handler = Handler(Looper.getMainLooper())

fun timer(viewModel: MainViewModel, context: Context) {

    handler.post(object : Runnable {
        override fun run() {
            handler.postDelayed(this, 1000)
            updateTime(viewModel, context)
            if (viewModel.timerDone.value == true) {
                handler.removeCallbacks(this)
            }
        }

    })
}


@HiltViewModel
class MainViewModel @Inject constructor() : ViewModel(){

    private val _dataForDisplay = MutableLiveData("")
    val dataForDisplay: LiveData<String> get() = _dataForDisplay

    fun setDataForDisplay(dataForDisplayInput: String) {
        _dataForDisplay.value = dataForDisplayInput
    }


    private val _timerDone = MutableLiveData(false)
    val timerDone: LiveData<Boolean> get() = _timerDone

    fun setTimerDone(timerDoneInput: Boolean) {
        _timerDone.value = timerDoneInput
    }

}

fun Modifier.confetti(
    contentColors: List<Color> = listOf(ConfetiiColor1, ConfetiiColor2, ConfetiiColor3, ConfetiiColor4, ConfetiiColor5),
    confettiShape: ConfettiShape = ConfettiShape.Circle,
    speed: Float = 0.17f,
    populationFactor: Float = 0.1f,
    isVisible: Boolean = true
) = composed {
    var confettiState by remember {
        mutableStateOf(
            ConfettiState(
                confetti = emptyList(),
                speed = speed,
                colors = contentColors,
                confettiShape = confettiShape
            )
        )
    }

    var lastFrame by remember { mutableStateOf(-1L) }

    LaunchedEffect(isVisible) {
        while (isVisible && isActive) {
            withFrameMillis { newTick ->
                val elapsedMillis = newTick - lastFrame
                val wasFirstFrame = lastFrame < 0
                lastFrame = newTick
                if (wasFirstFrame) return@withFrameMillis

                for (confetto in confettiState.confetti) {
                    confettiState.next(elapsedMillis)
                }
            }
        }
    }

    onSizeChanged {
        confettiState = confettiState.sizeChanged(
            size = it,
            populationFactor = populationFactor
        )
    }.drawBehind {
        if (isVisible) {
            for (confetto in confettiState.confetti) {
                confetto.draw(drawContext.canvas)
            }
        }
    }
}

enum class ConfettiShape {
    Circle
}

data class ConfettiState(
    val confetti: List<Confetto> = emptyList(),
    val colors: List<Color>,
    val confettiShape: ConfettiShape,
    val size: IntSize = IntSize.Zero,
    val speed: Float
) {

    fun next(durationMillis: Long) {
        confetti.forEach {
            it.next(size, durationMillis, speed)
        }
    }

    companion object {
        fun ConfettiState.sizeChanged(
            size: IntSize,
            populationFactor: Float
        ): ConfettiState {
            if (size == this.size) return this
            return copy(
                confetti = (0..size.realPopulation(populationFactor)).map {
                    Confetto.create(size, colors, confettiShape)
                },
                size = size
            )
        }

        private fun IntSize.realPopulation(populationFactor: Float): Int {
            return (width * height / 10_000 * populationFactor).roundToInt()
        }
    }
}

class Confetto(
    vector: Offset,
    private val confettiColor: Color,
    private val radius: Float,
    private val shape: ConfettiShape = ConfettiShape.Circle,
    position: Offset
) {
    internal var position by mutableStateOf(position)
    private var vector by mutableStateOf(vector)
    private val paint: Paint = Paint().apply {
        isAntiAlias = true
        color = confettiColor
        style = PaintingStyle.Fill
    }

    fun next(
        borders: IntSize,
        durationMillis: Long,
        speedCoefficient: Float
    ) {
        val speed = vector * speedCoefficient
        val borderTop = 0
        val borderLeft = 0
        val borderBottom = borders.height
        val borderRight = borders.width

        position = Offset(
            x = position.x + (speed.x / 1000f * durationMillis),
            y = position.y + (speed.y / 1000f * durationMillis),
        )
        val vx = if (position.x < borderLeft || position.x > borderRight) -vector.x else vector.x
        val vy = if (position.y < borderTop || position.y > borderBottom) -vector.y else vector.y

        if (vx != vector.x || vy != vector.y) {
            vector = Offset(vx, vy)
        }
    }

    fun draw(canvas: Canvas) {

        when (shape) {
            ConfettiShape.Circle -> {
                canvas.drawCircle(
                    radius = radius,
                    center = position,
                    paint = paint
                )
            }
        }

    }

    companion object {

        fun create(borders: IntSize, colors: List<Color>, confettiShape: ConfettiShape): Confetto {
            return Confetto(
                position = Offset(
                    (0..borders.width).random().toFloat(),
                    (0..borders.height).random().toFloat()
                ),
                vector = Offset(
                    listOf(
                        -1f,
                        1f
                    ).random() * ((borders.width.toFloat() / 100f).toInt()..(borders.width.toFloat() / 10f).toInt()).random()
                        .toFloat(),
                    listOf(
                        -1f,
                        1f
                    ).random() * ((borders.height.toFloat() / 100f).toInt()..(borders.height.toFloat() / 10f).toInt()).random()
                        .toFloat()
                ),
                confettiColor = colors.random(),
                radius = (5..25).random().toFloat(),
                shape = ConfettiShape.Circle
            )
        }
    }
}

@Composable
fun CounterText(viewModel: MainViewModel = hiltViewModel()) {

    val dataForDisplay = rememberSaveable {
        mutableStateOf("")
    }

    viewModel.dataForDisplay.observe(LocalLifecycleOwner.current) {
        dataForDisplay.value = it
    }

    Text(
        modifier = Modifier
            .fillMaxWidth()
            .padding(start = 18.dp, end = 18.dp),
        text = dataForDisplay.value,
        fontSize = 32.sp,
        color = textColorSecondary,
        textAlign = TextAlign.Center,
        fontFamily = MainFont
    )
}

@Composable
fun MainText(text: String, color: Color) {
    Text(
        modifier = Modifier
            .fillMaxWidth()
            .padding(start = 18.dp, end = 18.dp),
        text = text,
        fontSize = 48.sp,
        color = color,
        textAlign = TextAlign.Center,
        fontFamily = MainFont
    )
}

@Composable
fun MainUI(viewModel: MainViewModel = hiltViewModel()) {


    timer(viewModel, LocalContext.current)

    val timerDone = rememberSaveable {
        mutableStateOf(false)
    }

    viewModel.timerDone.observe(LocalLifecycleOwner.current) {
        timerDone.value = it
    }


    if (!timerDone.value) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary),
            verticalArrangement = Arrangement.Center
        ) {
            CounterText()

            MainText(
                text = stringResource(id = R.string.until_new_year),
                color = textColorPrimary
            )
        }
    } else {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary)
                .confetti(),
            verticalArrangement = Arrangement.Center
        ) {
            MainText(
                text = stringResource(id = R.string.happy_new_year),
                color = textColorSecondary
            )
        }
    }


}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    MainUI()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="happy_new_year">Happy\nNew Year!</string>
    <string name="until_new_year">until\nNew Year</string>
    <string name="countdown">%1$sd %2$sh %3$sm %4$ss</string>
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
