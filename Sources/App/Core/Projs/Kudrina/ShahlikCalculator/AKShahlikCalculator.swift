//
//  File.swift
//  
//
//  Created by admin on 10.08.2023.
//

import Foundation

struct AKShahlikCalculator: FileProviderProtocol {
    static var fileName: String = "AKShahlikCalculator.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.Card
import androidx.compose.material.RadioButton
import androidx.compose.material.RadioButtonDefaults
import androidx.compose.material.Slider
import androidx.compose.material.SliderDefaults
import androidx.compose.material.Text
import androidx.compose.material.TextField
import androidx.compose.material.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import \(packageName).R
import kotlin.math.roundToInt

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val onPrimaryColor = Color(0x00\(uiSettings.onPrimaryColor ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))

val paddingPrimary = 20.dp
val textSizePrimary = 20.sp


const val cowMeatType = 0.3
const val chickenMeatType = 0.35
const val pigMeatType = 0.3
const val sheepMeatType = 0.3
var resMeat = 0.0


const val timeSType = 0.0
const val timeMType = 0.1
const val timeLType = 0.2
var resTime = 0.0


const val hungerNone = 0.0
const val hungerS = 0.1
const val hungerM = 0.15
const val hungerL = 0.2
var resHunger = 0.0


var resPeople = 0

@Composable
fun MainScreenUI() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(backColorPrimary)
            .verticalScroll(rememberScrollState())
    ) {

        Text(
            text = stringResource(R.string.title),
            fontSize = textSizePrimary,
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 10.dp, start = paddingPrimary, end = paddingPrimary),
            textAlign = TextAlign.Center,
            color = buttonTextColorPrimary
        )

        Card(
            modifier = Modifier
                .fillMaxWidth()
                .alpha(0.95f)
                .padding(top = 10.dp, start = paddingPrimary, end = paddingPrimary),
            shape = RoundedCornerShape(25.dp),
            backgroundColor = buttonTextColorPrimary
        ) {
            ChoseMeatUI()
        }

        Card(
            modifier = Modifier
                .fillMaxWidth()
                .alpha(0.95f)
                .padding(top = 10.dp, start = paddingPrimary, end = paddingPrimary),
            shape = RoundedCornerShape(25.dp),
            backgroundColor = buttonTextColorPrimary
        ) {
            ChosePeopleUI()
        }

        Card(
            modifier = Modifier
                .fillMaxWidth()
                .alpha(0.95f)
                .padding(top = 10.dp, start = paddingPrimary, end = paddingPrimary),
            shape = RoundedCornerShape(25.dp),
            backgroundColor = buttonTextColorPrimary
        ) {
            ChoseTimeUI()
        }

        Card(
            modifier = Modifier
                .fillMaxWidth()
                .alpha(0.95f)
                .padding(top = 10.dp, start = paddingPrimary, end = paddingPrimary),
            shape = RoundedCornerShape(25.dp),
            backgroundColor = buttonTextColorPrimary
        ) {
            ChoseHungerUI()
        }

        Card(
            modifier = Modifier
                .fillMaxWidth()
                .alpha(0.95f)
                .padding(top = 10.dp, start = paddingPrimary, end = paddingPrimary),
            shape = RoundedCornerShape(25.dp),
            backgroundColor = buttonTextColorPrimary
        ) {
            GetResultUI()
        }
    }
}

// Hunger
@Composable
fun ChoseHungerUI() {

    val sliderPosition = rememberSaveable{ mutableStateOf(0f) }

    when (sliderPosition.value) {
        in 0f..0.24f -> resHunger = hungerNone
        in 0.25f..0.49f -> resHunger = hungerS
        in 0.5f..0.74f -> resHunger = hungerM
        in 0.75f..1f -> resHunger = hungerL
    }

    Column(
    ) {

        Text(
            text = stringResource(R.string.choose_hunger),
            modifier = Modifier
                .padding(top = 5.dp, start = 13.dp, end = 13.dp),
            color = textColorPrimary,
            fontSize = 18.sp
        )

        Slider(
            modifier = Modifier.padding(start = 20.dp, end = 20.dp),
            value = sliderPosition.value,
            onValueChange = {
                sliderPosition.value = it

            },
            colors = SliderDefaults.colors(
                thumbColor = textColorPrimary,
                activeTrackColor = backColorPrimary,
                inactiveTrackColor = primaryColor,
            )
        )


    }
}

