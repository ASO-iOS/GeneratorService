//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppMainFragment {
    static func fileContent(packageName: String, appId: String, mainData: MainData) -> String {
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
\(AndroidNecesseryDependencies.dependencies(mainData).mainFragmentData.imports)

\(AndroidNecesseryDependencies.dependencies(mainData).mainFragmentData.annotation)
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

\(annotationsById(appId))
@Composable fun MainScreen(stateViewModel: StateViewModel) {
    \(AndroidNecesseryDependencies.dependencies(mainData).mainFragmentData.content)
}
"""
    }
    
    static func annotationsById(_ id: String) -> String {
        switch id {
        case AppIDs.EG_PUZZLE_DIGITS:
            return """
@OptIn(ExperimentalComposeUiApi::class)
"""
        default: return ""
        }
    }
}
