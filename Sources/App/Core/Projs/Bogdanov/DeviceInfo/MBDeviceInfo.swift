//
//  File.swift
//  
//
//  Created by admin on 07.07.2023.
//

import Foundation

struct MBDeviceInfo: FileProviderProtocol {
    static func dependencies(_ packageName: String) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
            MBDeviceInfo()
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
    
    static var fileName: String = "MBDeviceInfo.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment


import android.os.Build
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Composable
fun MBDeviceInfo(appViewModel: AppViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary),
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
            if (mainState.value.deviceInfo.isEmpty()) {
                item {
                    Spacer(modifier = Modifier.padding(50.dp))
                    Text(
                        text = "Click on the button to get information about the device",
                        color = textColorPrimary,
                        fontSize = 32.sp, textAlign = TextAlign.Center
                    )
                }
            } else {
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
                                textAlign = TextAlign.Justify,
                                color = textColorPrimary,
                                fontSize = 16.sp
                            )

                            Text(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .weight(1f)
                                    .padding(4.dp),
                                text = itemValueText,
                                color = textColorPrimary,
                                fontSize = 20.sp,
                                textAlign = TextAlign.Justify
                            )
                        }
                    }
                }
            }

        }
        OutlinedButton(
            modifier = Modifier
                .padding(bottom = 32.dp),
            onClick = {
                appViewModel.setDeviceInfo(DeviceInfoGetter.getDeviceInfo())
            },
            colors = ButtonDefaults.buttonColors(buttonColorPrimary)
        ) {
            Text(
                text = "Get Device Info",
                color = buttonTextColorPrimary,
                fontSize = 24.sp
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
