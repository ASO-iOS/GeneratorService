//
//  File.swift
//  
//
//  Created by admin on 06.06.2023.
//

import Foundation

struct VSTorch: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
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
            buildGradleData: ANDBuildGradle(
                obfuscation: true,
                dependencies: """
            implementation Dependencies.room_runtime
            kapt Dependencies.room_compiler
            implementation Dependencies.room_ktx
        """
            )
        )
    }
    
    static let fileName = "VSTorch.kt"
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
