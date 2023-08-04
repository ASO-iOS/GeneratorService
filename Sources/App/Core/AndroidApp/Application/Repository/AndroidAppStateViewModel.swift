//
//  File.swift
//  
//
//  Created by admin on 26.05.2023.
//

import Foundation

struct AndroidAppStateViewModel {
    static func fileContent(mainData: MainData) -> String {
        return """
package \(mainData.packageName).repository.state

import androidx.lifecycle.ViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import javax.inject.Inject

@HiltViewModel
class StateViewModel @Inject constructor() :
    ViewModel() {

    private val _state: MutableStateFlow<FragmentState> = MutableStateFlow(FragmentState.MainState)
    val state: StateFlow<FragmentState> get() = _state

    fun setMainState() {
        _state.value = FragmentState.MainState
    }
    \(AndroidNecesseryDependencies.dependencies(mainData).stateViewModelData ?? "")
}
"""
    }
}