@Composable
fun ChoseMeatUI() {
    Column() {

        Text(
            text = stringResource(R.string.choose_meat),
            modifier = Modifier
                .padding(top = 5.dp, start = 13.dp, end = 13.dp),
            color = textColorPrimary,
            fontSize = 18.sp
        )

        Row(
            modifier = Modifier
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceAround
        ) {

            val alphaMax = 1.0F
            val alphaMin = 0.38F



            val chosenMeat = rememberSaveable {
                mutableStateOf(0.0)
            }

            val alphaCow = rememberSaveable {
                mutableStateOf(alphaMax)
            }

            val alphaChicken = rememberSaveable {
                mutableStateOf(alphaMax)
            }

            val alphaPig = rememberSaveable {
                mutableStateOf(alphaMax)
            }

            val alphaSheep = rememberSaveable {
                mutableStateOf(alphaMax)
            }


            resMeat = chosenMeat.value

            // COW
            Image(
                painter = painterResource(id = R.drawable.cow),
                contentDescription = stringResource(id = R.string.cow_desc),
                modifier = Modifier
                    .size(70.dp)
                    .alpha(alphaCow.value)
                    .clickable(
                        enabled = true,
                        onClick = {
                            alphaCow.value = alphaMax
                            alphaChicken.value = alphaMin
                            alphaPig.value = alphaMin
                            alphaSheep.value = alphaMin
                            chosenMeat.value = cowMeatType
                        }
                    )


            )


            //CHICKEN
            Image(
                painter = painterResource(id = R.drawable.chicken),
                contentDescription = stringResource(id = R.string.chicken_desc),
                modifier = Modifier
                    .size(70.dp)
                    .alpha(alphaChicken.value)
                    .clickable(
                        enabled = true,
                        onClick = {
                            alphaCow.value = alphaMin
                            alphaChicken.value = alphaMax
                            alphaPig.value = alphaMin
                            alphaSheep.value = alphaMin
                            chosenMeat.value = chickenMeatType
                        }
                    )

            )


            // PIG
            Image(
                painter = painterResource(id = R.drawable.pig),
                contentDescription = stringResource(id = R.string.pig_desc),
                modifier = Modifier
                    .size(70.dp)
                    .alpha(alphaPig.value)
                    .clickable(
                        enabled = true,
                        onClick = {
                            alphaCow.value = alphaMin
                            alphaChicken.value = alphaMin
                            alphaPig.value = alphaMax
                            alphaSheep.value = alphaMin
                            chosenMeat.value = pigMeatType
                        }
                    )

            )

            // SHEEP
            Image(
                painter = painterResource(id = R.drawable.sheep),
                contentDescription = stringResource(id = R.string.sheep_desc),
                modifier = Modifier
                    .size(70.dp)
                    .alpha(alphaSheep.value)
                    .clickable(
                        enabled = true,
                        onClick = {
                            alphaCow.value = alphaMin
                            alphaChicken.value = alphaMin
                            alphaPig.value = alphaMin
                            alphaSheep.value = alphaMax
                            chosenMeat.value = sheepMeatType
                        }
                    )

            )
        }
    }
}

// People
@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun ChosePeopleUI() {
    val keyboardController = LocalSoftwareKeyboardController.current

    Row(
        modifier = Modifier
            .fillMaxWidth()
    ) {
        Column(modifier = Modifier
            .weight(2f)
        ) {

            Text(
                text = stringResource(R.string.choose_people),
                modifier = Modifier
                    .padding(top = 5.dp, start = 13.dp, end = 13.dp, bottom = 8.dp),
                color = textColorPrimary,
                fontSize = 18.sp
            )

            var peopleValue by rememberSaveable {
                mutableStateOf("")
            }


            TextField(

                modifier = Modifier
                    .padding(start = 13.dp, bottom = 8.dp)
                    .wrapContentHeight(),
                singleLine = true,

                value = peopleValue,
                onValueChange = {
                    peopleValue = it
                    if (it.isNotEmpty()) resPeople = it.toInt()
                },

                placeholder   = {
                    Text(
                        text = stringResource(id = R.string.people_hint),
                        color = textColorSecondary,
                        fontSize = 16.sp
                    )
                },
                colors = TextFieldDefaults.textFieldColors(
                    cursorColor = textColorPrimary,
                    textColor = textColorPrimary,
                    focusedIndicatorColor = onPrimaryColor,
                    unfocusedIndicatorColor = onPrimaryColor
                ),
                shape = RoundedCornerShape(23.dp),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number, imeAction = ImeAction.Done),
                keyboardActions = KeyboardActions(onDone = {keyboardController?.hide()})

            )



        }
        Column(modifier = Modifier
            .weight(1f)
            .height(100.dp)
            .align(Alignment.Bottom),
        ) {
            Image(
                painter = painterResource(id = R.drawable.shashlik),
                contentDescription = "shashlik",
                modifier = Modifier
                    .padding(top = 8.dp, bottom = 8.dp, start = 13.dp, end = 13.dp)
            )
        }

    }
}

