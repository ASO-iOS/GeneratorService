//
//  File.swift
//  
//
//  Created by admin on 14.06.2023.
//

import Foundation

struct MBPingTest: FileProviderProtocol {
    static var fileName = "MBPingTest.kt"
    static func fileContent(
        packageName: String,
        uiSettings: UISettings
    ) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.accounts.NetworkErrorException
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
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
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.net.InetAddress
import \(packageName).R

val backColor = Color(0xFF\(uiSettings.backColorPrimary ?? "c1d9ec"))
val mainTextColor = Color(0xFF\(uiSettings.textColorPrimary ?? "2c0505"))
val mainButtonColor = Color(0xFF\(uiSettings.buttonColorPrimary ?? "ff5722"))
val buttonTextColor = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "ffffff"))
val mainTextSize = \(uiSettings.textSizePrimary ?? 22)
val mainPadding = \(uiSettings.paddingPrimary ?? 12)

val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    ),
    displayMedium = TextStyle(
        fontFamily = FontFamily.Default,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 1.sp
    ),
    displaySmall = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W300,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    ),
    displayLarge = TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.W500,
        fontSize = mainTextSize.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.4.sp,
        textAlign = TextAlign.Center
    )
)

@Composable
fun MBPing(viewModel: MainViewModel = viewModel()) {
    Column(
        modifier = Modifier
            .fillMaxSize()
                    .background(color = backColor),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            modifier = Modifier
                .padding(top = mainPadding.dp)
                    .background(color = backColor)
                .heightIn(max = 200.dp)
                .verticalScroll(rememberScrollState()).padding(vertical = 3.dp),
            text = when (val state = viewModel.outputResult) {
                is RequestState.Error -> "There is some error\\n${state.message}"

                RequestState.Loading -> "Enter the website address"

                is RequestState.Success -> "Host address: ${state.hostAddress}\\n\\n" +
                        "Host name: ${state.hostName}\\n\\nPing: ${state.ping}"
            },
            style = MaterialTheme.typography.displayLarge,
            color = mainTextColor
        )

        var inputUrl by remember {
            mutableStateOf("")
        }

        BasicTextField(
            modifier = Modifier
                .padding(mainPadding.dp)
                    .background(color = backColor),
            value = inputUrl,
            onValueChange = { newUrl ->
                inputUrl = newUrl
                viewModel.changeInputUrl(newUrl)
            },
            textStyle = TextStyle(color = mainTextColor, fontSize = 22.sp)
        ) { innerTextField ->
            Box(
                modifier = Modifier
                    .heightIn(min = 150.dp, max = 300.dp)
                    .fillMaxWidth()
                    .padding(top = mainPadding.dp, bottom = mainPadding.dp, end = mainPadding.dp, start = mainPadding.dp)
                    .background(color = backColor)
                    .border(
                        width = 4.dp,
                        color = colorScheme.onBackground,
                        shape = RoundedCornerShape(16.dp)
                    )
                    .padding(mainPadding.dp),
                contentAlignment = Alignment.Center
            ) {
                innerTextField()
            }
        }
        Button(
            modifier = Modifier
                .fillMaxWidth(0.85f)
                .padding(end = mainPadding.dp, start = mainPadding.dp, bottom = mainPadding.dp)
                    .background(color = backColor),
            colors = ButtonDefaults.buttonColors(
                containerColor = mainButtonColor,
                contentColor = buttonTextColor
            ),
            shape = RoundedCornerShape(16.dp),
            elevation = ButtonDefaults.buttonElevation(defaultElevation = 8.dp),

            onClick = {
                viewModel.ping()
            }
        ) {
            Text(
                text = "Confirm",
                style = MaterialTheme.typography.displayMedium
            )
        }
    }
}

@Composable
fun PingTestTheme(
    content: @Composable () -> Unit
) {

    MaterialTheme(
        typography = Typography,
        content = content
    )
}

class MainViewModel : ViewModel() {

    private var inputUrl by mutableStateOf("")

    var outputResult by mutableStateOf<RequestState>(RequestState.Loading)
        private set

    fun changeInputUrl(newUrl: String) {
        inputUrl = newUrl
    }

    fun ping() {
        viewModelScope.launch(Dispatchers.IO) {
            outputResult = pingServer(inputUrl)
        }
    }

    fun pingServer(inputUrl: String): RequestState = try {
        if (inputUrl == "") throw NetworkErrorException("Empty url")
        val inetAddress = InetAddress.getByName(inputUrl)
        val hostAddress = inetAddress.hostAddress
        val hostName = inetAddress.hostName
        val time = System.currentTimeMillis()
        inetAddress.isReachable(100)
        val ping = System.currentTimeMillis() - time

        RequestState.Success(
            hostAddress = hostAddress,
            hostName = hostName,
            ping = ping
        )

    } catch (e: Exception) {

        RequestState.Error(
            message = e.localizedMessage
        )
    }
}

sealed class RequestState {
    data class Success(
        val hostAddress: String,
        val hostName: String,
        val ping: Long
    ): RequestState()

    data class Error(
        val message: String
    ): RequestState()


    object Loading : RequestState()
}
"""
    }
}
