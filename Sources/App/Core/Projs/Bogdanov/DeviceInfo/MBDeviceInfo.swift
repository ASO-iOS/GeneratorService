//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct MBDeviceInfo: FileProviderProtocol {
    static var fileName: String = "MBDeviceInfo.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName)

import android.os.Build
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val backColorSecondary = Color(0xFF\(uiSettings.backColorSecondary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))
val onSurfaceColor = Color(0xFF\(uiSettings.onSurfaceColor ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val onPrimaryColor = Color(0xFF\(uiSettings.onPrimaryColor ?? "FFFFFF"))
val errorColor = Color(0xFF\(uiSettings.errorColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))

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
fun MBDeviceInfo(appViewModel: AppViewModel = viewModel()) {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.SpaceBetween,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        val mainState = appViewModel.mainState.collectAsState()
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(top = 16.dp)
                .weight(1f),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            items(
                items = mainState.value.deviceInfo.entries.toList(),
                key = { index ->
                    index.toString()
                }
            ) { deviceInfoItem ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 8.dp),
                    horizontalArrangement = Arrangement.SpaceEvenly,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    deviceInfoItem.value?.let { itemValueText ->
                        Text(
                            modifier = Modifier
                                .fillMaxWidth()
                                .weight(1f)
                                .padding(4.dp),
                            text = deviceInfoItem.key,
                            style = MaterialTheme.typography.bodyLarge,
                            textAlign = TextAlign.Justify
                        )

                        Text(
                            modifier = Modifier
                                .fillMaxWidth()
                                .weight(1f)
                                .padding(4.dp),
                            text = itemValueText,
                            style = MaterialTheme.typography.bodyLarge,
                            textAlign = TextAlign.Justify
                        )
                    }
                }
            }
        }
        OutlinedButton(
            modifier = Modifier
                .padding(bottom = 32.dp),
            onClick = {
                appViewModel.setDeviceInfo(DeviceInfoGetter.getDeviceInfo())
            }
        ) {
            Text(
                text = "Get Device Info",
                style = MaterialTheme.typography.displayLarge
            )
        }
    }
}

class AppViewModel : ViewModel() {

    private val _mainState = MutableStateFlow(MainState())
    val mainState = _mainState.asStateFlow()

    fun setDeviceInfo(info: MutableMap<String, String?>) = with(_mainState.value) {
        _mainState.value = copy(
            deviceInfo = info
        )
    }
}

object DeviceInfoGetter {

    fun getDeviceInfo(): MutableMap<String, String?> =
        mutableMapOf<String, String?>().apply {
            put("OS Version", System.getProperty("os.version"))
            put("Release: ", Build.VERSION.RELEASE)
            put("Device: ", Build.DEVICE)
            put("Model: ", Build.MODEL)
            put("Brand: ", Build.BRAND)
            put("User: ", Build.USER)
            put("Hardware: ", Build.HARDWARE)
            put("Manufacture: ", Build.MANUFACTURER)
            put("Host: ", Build.HOST)
            put("Display: ", Build.DISPLAY)
            put("Id: ", Build.ID)
            put("Product: ", Build.PRODUCT)
        }

}

data class MainState(
    val deviceInfo: MutableMap<String, String?> = mutableMapOf()
)

"""
    }
    
    
}
