//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import Foundation

struct VSTorch: FileProviderProtocol {
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
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: """
import android.os.Build
import androidx.hilt.navigation.compose.hiltViewModel
""",
                content: """
            val torchViewModel =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) hiltViewModel<TorchViewModel31>() else hiltViewModel<TorchViewModelImpl>()
            TorchScreen(viewModel = torchViewModel)
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
    
    static var fileName = "\(NamesManager.shared.fileName).kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import androidx.annotation.DrawableRes
import androidx.annotation.RequiresApi
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.AlertDialog
import androidx.compose.material.Icon
import androidx.compose.material.IconButton
import androidx.compose.material.Slider
import androidx.compose.material.Text
import androidx.compose.material.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.core.content.getSystemService
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.annotation.Nullable
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.math.roundToInt
import \(packageName).R


val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))


@Composable
fun TorchScreen(viewModel: TorchViewModel) {
    val state = viewModel.state.collectAsState().value

    TorchNotWorkingDialog(viewModel = viewModel, state = state)
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceBetween,
        modifier = Modifier
            .fillMaxSize()
            .background(color = backColor)
    ) {
        Box(modifier = Modifier.weight(0.6f), contentAlignment = Alignment.Center) {
            OnButton(state is TorchState.On) {
                viewModel.handleUiEvent(TorchEvent.ClickConstant)
            }
        }

        Column(
            modifier = Modifier.weight(0.6f),
            verticalArrangement = Arrangement.SpaceEvenly,
        ) {
            TorchButton(if (state is TorchState.FlickerShort) TorchImage.TorchOnOne else TorchImage.TorchOffOne) {
                viewModel.handleUiEvent(TorchEvent.ClickFlicker)
            }
            TorchButton(if (state is TorchState.FlickerLong) TorchImage.TorchOnThree else TorchImage.TorchOffThree) {
                viewModel.handleUiEvent(TorchEvent.ClickLongFlicker)
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val maxSteps = (viewModel as TorchViewModel31).maxSteps.collectAsState().value

            TorchStrengthSlider(
                steps = maxSteps,
                modifier = Modifier
                    .weight(0.1f)
                    .padding(bottom = 24.dp),
                onSliderChange = {
                    viewModel.handleUiEvent(TorchEvent.ChangeStrengthLevel(newStrength = (maxSteps * it).roundToInt() + 1))
                }
            )
        } else {
            Spacer(modifier = Modifier.weight(0.1f))
        }
    }
}


@Composable
fun TorchNotWorkingDialog(viewModel: TorchViewModel, state: TorchState) {
    if (state !is TorchState.Inaccessible) return

    AlertDialog(
        onDismissRequest = { viewModel.handleUiEvent(TorchEvent.CloseDialog) },
        confirmButton = {
            TextButton(onClick = { viewModel.handleUiEvent(TorchEvent.CloseDialog) }) {
                Text(text = "OK")
            }
        },
        title = { Text(text = "Unable to use torch on your device") },
        text = { Text(text = "Unfortunately, our app is unable to use Torch functionaly on your device.") }
    )
}

@Composable
fun TorchButton(
    torchImage: TorchImage = TorchImage.TorchOnOne,
    onClickAction: () -> Unit = {}
) {
//    TorchTheme {
    IconButton(onClick = { onClickAction() }) {
        Image(
            painter = painterResource(id = torchImage.img),
            contentDescription = null,
            modifier = Modifier.size(142.dp)
        )
    }
//    Button(
//        colors = ButtonDefaults.buttonColors(
//            backgroundColor = Color.Transparent
//        ),
////        modifier = Modifier.clip(CircleShape),
////        border = BorderStroke(2.dp, outlineButtonBorderColor),
//        contentPadding = PaddingValues(0.dp),
//        onClick = { onClickAction() },
////                shape = CircleShape
//    ) {
//        Image(
//            painter = painterResource(id = torchImage.img),
//            contentDescription = null,
//            modifier = Modifier.size(142.dp)
//        )
//    }
//    }
}

@Composable
fun TorchStrengthSlider(steps: Int, onSliderChange: (Float) -> Unit, modifier: Modifier = Modifier) {
    var sliderPosition by remember { mutableStateOf(0f) }

    Slider(
        modifier = Modifier,
        value = sliderPosition,
        steps = steps,
        onValueChange = {
            sliderPosition = it
            onSliderChange(it)
        }
    )
}

@Composable
fun OnButton(isOn: Boolean = false, onClickAction: () -> Unit = {}) {
    IconButton(onClick = { onClickAction() }) {
        Icon(
            painter = painterResource(id = R.drawable.on_icon),
            contentDescription = null,
            tint = if (isOn) Color.Red else Color.White,
            modifier = Modifier.size(180.dp)
        )
    }
//    Button(
//        colors = ButtonDefaults.buttonColors(
//            backgroundColor = Color.Transparent,
//            contentColor = if (isOn) Color.Red else Color.White
//        ),
//        modifier = Modifier
//            .size(252.dp),
//
//        border = BorderStroke(2.dp, if (isOn) Color.Red else Color.White),
//        onClick = { onClickAction() },
//        shape = CircleShape
//    ) {
//        Icon(
//            painter = painterResource(id = R.drawable.on_icon),
//            contentDescription = null,
//        )
//    }
}


@Module
@InstallIn(SingletonComponent::class)
object TorchModule {

    @Provides
    @Nullable
    @Singleton
    fun provideCameraManager(@ApplicationContext context: Context): Camera? = context.getSystemService<CameraManager>()?.let { Camera(it) }
}

@Nullable
data class Camera(val manager: CameraManager)

abstract class TorchViewModel(protected val camera: Camera?) : ViewModel() {

    protected var cameraId = 0

    protected companion object {
        const val shortFlicker = 500L
        const val longFlicker = 1000L
    }

    protected var job: Job? = null

    abstract val state: StateFlow<TorchState>

    protected abstract fun changeConstantLight()
    protected abstract fun setFlickeringLight(delay: Long)
    protected abstract fun setLongFlickeringLight(delay: Long)
    protected abstract fun handleChangeStrength(newStrength: Int)
    protected abstract fun resetUiState()
    protected abstract fun changeToInaccessible()

    fun handleUiEvent(event: TorchEvent) {
        when (event) {
            is TorchEvent.ChangeStrengthLevel -> handleChangeStrength(event.newStrength)
            is TorchEvent.ClickConstant -> changeConstantLight()
            is TorchEvent.ClickFlicker -> setFlickeringLight(shortFlicker)
            is TorchEvent.ClickLongFlicker -> setLongFlickeringLight(longFlicker)
            is TorchEvent.WindowRefocused -> resetUiState()
            is TorchEvent.CloseDialog -> resetUiState()
        }
    }

    protected abstract fun changeTorchState(isOn: Boolean)
}

sealed class TorchImage(@DrawableRes val img: Int, val isOn: Boolean) {
    object TorchOnOne : TorchImage(R.drawable.torch_on_1, true)
    object TorchOnThree : TorchImage(R.drawable.torch_on_3, true)
    object TorchOffOne : TorchImage(R.drawable.torch_off_1, false)
    object TorchOffThree : TorchImage(R.drawable.torch_off_3, false)
}


sealed interface TorchEvent {

    class ChangeStrengthLevel(val newStrength: Int) : TorchEvent

    object ClickFlicker : TorchEvent

    object ClickLongFlicker : TorchEvent

    object ClickConstant : TorchEvent

    object WindowRefocused : TorchEvent

    object CloseDialog : TorchEvent
}

@RequiresApi(Build.VERSION_CODES.TIRAMISU)
@HiltViewModel
class TorchViewModel31 @Inject constructor(camera: Camera?) : TorchViewModel(camera) {

    private val maxSTR: Int = getMaxStr()

    private val _state = MutableStateFlow(TorchState31(maxSteps = maxSTR))
    override val state = _state.map { it.torch }.stateIn(viewModelScope,
        SharingStarted.Eagerly, TorchState.Init
    )
    val maxSteps = _state.map { it.maxSteps }.stateIn(viewModelScope, SharingStarted.Eagerly, maxSTR)

    override fun changeConstantLight() {
        job?.cancel()
        updateState { state ->
            state.copy(torch = if (state.torch is TorchState.On) TorchState.Init else TorchState.On)
        }
        changeTorchState(state.value is TorchState.On)
    }

    override fun setFlickeringLight(delay: Long) {
        job?.cancel()
        if (state.value is TorchState.FlickerShort) {
            resetUiState()
        } else {
            job = viewModelScope.launch(Dispatchers.IO) {
                updateState { it.copy(torch = TorchState.FlickerShort) }
                while (state.value == TorchState.FlickerShort) {
                    changeTorchState(true)
                    delay(delay)
                    changeTorchState(false)
                    delay(delay)
                }
            }
        }
    }

    override fun setLongFlickeringLight(delay: Long) {
        job?.cancel()
        if (state.value is TorchState.FlickerLong) {
            resetUiState()
        } else {
            job = viewModelScope.launch(Dispatchers.IO) {
                updateState { it.copy(torch = TorchState.FlickerLong) }
                while (state.value == TorchState.FlickerLong) {
                    changeTorchState(true)
                    delay(delay)
                    changeTorchState(false)
                    delay(delay)
                }
            }
        }
    }

    override fun resetUiState() {
        job?.cancel()
        changeTorchState(false)
        updateState { it.copy(torch = TorchState.Init) }
    }

    override fun handleChangeStrength(newStrength: Int) {
        updateState { it.copy(strength = newStrength) }
        if (state.value is TorchState.On) changeTorchState(true)
    }

    override fun changeToInaccessible() {
        _state.value = _state.value.copy(torch = TorchState.Inaccessible)
    }

    override fun changeTorchState(isOn: Boolean) {
        try {
            if (camera == null) {
                changeToInaccessible()
            } else {
                if (isOn) {
                    camera.manager.turnOnTorchWithStrengthLevel(cameraId.toString(), _state.value.strength)
                } else {
                    camera.manager.setTorchMode(cameraId.toString(), false)
                }
            }
        } catch (e: IllegalArgumentException) {
            changeToInaccessible()
        }
    }

    private inline fun updateState(change: (TorchState31) -> TorchState31) {
        _state.value = change(_state.value)
    }

    private fun getMaxStr(): Int {
        return try {
            if (camera == null) {
                changeToInaccessible()
                1
            } else {
                camera.manager
                    .getCameraCharacteristics(cameraId.toString())[CameraCharacteristics.FLASH_INFO_STRENGTH_MAXIMUM_LEVEL]?.minus(1) ?: 1
            }
        } catch (_: IllegalArgumentException) {
            changeToInaccessible()
            1
        }
    }
}

@HiltViewModel
class TorchViewModelImpl @Inject constructor(camera: Camera?) : TorchViewModel(camera) {

    private val _state = MutableStateFlow<TorchState>(TorchState.Init)
    override val state = _state.asStateFlow()

    override fun changeConstantLight() {
        job?.cancel()
        _state.value = if (state.value is TorchState.On) TorchState.Init else TorchState.On
        changeTorchState(state.value is TorchState.On)
    }

    override fun setFlickeringLight(delay: Long) {
        job?.cancel()
        if (_state.value is TorchState.FlickerShort) {
            resetUiState()
        } else {
            job = viewModelScope.launch(Dispatchers.IO) {
                _state.value = TorchState.FlickerShort
                while (_state.value == TorchState.FlickerShort) {
                    changeTorchState(true)
                    delay(delay)
                    changeTorchState(false)
                    delay(delay)
                }
            }
        }
    }

    override fun setLongFlickeringLight(delay: Long) {
        job?.cancel()
        if (_state.value is TorchState.FlickerLong) {
            resetUiState()
        } else {
            job = viewModelScope.launch(Dispatchers.IO) {
                _state.value = TorchState.FlickerLong
                while (_state.value == TorchState.FlickerLong) {
                    changeTorchState(true)
                    delay(delay)
                    changeTorchState(false)
                    delay(delay)
                }
            }
        }
    }

    override fun resetUiState() {
        job?.cancel()
        changeTorchState(false)
        _state.value = TorchState.Init
    }

    override fun handleChangeStrength(newStrength: Int) {}
    override fun changeToInaccessible() {
        _state.value = TorchState.Inaccessible
    }

    override fun changeTorchState(isOn: Boolean) {
        try {
            if (camera != null) camera.manager.setTorchMode(cameraId.toString(), isOn) else changeToInaccessible()
        } catch (e: IllegalArgumentException) {
            if (cameraId++ < 100) changeTorchState(isOn) else changeToInaccessible()
        }
    }
}

@RequiresApi(Build.VERSION_CODES.TIRAMISU)
data class TorchState31(
    val torch: TorchState = TorchState.Init,
    val strength: Int = 1,
    val maxSteps: Int
)

sealed interface TorchState {
    object Init : TorchState
    object On : TorchState
    object FlickerShort : TorchState
    object FlickerLong : TorchState
    object Inaccessible : TorchState
}


"""
    }
}