@Composable
fun ChoseTimeUI() {

    Column {

        Text(
            text = stringResource(R.string.choose_length),
            modifier = Modifier
                .padding(top = 5.dp, start = 13.dp, end = 13.dp),
            color = textColorPrimary,
            fontSize = 18.sp
        )

        val timeS = stringResource(R.string.length_s)
        val timeM = stringResource(R.string.length_m)
        val timeL = stringResource(R.string.length_l)

        val chosenTime = rememberSaveable {
            mutableStateOf(0.0)
        }
        resTime = chosenTime.value

        val timesOptions = listOf(timeS, timeM, timeL)
        val (selectedOption, onOptionSelected) = rememberSaveable { mutableStateOf(timesOptions[0]) }

        chosenTime.value = when (selectedOption) {
            timeS ->timeSType
            timeM ->timeMType
            timeL ->timeLType
            else -> {timeSType}
        }


        Column(Modifier.selectableGroup()) {
            timesOptions.forEach { text ->



                Row(
                    modifier = if (text == timeL) {
                        Modifier.padding(bottom = 8.dp)
                    } else {
                        Modifier.padding(bottom = 0.dp)
                    },
                    verticalAlignment = Alignment.CenterVertically,
                )
                {
                    RadioButton(
                        modifier = Modifier.size(40.dp),
                        selected = (text == selectedOption),
                        onClick = {
                            onOptionSelected(text)
//                            if (text==time_s) chosenTime.value = time_s_type
//                            else if (text==time_m) chosenTime.value = time_m_type
//                            else if (text==time_l) chosenTime.value = time_l_type
                        },
                        colors = RadioButtonDefaults.colors(backColorPrimary)
                    )

                    Text(
                        modifier = Modifier.wrapContentHeight(),
                        text = text,
                        fontSize = 16.sp
                    )
                }
            }
        }
    }
}

