//
//  File.swift
//  
//
//  Created by admin on 20.06.2023.
//

import Foundation

struct MBIpCheckerHistoryFragment {
    static let fileName = "HistoryFragment.kt"
    
    static func fileText(packageName: String) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import \(packageName).R
import \(packageName).databinding.FragmentMainBinding
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class IpCheckerMainFragment : Fragment() {

    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!

    private val mainViewModel: MainViewModel by viewModels()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        _binding = FragmentMainBinding.inflate(layoutInflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        subscribeOnFlow()
        createUi()
    }
    private fun subscribeOnFlow() {
        lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                mainViewModel.screenState.collect { state ->
                    when (state) {
                        is RequestScreenState.Failure -> error(state.message)
                        RequestScreenState.Loading -> {}
                        is RequestScreenState.Success -> success(state.data)
                    }
                }
            }
        }
    }

    private fun loading() = with(binding) {
        loadingProgressBar.visibility = View.VISIBLE
        llGeoData.visibility = View.GONE
        tvErrorMessage.visibility = View.GONE
        textInputLayoutId.visibility = View.GONE
        bGetData.visibility = View.GONE
    }

    private fun error(message: String) = with(binding) {
        loadingProgressBar.visibility = View.GONE
        llGeoData.visibility = View.GONE
        textInputLayoutId.visibility = View.VISIBLE
        bGetData.visibility = View.VISIBLE
        tvErrorMessage.visibility = View.VISIBLE
        tvErrorMessage.text = message
    }

    private fun success(data: GeoEntity) = with(binding) {
        with(data) {
            tvCountry.text = requireContext().getString(R.string.country, country)
            tvCity.text = requireContext().getString(R.string.city, city)
            tvTimezone.text = requireContext().getString(R.string.timezone, timezone)
            tvQuery.text = requireContext().getString(R.string.query, query)
        }

        tvErrorMessage.visibility = View.GONE
        loadingProgressBar.visibility = View.GONE
        llGeoData.visibility = View.VISIBLE
        bGetData.visibility = View.VISIBLE
        textInputLayoutId.visibility = View.VISIBLE
    }

    private fun createUi() = with(binding) {
        bGetData.setOnClickListener {
            loading()
            mainViewModel.getData(etIp.text.toString())
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }
}
"""
    }
}
