//
//  File.swift
//  
//
//  Created by admin on 14.08.2023.
//

import Foundation

struct KLSpeedTest: XMLFileProviderProtocol {
    static var fileName = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import javax.inject.Inject

data class NetworkModel(
    val downstreamKbps: Int,
    val upstreamKbps: Int
)

sealed class NetworkStatus {
    object Loading : NetworkStatus()
    class Available(val data: NetworkModel) : NetworkStatus()
    object Unavailable : NetworkStatus()
}

class NetworkStatusTracker @Inject constructor(@ApplicationContext val context: Context) {

    private val _connection = MutableLiveData<NetworkStatus>()
    val connection: LiveData<NetworkStatus>
        get() = _connection

    private val connectivityManager by lazy {
        context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    }

    private val networkCallback = object : ConnectivityManager.NetworkCallback() {

        override fun onUnavailable() {
            super.onUnavailable()
            CoroutineScope(Dispatchers.Main).launch {
                _connection.value = NetworkStatus.Unavailable
            }
        }

        override fun onLost(network: Network) {
            super.onLost(network)
            CoroutineScope(Dispatchers.Main).launch {
                _connection.value = NetworkStatus.Unavailable
            }
        }

        override fun onCapabilitiesChanged(
            network: Network,
            networkCapabilities: NetworkCapabilities
        ) {
            super.onCapabilitiesChanged(network, networkCapabilities)
            val upstreamMbps = convertKbpsIntoMbps(networkCapabilities.linkUpstreamBandwidthKbps)
            val downstreamMbps = convertKbpsIntoMbps(networkCapabilities.linkDownstreamBandwidthKbps)
            CoroutineScope(Dispatchers.Main).launch {
                _connection.value = NetworkStatus.Loading
                delay(1000)
                _connection.value =
                    NetworkStatus.Available(NetworkModel(upstreamMbps, downstreamMbps))
            }
        }
    }

    fun getConnection() {
        connectivityManager.registerDefaultNetworkCallback(networkCallback)
        if (connectivityManager.activeNetwork == null) {
            _connection.value = NetworkStatus.Unavailable
        }
    }

    private fun convertKbpsIntoMbps(kbps: Int) = kbps / 1000

}

@HiltViewModel
class NetworkViewModel @Inject constructor(private val networkStatusTracker: NetworkStatusTracker) : ViewModel() {

    val connection = networkStatusTracker.connection

    init {
        viewModelScope.launch {
            networkStatusTracker.getConnection()
        }
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: ""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="no_internet_error">No Internet Connection</string>
    <string name="download_title">Download</string>
    <string name="upload_title">Upload</string>
    <string name="speed_value_mbps">%d mbps</string>
    <string name="speed_value_mbps_start">0 mbps</string>
    <string name="status_loading">Loading</string>
"""), colorsData: ANDColorsData(additional: """
    <color name="backColorPrimary">#\(mainData.uiSettings.backColorPrimary ?? "FFFFFF")</color>
    <color name="backColorSecondary">#\(mainData.uiSettings.backColorSecondary ?? "FFFFFF")</color>
    <color name="surfaceColor">#\(mainData.uiSettings.surfaceColor ?? "FFFFFF")</color>
    <color name="textColorPrimary">#\(mainData.uiSettings.textColorPrimary ?? "FFFFFF")</color>
    <color name="textColorSecondary">#\(mainData.uiSettings.textColorSecondary ?? "FFFFFF")</color>
"""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = """
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id 'com.android.application' version '8.0.2' apply false
    id 'com.android.library' version '8.0.2' apply false
    id 'org.jetbrains.kotlin.android' version '1.8.20' apply false
    id 'com.google.dagger.hilt.android' version '2.44' apply false
}
"""
        let projectGradleName = "build.gradle"
        let moduleGradle = """
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

android {
    namespace '\(packageName)'
    compileSdk 33

    defaultConfig {
        applicationId "\(packageName)"
        minSdk 24
        targetSdk 33
        versionCode 1
        versionName "1.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.debug
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = '17'
    }
    buildFeatures {
        viewBinding true
    }
}

dependencies {

    implementation 'androidx.core:core-ktx:1.10.1'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.9.0'
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.3'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.4.0'

    implementation "com.google.dagger:hilt-android:2.44"
    kapt "com.google.dagger:hilt-android-compiler:2.44"

    implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.1"
    implementation "androidx.lifecycle:lifecycle-livedata-ktx:2.6.1"

    implementation 'androidx.fragment:fragment-ktx:1.6.1'
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = ""
        let dependenciesName = ""

        return GradleFilesData(
            projectBuildGradle: GradleFileInfoData(
                content: projectGradle,
                name: projectGradleName
            ),
            moduleBuildGradle: GradleFileInfoData(
                content: moduleGradle,
                name: moduleGradleName
            ),
            dependencies: GradleFileInfoData(
                content: dependencies,
                name: dependenciesName
            ))
    }
    
