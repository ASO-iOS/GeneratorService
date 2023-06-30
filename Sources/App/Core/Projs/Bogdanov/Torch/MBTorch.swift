//
//  File.swift
//  
//
//  Created by admin on 27.06.2023.
//

import Foundation

struct MBTorch {
    static let fileName = "MBTorch.kt"
    
    static func fileContent(
        packageName: String,
        backColorPrimary: String,
        backColorSecondary: String,
        surfaceColor: String,
        onSurfaceColor: String,
        primaryColor: String,
        onPrimaryColor: String,
        errorColor: String,
        textColorPrimary: String,
        textColorSecondary: String
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
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
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

val backColorPrimary = Color(0xFF\(backColorPrimary))
val backColorSecondary = Color(0xFF\(backColorSecondary))
val surfaceColor = Color(0xFF\(surfaceColor))
val onSurfaceColor = Color(0xFF\(onSurfaceColor))
val primaryColor = Color(0xFF\(primaryColor))
val onPrimaryColor = Color(0xFF\(onPrimaryColor))
val errorColor = Color(0xFF\(errorColor))
val textColorPrimary = Color(0xFF\(textColorPrimary))
val textColorSecondary = Color(0xFF\(textColorSecondary))

private val LightColorScheme = lightColorScheme(
    onSurface = onSurfaceColor,
    primary = primaryColor,
    onPrimary = onPrimaryColor,
    surface = surfaceColor,
    error = errorColor,
    background = backColorPrimary,
    onBackground = backColorSecondary
)

@Composable
fun MyappTheme(
    content: @Composable () -> Unit
) {
    val colorScheme = LightColorScheme

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp,
        color = textColorSecondary
    ),
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = 30.sp,
        lineHeight = 30.sp,
        letterSpacing = 0.6.sp,
        textAlign = TextAlign.Center,
        color = textColorPrimary
    )
)

@Composable
fun MainScreen(appViewModel: AppViewModel = viewModel()) {
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
            .background(
                MaterialTheme.colorScheme.background
            ),
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
            contentColor = MaterialTheme.colorScheme.onSurface,
            containerColor = MaterialTheme.colorScheme.surface
        ),
        border = BorderStroke(
            width = 8.dp,
            color = MaterialTheme.colorScheme.onBackground
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
            style = MaterialTheme.typography.displayLarge
        )
    }
}

@Composable
fun TorchNotAvailableScreen() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background),
        contentAlignment = Alignment.Center
    ) {
        Text(
            style = MaterialTheme.typography.bodyLarge,
            text = "Torch not available"
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