@Composable
fun GetResultUI() {


    val res_text = stringResource(id = R.string.result)
    val kilo = stringResource(R.string.kilo)
    val result = rememberSaveable {
        mutableStateOf(res_text)
    }




    Row(
        verticalAlignment = Alignment.CenterVertically
    ) {
        Card(
            modifier = Modifier
                .weight(1f)
                .padding(start = 20.dp, end = 8.dp)
                .alpha(0.95f),
            shape = RoundedCornerShape(40),
            backgroundColor = buttonTextColorPrimary,

            ) {
            Text(
                modifier = Modifier
                    .weight(1f)
                    .wrapContentHeight(Alignment.CenterVertically)
                    .padding(start = 13.dp),
                text = result.value,
                color = textColorPrimary,
                fontSize = 18.sp,
            )

        }


        val context = LocalContext.current

        Button(
            modifier = Modifier
                .padding(end = 20.dp),
            colors = ButtonDefaults.buttonColors(backgroundColor = buttonColorPrimary),
            shape = RoundedCornerShape(40),
            onClick = {

                if (resMeat == 0.0 || resPeople == 0) {
                    Toast.makeText(
                        context,
                        R.string.toast,
                        Toast.LENGTH_SHORT
                    ).show()
                    result.value = res_text
                } else if (resPeople<1 || resPeople>50) {
                    result.value = res_text
                    Toast.makeText(
                        context,
                        R.string.toast_people,
                        Toast.LENGTH_SHORT
                    ).show()
                } else {
                    var helper = (resPeople.toDouble()*(resMeat+resTime+resHunger))
                    helper = (helper*100).roundToInt() / 100.0
                    result.value = "$res_text $helper $kilo"
                }
            },
        ) {
            Text(
                text = stringResource(R.string.count),
                color = buttonTextColorPrimary,
                fontSize = 18.sp,
            )

        }

    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
    MainScreenUI()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
    <string name="title">Рассчитайте идеальное количество шашлыка в пару кликов</string>
    <string name="choose_meat">Выберите вид мяса:</string>
    <string name="choose_people">Сколько человек будет есть?</string>
    <string name="people_hint">Введите число</string>
    <string name="choose_length">Насколько долгая планируется посиделка?</string>
    <string name="length_s">Быстро поели и домой!</string>
    <string name="length_m">На целый вечер</string>
    <string name="length_l">Будем сидеть до победного!</string>
    <string name="choose_hunger">Уровень общего голода:</string>
    <string name="result">"Результат: "</string>
    <string name="count">Посчитать</string>
    <string name="toast">Пожалуйста, заполните все поля!</string>
    <string name="kilo">кг</string>
    <string name="toast_people">Количество людей должно быть от 1 до 50</string>


    <string name="cow_desc">cow</string>
    <string name="chicken_desc">chicken</string>
    <string name="pig_desc">pig</string>
    <string name="sheep_desc">sheep</string>
"""), colorsData: ANDColorsData(additional: ""))
    }
    
    static func gradle(_ packageName: String) -> GradleFilesData {
        let projectGradle = """
import dependencies.Versions
import dependencies.Build

buildscript {
    ext {
        compose_version = Versions.compose
        kotlin_version = Versions.kotlin
    }

    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
    dependencies {
        classpath Build.build_tools
        classpath Build.kotlin_gradle_plugin
        classpath Build.hilt_plugin
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
"""
        let projectGradleName = "build.gradle"
        let moduleGradle = """
import dependencies.Versions
import dependencies.Application
import dependencies.Dependencies

apply plugin: 'com.android.application'
apply plugin: 'org.jetbrains.kotlin.android'
apply plugin: 'kotlin-kapt'
apply plugin: 'dagger.hilt.android.plugin'

android {
    namespace Application.id
    compileSdk Versions.compilesdk

    defaultConfig {
        applicationId Application.id
        minSdk Versions.minsdk
        targetSdk Versions.targetsdk
        versionCode Application.version_code
        versionName Application.version_name

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary true
        }
    }

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
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
        compose true
    }
    composeOptions {
        kotlinCompilerExtensionVersion compose_version
    }
    bundle {
        storeArchive {
            enable = false
        }
    }
}

dependencies {

    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material
    implementation Dependencies.compose_ui
    implementation Dependencies.compose_material
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_hilt_nav
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    
}
"""
        let moduleGradleName = "build.gradle"

        let dependencies = """
package dependencies

object Application {
    const val id = "\(packageName)"
    const val version_code = 1
    const val version_name = "1.0"
}

object Build {
    const val build_tools = "com.android.tools.build:gradle:${Versions.gradle}"
    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    const val hilt_plugin = "com.google.dagger:hilt-android-gradle-plugin:${Versions.hilt}"
}


object Versions {
    const val gradle = "8.0.0"
    const val compilesdk = 33
    const val minsdk = 24
    const val targetsdk = 33
    const val kotlin = "1.8.10"
    const val kotlin_coroutines = "1.6.3"
    const val hilt = "2.43.2"
    const val hilt_viewmodel_compiler = "1.0.0"

    const val ktx = "1.10.0"
    const val lifecycle = "2.6.1"
    const val fragment_ktx = "1.5.7"
    const val appcompat = "1.6.1"
    const val material = "1.9.0"
    const val accompanist = "0.31.1-alpha"

    const val compose = "1.4.3"
    const val compose_navigation = "2.5.0-beta01"
    const val activity_compose = "1.7.1"
    const val compose_hilt_nav = "1.0.0"

    const val oneSignal = "4.6.7"
    const val glide = "4.12.0"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "1.3.2"
    const val exp = "0.4.8"
    const val calend = "0.5.1"
    const val paging_version = "3.1.1"
}

object Dependencies {
    const val core_ktx = "androidx.core:core-ktx:${Versions.ktx}"
    const val appcompat = "androidx.appcompat:appcompat:${Versions.appcompat}"
    const val material = "com.google.android.material:material:${Versions.material}"

    const val compose_ui = "androidx.compose.ui:ui:${Versions.compose}"
    const val compose_material = "androidx.compose.material:material:${Versions.compose}"
    const val compose_preview = "androidx.compose.ui:ui-tooling-preview:${Versions.compose}"
    const val compose_activity = "androidx.activity:activity-compose:${Versions.activity_compose}"
    const val compose_ui_tooling = "androidx.compose.ui:ui-tooling:${Versions.compose}"
    const val compose_navigation = "androidx.navigation:navigation-compose:${Versions.compose_navigation}"
    const val compose_hilt_nav = "androidx.hilt:hilt-navigation-compose:${Versions.compose_hilt_nav}"
    const val compose_foundation = "androidx.compose.foundation:foundation:${Versions.compose}"
    const val compose_runtime = "androidx.compose.runtime:runtime:${Versions.compose}"
    const val compose_material3 = "androidx.compose.material3:material3:1.1.0-rc01"
    const val compose_runtime_livedata = "androidx.compose.runtime:runtime-livedata:${Versions.compose}"
    const val compose_mat_icons_core = "androidx.compose.material:material-icons-core:${Versions.compose}"
    const val compose_mat_icons_core_extended = "androidx.compose.material:material-icons-extended:${Versions.compose}"

    const val coroutines = "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.kotlin_coroutines}"
    const val fragment_ktx = "androidx.fragment:fragment-ktx:${Versions.fragment_ktx}"
    const val compose_system_ui_controller = "com.google.accompanist:accompanist-systemuicontroller:${Versions.accompanist}"
    const val compose_permissions = "com.google.accompanist:accompanist-permissions:${Versions.accompanist}"

    const val lifecycle_viewmodel = "androidx.lifecycle:lifecycle-viewmodel-ktx:${Versions.lifecycle}"
    const val lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime-ktx:${Versions.lifecycle}"

    const val retrofit = "com.squareup.retrofit2:retrofit:${Versions.retrofit}"
    const val converter_gson = "com.squareup.retrofit2:converter-gson:${Versions.retrofit}"
    const val okhttp = "com.squareup.okhttp3:okhttp:${Versions.okhttp}"
    const val okhttp_login_interceptor = "com.squareup.okhttp3:logging-interceptor:${Versions.okhttp}"

    const val room_runtime = "androidx.room:room-runtime:${Versions.room}"
    const val room_compiler = "androidx.room:room-compiler:${Versions.room}"
    const val room_ktx = "androidx.room:room-ktx:${Versions.room}"
    const val roomPaging = "androidx.room:room-paging:${Versions.room}"

    const val onesignal = "com.onesignal:OneSignal:${Versions.oneSignal}"
    
    const val swipe_to_refresh = "com.google.accompanist:accompanist-swiperefresh:${Versions.swipe}"

    const val glide = "com.github.bumptech.glide:glide:${Versions.glide}"
    const val glide_skydoves = "com.github.skydoves:landscapist-glide:${Versions.glide_skydoves}"
    const val glide_compiler = "com.github.bumptech.glide:compiler:${Versions.glide}"

    const val dagger_hilt = "com.google.dagger:hilt-android:${Versions.hilt}"
    const val dagger_hilt_compiler = "com.google.dagger:hilt-android-compiler:${Versions.hilt}"
    const val hilt_viewmodel_compiler = "androidx.hilt:hilt-compiler:${Versions.hilt_viewmodel_compiler}"
    const val coil_compose = "io.coil-kt:coil-compose:${Versions.coil}"
    const val coil_svg = "io.coil-kt:coil-svg:${Versions.coil}"
    const val expression = "net.objecthunter:exp4j:${Versions.exp}"
    const val calendar = "io.github.boguszpawlowski.composecalendar:composecalendar:${Versions.calend}"
    const val calendar_date = "io.github.boguszpawlowski.composecalendar:kotlinx-datetime:${Versions.calend}"
    const val paging = "androidx.paging:paging-runtime:${Versions.paging_version}"
    const val pagingCommon = "androidx.paging:paging-common:${Versions.paging_version}"
    const val pagingCompose = "androidx.paging:paging-compose:1.0.0-alpha18"
}
"""
        let dependenciesName = "Dependencies.kt"

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
    
    
}