    static func cmfHandler(_ packageName: String) -> ANDMainFragmentCMF {
        return ANDMainFragmentCMF(content: """
package \(packageName).presentation.fragments.main_fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.activityViewModels
import \(packageName).R
import \(packageName).databinding.FragmentMainBinding
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainFragment : Fragment() {

    private var _binding: FragmentMainBinding? = null
    private val binding get() = _binding!!

    private val viewModel: NetworkViewModel by activityViewModels()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentMainBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel.connection.observe(viewLifecycleOwner) {
            when (it) {
                is NetworkStatus.Loading -> {
                    binding.pbLoading.visibility = View.VISIBLE
                    binding.tvStatus.visibility = View.VISIBLE
                    binding.tvStatus.text = getString(R.string.status_loading)
                }
                is NetworkStatus.Available -> {
                    val speedTemplate = getString(R.string.speed_value_mbps)
                    with(binding) {
                        tvUpstreamValue.text = String.format(speedTemplate,  it.data.upstreamKbps)
                        tvDownstreamValue.text = String.format(speedTemplate, it.data.downstreamKbps)
                        tvStatus.visibility = View.GONE
                        binding.pbLoading.visibility = View.GONE
                    }
                }
                is NetworkStatus.Unavailable -> {
                    binding.pbLoading.visibility = View.GONE
                    binding.tvStatus.text = getString(R.string.no_internet_error)
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        _binding = null
    }
}

""", fileName: "MainFragment.kt")
    }
    
    static func layout(_ uiSettings: UISettings) -> [XMLLayoutData] {
        let mainFragmentName = "fragment_main.xml"
        let mainFragmentContent = """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    android:padding="@dimen/fragment_padding">

    <TextView
        android:id="@+id/tv_speed_test_title"
        style="@style/AppTitle"
        android:text="@string/app_name"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <androidx.cardview.widget.CardView
        android:id="@+id/cd_download"
        style="@style/SpeedCard"
        android:layout_marginTop="@dimen/card_margin_top_portrait_100"
        android:layout_width="@dimen/card_width"
        android:layout_height="@dimen/card_height"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/tv_speed_test_title"
        app:layout_constraintVertical_chainStyle="packed">

        <LinearLayout style="@style/SpeedCardLl">

            <TextView
                android:id="@+id/tv_downstream_title"
                style="@style/SpeedTitle"
                android:text="@string/download_title"
                app:layout_constraintEnd_toEndOf="parent"
                app:layout_constraintTop_toTopOf="parent" />

            <TextView
                android:id="@+id/tv_downstream_value"
                style="@style/SpeedValue"
                android:text="@string/speed_value_mbps_start"
                app:layout_constraintEnd_toEndOf="parent"
                app:layout_constraintTop_toTopOf="parent" />
        </LinearLayout>
    </androidx.cardview.widget.CardView>

    <androidx.cardview.widget.CardView
        android:id="@+id/cd_upload"
        style="@style/SpeedCard"
        android:layout_width="@dimen/card_width"
        android:layout_height="@dimen/card_height"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/cd_download">

        <LinearLayout style="@style/SpeedCardLl">

            <TextView
                android:id="@+id/tv_upstream_title"
                style="@style/SpeedTitle"
                android:text="@string/upload_title"
                app:layout_constraintEnd_toEndOf="parent"
                app:layout_constraintTop_toTopOf="parent" />

            <TextView
                android:id="@+id/tv_upstream_value"
                style="@style/SpeedValue"
                android:text="@string/speed_value_mbps_start"
                app:layout_constraintEnd_toEndOf="parent"
                app:layout_constraintTop_toTopOf="parent" />
        </LinearLayout>
    </androidx.cardview.widget.CardView>

    <ProgressBar
        android:id="@+id/pb_loading"
        style="@style/ProgressBar"
        android:indeterminateTint="@color/surfaceColor"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/cd_upload" />

    <TextView
        android:id="@+id/tv_status"
        style="@style/Status"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="@string/status_loading"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/pb_loading" />

</androidx.constraintlayout.widget.ConstraintLayout>
"""
        return [XMLLayoutData(content: mainFragmentContent, name: mainFragmentName)]
    }
    
