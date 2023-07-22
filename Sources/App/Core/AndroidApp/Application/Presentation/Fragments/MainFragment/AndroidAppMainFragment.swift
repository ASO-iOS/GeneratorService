//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppMainFragment {
    static func fileContent(packageName: String, appId: String) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.runtime.Composable
import android.annotation.SuppressLint
import android.content.pm.ActivityInfo
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.compose.ui.platform.ComposeView
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import \(packageName).repository.state.StateViewModel
import dagger.hilt.android.AndroidEntryPoint
\(importById(appId))

@AndroidEntryPoint
class MainFragment : Fragment() {

    private val stateViewModel by activityViewModels<StateViewModel>()
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return ComposeView(requireContext()).apply {
            setContent {
                MainScreen(stateViewModel = stateViewModel)
            }
        }
    }
}

@Composable fun MainScreen(stateViewModel: StateViewModel) {
    \(contentById(appId))
}
"""
    }
    
    static func contentById(_ id: String) -> String {
        switch id {
        case AppIDs.VS_STOPWATCH_ID:
            return """
                V1StopwatchScreen()
            """
        case AppIDs.VS_TORCH_ID:
            return """
                val torchViewModel =
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) hiltViewModel<TorchViewModel31>() else hiltViewModel<TorchViewModelImpl>()
                TorchScreen(viewModel = torchViewModel)
            """
        case AppIDs.VS_PHONE_INFO_ID:
            return """
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                ) {
                    PhoneInfoNavHost()
                }
            """
        case AppIDs.MB_STOPWATCH:
            return """
                StopwatchTheme() {
                    MBStopwatch()
                }
            """
        case AppIDs.MB_SPEED_TEST:
            return """
                val context = LocalContext.current
                SpeedTestTheme {
                    MainScreen(
                        downSpeed = ConnectManager.getDownloadSpeed(context),
                        upSpeed = ConnectManager.getUploadSpeed(context)
                    )
                }
            """
        case AppIDs.MB_PING_TEST:
            return """
                PingTestTheme {
                    MBPing()
                }
            """
        case AppIDs.MB_ALARM:
            return """
                AlarmTheme {
                    MBAlarm()
                }
            """
        case AppIDs.MB_FACTS:
            return """
                MBFacts()
            """
        case AppIDs.MB_TORCH:
            return """
                MyappTheme {
                    MainScreen()
                }
            """
        case AppIDs.MB_LUCKY_NUMBER:
            return """
                MyappTheme {
                    MBLuckyNumber()
                }
            """
        case AppIDs.MB_RACE:
            return """
                MBRace()
            """
        case AppIDs.MB_CATCHER:
            return """
                val viewModel: MainViewModel = hiltViewModel()
                val res = LocalContext.current.resources
                LaunchedEffect(key1 = Unit) {

                    viewModel.initialize(res)
                }

                val state = viewModel.state.collectAsState()

                when (state.value.screen) {
                    Screen.Finished -> EndGameScreen(viewModel = viewModel, state = state)
                    Screen.Loading -> LoadingScreen()
                    Screen.Running -> GameCanvas(viewModel = viewModel)
                }
            """
        case AppIDs.MB_BMI_CALC_ID:
            return """
                MBBmi()
            """
        case AppIDs.MB_SPACE_FIGHTER:
            return """
                MBSpaseFighter()
            """
        case AppIDs.MB_CHECK_IP:
            return """
                MBCheckIp()
            """
        case AppIDs.MB_RICK_AND_MORTY:
            return """
                PagingAppComposeTheme {
                    MBRickNMorty()
                }
            """
        case AppIDs.MB_PASS_GEN:
            return """
                MBPassGen()
            """
        case AppIDs.MB_DEVICE_INFO:
            return """
                MyappTheme {
                    MBDeviceInfo()
                }
            """
            // MARK: - new cases
        default:
            return ""
        }
    }
    static func importById(_ id: String) -> String {
        switch id {
        case AppIDs.VS_TORCH_ID:
            return """
import android.os.Build
import androidx.hilt.navigation.compose.hiltViewModel
"""
        case AppIDs.VS_PHONE_INFO_ID:
            return """
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
"""
        case AppIDs.MB_SPEED_TEST:
            return """
import androidx.compose.ui.platform.LocalContext
"""
        case AppIDs.MB_CATCHER:
            return """
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.platform.LocalContext
import androidx.hilt.navigation.compose.hiltViewModel
"""
            // MARK: - new cases
        default:
            return ""
        }
    }
}
