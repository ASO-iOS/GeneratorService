//
//  File.swift
//  
//
//  Created by admin on 27.06.2023.
//

import Foundation

struct MBTorch: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBTorch()
        """
            ),
            mainActivityData: ANDMainActivity(
                imports: "",
                extraFunc: "",
                content: ""
            ),
            buildGradleData: ANDBuildGradle(
                obfuscation: true,
                dependencies: ""
            )
        )
    }
    
    static var fileName = "MBTorch.kt"
    
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject
import javax.inject.Singleton

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonColorSecondary = Color(0xFF\(uiSettings.buttonColorSecondary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

@Composable
fun MBTorch(appViewModel: AppViewModel = viewModel()) {
    val appCameraState = appViewModel.appCameraState.collectAsState()
    when (appCameraState.value.torchAvailable) {
        true -> TorchAvailableScreen()
        false -> TorchNotAvailableScreen()
    }
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideTorchHandler(
        @ApplicationContext context: Context
    ): TorchHandler = TorchHandler(context)

}

data class AppCameraState(
    val torchAvailable: Boolean = false,
    val cameraId: String? = null,
    val torchEnabled: Boolean = false
)

@Composable
fun TorchAvailableScreen(appViewModel: AppViewModel = viewModel()) {
    val appCamState = appViewModel.appCameraState.collectAsState()
    val torchEnabled = appCamState.value.torchEnabled
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        TorchButton(torchEnabled = torchEnabled)
    }
}

@Composable
fun TorchButton(torchEnabled: Boolean, appViewModel: AppViewModel = viewModel()) {
    Button(
        modifier = Modifier
            .fillMaxSize(0.65f)
            .aspectRatio(1f)
            .shadow(
                elevation = 8.dp,
                shape = RoundedCornerShape(100)
            ),
        onClick = {
            if (torchEnabled)
                appViewModel.turnOff()
            else
                appViewModel.turnOn()
        },
        shape = RoundedCornerShape(100),
        colors = ButtonDefaults.buttonColors(
            contentColor = buttonTextColorPrimary,
            containerColor = buttonColorPrimary
        ),
        border = BorderStroke(
            width = 8.dp,
            color = buttonColorSecondary
        ),
        elevation = ButtonDefaults.elevatedButtonElevation(
            defaultElevation = 8.dp,
            pressedElevation = 2.dp
        )
    ) {
        Text(
            text = if (torchEnabled)
                "Off"
            else
                "On",
            fontSize = 34.sp,
            fontWeight = FontWeight.Black
        )
    }
}

@Composable
fun TorchNotAvailableScreen() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = "Torch is not available on your device",
            color = buttonTextColorPrimary,
            fontSize = 40.sp,
            fontWeight = FontWeight.Black,
            textAlign = TextAlign.Center
        )
    }
}

class TorchHandler(context: Context) {

    private val camManager: CameraManager by lazy {
        context.getSystemService(CameraManager::class.java)
    }

    fun checkTorchAvailable(): AppCameraState {
        camManager.cameraIdList.forEach { camera ->
            val chars = camManager.getCameraCharacteristics(camera)
            if (chars.get(CameraCharacteristics.LENS_FACING) == CameraCharacteristics.LENS_FACING_BACK &&
                chars.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
            ) {
                return AppCameraState(true, camera)
            }
        }

        return AppCameraState(false)
    }

    fun turnTorchOn(cameraId: String?): Boolean {
        return if (cameraId != null) {
            camManager.setTorchMode(cameraId, true)
            true
        } else {
            false
        }
    }

    fun turnTorchOff(cameraId: String?): Boolean {
        if (cameraId != null) {
            camManager.setTorchMode(cameraId, false)
        }
        return false
    }

}

@HiltViewModel
class AppViewModel @Inject constructor(
    private val torchHandler: TorchHandler
) : ViewModel() {

    private val _appCameraState = MutableStateFlow(AppCameraState())
    val appCameraState = _appCameraState.asStateFlow()

    init {
        _appCameraState.value = torchHandler.checkTorchAvailable()
    }

    fun turnOn() {
        _appCameraState.value = _appCameraState.value.copy(
            torchEnabled = torchHandler.turnTorchOn(_appCameraState.value.cameraId)
        )
    }

    fun turnOff() {
        _appCameraState.value = _appCameraState.value.copy(
            torchEnabled = torchHandler.turnTorchOff(_appCameraState.value.cameraId)
        )
    }

}
"""
    }
    
}