    static func dimens(_ uiSettings: UISettings) -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="app_name">32sp</dimen>

    <dimen name="speed_value_text_size">48sp</dimen>
    <dimen name="speed_title_text_size">24sp</dimen>
    <dimen name="status_text_size">16sp</dimen>

    <dimen name="fragment_padding">24dp</dimen>
    <dimen name="ll_padding">16dp</dimen>

    <dimen name="card_elevation">4dp</dimen>
    <dimen name="corner_radius">4dp</dimen>
    <dimen name="card_margin_top_portrait_100">100dp</dimen>
    <dimen name="card_margin_top_16">16dp</dimen>
    <dimen name="card_width">320dp</dimen>
    <dimen name="card_height">150dp</dimen>

    <dimen name="speed_value_margin">8dp</dimen>

    <dimen name="progress_bar_width">80dp</dimen>
    <dimen name="progress_bar_height">80dp</dimen>
    <dimen name="progress_bar_margin_top">20dp</dimen>

</resources>
""", name: "dimens.xml")
    }
    
    static func styles() -> XMLLayoutData {
        return XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="AppTitle">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="fontFamily">monospace</item>
        <item name="android:textSize">@dimen/app_name</item>
        <item name="android:textColor">@color/textColorPrimary</item>
    </style>

    <style name="SpeedCard">
        <item name="cardBackgroundColor">@color/backColorSecondary</item>
        <item name="cardCornerRadius">@dimen/corner_radius</item>
        <item name="cardElevation">@dimen/card_elevation</item>
        <item name="cardUseCompatPadding">true</item>
        <item name="android:layout_marginTop">@dimen/card_margin_top_16</item>
    </style>

    <style name="SpeedCardLl">
        <item name="android:orientation">vertical</item>
        <item name="android:layout_width">match_parent</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="android:gravity">center</item>
        <item name="android:padding">@dimen/ll_padding</item>
    </style>

    <style name="SpeedTitle">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="fontFamily">monospace</item>
        <item name="android:textSize">@dimen/speed_title_text_size</item>
        <item name="android:textColor">@color/textColorSecondary</item>
    </style>

    <style name="SpeedValue">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="fontFamily">monospace</item>
        <item name="android:textSize">@dimen/speed_value_text_size</item>
        <item name="android:textColor">@color/textColorPrimary</item>
        <item name="android:layout_marginTop">@dimen/speed_value_margin</item>
    </style>

    <style name="ProgressBar">
        <item name="android:indeterminate">true</item>
        <item name="android:layout_width">@dimen/progress_bar_width</item>
        <item name="android:layout_height">@dimen/progress_bar_height</item>
        <item name="android:layout_marginTop">@dimen/progress_bar_margin_top</item>
    </style>

    <style name="Status">
        <item name="android:layout_width">wrap_content</item>
        <item name="android:layout_height">wrap_content</item>
        <item name="fontFamily">monospace</item>
        <item name="android:textSize">@dimen/status_text_size</item>
        <item name="android:textColor">@color/textColorPrimary</item>
    </style>
</resources>
""", name: "styles.xml")
    }
}
