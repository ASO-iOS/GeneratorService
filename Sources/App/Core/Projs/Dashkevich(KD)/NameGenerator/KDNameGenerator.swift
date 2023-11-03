//
//  File.swift
//  
//
//  Created by admin on 01.11.2023.
//

import Foundation

struct KDNameGenerator: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import \(packageName).R
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val onSurfaceColor = Color(0xFF\(uiSettings.onSurfaceColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

@Immutable
data class NameGeneratorTypography(
    val header: TextStyle = TextStyle(
        fontWeight = FontWeight.Bold,
        fontFamily = FontFamily(Font(R.font.roboto_bold)),
        fontSize = 24.sp,
        lineHeight = 24.sp
    ),
    val defaultPrimary: TextStyle = TextStyle(
        fontWeight = FontWeight.Bold,
        fontFamily = FontFamily(Font(R.font.roboto_bold)),
        fontSize = 18.sp,
        lineHeight = 18.75.sp,

        ),
    val defaultSecondary: TextStyle = TextStyle(
        fontWeight = FontWeight.Medium,
        fontFamily = FontFamily(Font(R.font.roboto_medium)),
        fontSize = 16.sp,
        lineHeight = 16.sp
    ),
    val defaultTernary: TextStyle = TextStyle(
        fontWeight = FontWeight.Medium,
        fontFamily = FontFamily(Font(R.font.roboto_medium)),
        fontSize = 14.sp,
        lineHeight = 16.41.sp
    ),
    val text: TextStyle = TextStyle(
        fontWeight = FontWeight.Medium,
        fontFamily = FontFamily(Font(R.font.roboto_medium)),
        fontSize = 16.sp,
        lineHeight = 24.sp
    )
)

class NameGeneratorShapes()


private val typography = NameGeneratorTypography()
private val shapes = NameGeneratorShapes()

object NameGeneratorTheme {


    val typography: NameGeneratorTypography
        @Composable
        @ReadOnlyComposable
        get() = localTypography.current

    val shapes: NameGeneratorShapes
        @Composable
        @ReadOnlyComposable
        get() = localShapes.current
}

private val localTypography = staticCompositionLocalOf<NameGeneratorTypography> {
    error("")
}
private val localShapes = staticCompositionLocalOf<NameGeneratorShapes> {
    error("")
}

@Composable
fun NameGeneratorTheme(isDark: Boolean = isSystemInDarkTheme(), content: @Composable () -> Unit) {


    CompositionLocalProvider(
        localTypography provides typography,
        localShapes provides shapes
    ) {
        content()
    }
}


const val GENERATOR = "generator"

public fun getRandomName(): String {
    val name = names.random()
    names.remove(name)
    return name
}

val names = mutableSetOf<String>(
    "Август",
    "Августин",
    "Авраам",
    "Аврора",
    "Агата",
    "Агафон",
    "Агнесса",
    "Агния",
    "Ада",
    "Аделаида",
    "Аделина",
    "Адонис",
    "Акайо",
    "Акулина",
    "Алан",
    "Алевтина",
    "Александр",
    "Александра",
    "Алексей",
    "Алена",
    "Алина",
    "Алиса",
    "Алла",
    "Алсу",
    "Альберт",
    "Альбина",
    "Альфия",
    "Альфред",
    "Амалия",
    "Амелия",
    "Анастасий",
    "Анастасия",
    "Анатолий",
    "Ангелина",
    "Андрей",
    "Анжела",
    "Анжелика",
    "Анисий",
    "Анна",
    "Антон",
    "Антонина",
    "Анфиса",
    "Аполлинарий",
    "Аполлон",
    "Ариадна",
    "Арина",
    "Аристарх",
    "Аркадий",
    "Арсен",
    "Арсений",
    "Артем",
    "Артемий",
    "Артур",
    "Архип",
    "Ася",
    "Беатрис",
    "Белла",
    "Бенедикт",
    "Берта",
    "Богдан",
    "Божена",
    "Болеслав",
    "Борис",
    "Борислав",
    "Бронислав",
    "Бронислава",
    "Булат",
    "Вадим",
    "Валентин",
    "Валентина",
    "Валерий",
    "Валерия",
    "Ванда",
    "Варвара",
    "Василий",
    "Василиса",
    "Венера",
    "Вениамин",
    "Вера",
    "Вероника",
    "Викентий",
    "Виктор",
    "Виктория",
    "Вилен",
    "Виолетта",
    "Виссарион",
    "Вита",
    "Виталий",
    "Влад",
    "Владимир",
    "Владислав",
    "Владислава",
    "Владлен",
    "Вольдемар",
    "Всеволод",
    "Вячеслав",
    "Габриэлла",
    "Гавриил",
    "Галина",
    "Гарри",
    "Гелла",
    "Геннадий",
    "Генриетта",
    "Георгий",
    "Герман",
    "Гертруда",
    "Глафира",
    "Глеб",
    "Глория",
    "Гордей",
    "Грейс",
    "Грета",
    "Григорий",
    "Гульмира",
    "Давид",
    "Дана",
    "Даниил",
    "Даниэла",
    "Дарина",
    "Дарья",
    "Даяна",
    "Демьян",
    "Денис",
    "Джеймс",
    "Джек",
    "Джессика",
    "Джозеф",
    "Диана",
    "Дина",
    "Динара",
    "Дмитрий",
    "Добрыня",
    "Доминика",
    "Дора",
    "Иван",
    "Иветта",
    "Игнатий",
    "Игорь",
    "Изабелла",
    "Изольда",
    "Илга",
    "Илларион",
    "Илона",
    "Илья",
    "Инга",
    "Инесса",
    "Инна",
    "Иннокентий",
    "Иосиф",
    "Ираида",
    "Ираклий",
    "Ирина",
    "Итан",
    "Ия",
    "Казимир",
    "Калерия",
    "Камилла",
    "Камиль",
    "Капитолина",
    "Карина",
    "Каролина",
    "Касьян",
    "Ким",
    "Кир",
    "Кира",
    "Кирилл",
    "Клавдия",
    "Клара",
    "Клариса",
    "Клим",
    "Климент",
    "Кондрат",
    "Константин",
    "Кристина",
    "Ксения",
    "Кузьма",
    "Магдалина",
    "Майя",
    "Макар",
    "Максим",
    "Марат",
    "Маргарита",
    "Марианна",
    "Марина",
    "Мария",
    "Марк",
    "Марта",
    "Мартин",
    "Марфа",
    "Матвей",
    "Мелания",
    "Мелисса",
    "Милана",
    "Милена",
    "Мирон",
    "Мирослава",
    "Мирра",
    "Митрофан",
    "Михаил",
    "Мия",
    "Модест",
    "Моисей",
    "Мухаммед",
    "адежда",
    "Назар",
    "Наоми",
    "Наталия",
    "Наталья",
    "Наум",
    "Нелли",
    "Ника",
    "Никанор",
    "Никита",
    "Никифор",
    "Николай",
    "Николь",
    "Никон",
    "Нина",
    "Нинель",
    "Нонна",
    "Нора",
    "Рада",
    "Радмила",
    "Раиса",
    "Райан",
    "Раймонд",
    "Раяна",
    "Регина",
    "Ренат",
    "Рената",
    "Рику",
    "Римма",
    "Ринат",
    "Рита",
    "Роберт",
    "Родион",
    "Роза",
    "Роксана",
    "Роман",
    "Россияна",
    "Ростислав",
    "Руслан",
    "Рустам",
    "Рэн",
    "Сабина",
    "Савва",
    "Савелий",
    "Саки",
    "Сакура",
    "Самсон",
    "Самуил",
    "Сарра",
    "Светлана",
    "Святослав",
    "Севастьян",
    "Семен",
    "Серафима",
    "Сергей",
    "Сильвия",
    "Снежана",
    "Сора",
    "София",
    "Софья",
    "Станислав",
    "Стелла",
    "Степан",
    "Стефания",
    "Таисия",
    "Такеши",
    "Тамара",
    "Тамила",
    "Тарас",
    "Татьяна",
    "Теодор",
    "Тереза",
    "Терентий",
    "Тимофей",
    "Тимур",
    "Тина",
    "Тихон",
    "Томас",
    "Трофим",
    "Фаддей",
    "Фаина",
    "Федор",
    "Федот",
    "Феликс",
    "Филат",
    "Филимон",
    "Филипп",
    "Фома",
    "Фрида",
    "Эдгар",
    "Эдита",
    "Эдуард",
    "Элеонора",
    "Элина",
    "Элла",
    "Эльвира",
    "Эльдар",
    "Эльза",
    "Эмили",
    "Эмилия",
    "Эмма",
    "Эрик",
    "Эрика"
)

abstract class MVIViewModel<State, Event, Effect>() : ViewModel() {

    private val stateValue by lazy {
        initState()
    }

    abstract fun initState(): State
    abstract fun handleEvent(event: Event)

    private val _viewState = MutableStateFlow<State>(stateValue)
    val viewState: StateFlow<State> = _viewState

    private val _effect = Channel<Effect>()
    val effect = _effect.receiveAsFlow()

    protected fun setState(provideState: State.() -> State) {
        _viewState.value = viewState.value.provideState()
    }

    protected fun setEffect(builder: () -> Effect) {
        val effectValue = builder()
        viewModelScope.launch { _effect.send(effectValue) }
    }


}


sealed interface ScreenState {
    object Loading : ScreenState
    object Success : ScreenState
    object Error : ScreenState
    object None : ScreenState
}


class Generator {


    sealed interface Event {
        object ClickGenerateButton : Event
    }

    data class State(
        val screenState: ScreenState = ScreenState.None,
        val name: String = ""
    )

    sealed class Effect {

    }

}


@HiltViewModel
internal class GeneratorViewModel @Inject constructor() :
    MVIViewModel<Generator.State, Generator.Event, Generator.Effect>() {
    override fun initState(): Generator.State = Generator.State()

    override fun handleEvent(event: Generator.Event) {
        when (event) {
            Generator.Event.ClickGenerateButton -> {
                loadName()
            }

            else -> {}
        }
    }

    private fun loadName() = viewModelScope.launch {
        setState {
            copy(screenState = ScreenState.Loading)
        }
        delay(500)
        setState {
            copy(screenState = ScreenState.Success, name = getRandomName())
        }
    }

}


@Composable
fun GeneratorDest(navController: NavController) {
    val generatorViewModel: GeneratorViewModel = hiltViewModel()
    val viewState = generatorViewModel.viewState.collectAsState().value
    GeneratorScreen(
        state = viewState,
        onSendEvent = { event ->
            generatorViewModel.handleEvent(event)
        }
    )
}


@Composable
fun GeneratorScreen(
    state: Generator.State,
    onSendEvent: (event: Generator.Event) -> Unit,
) {
    Scaffold() {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary)
                .padding(it)
                .padding(horizontal = 16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                modifier = Modifier.align(Alignment.CenterHorizontally),
                text = stringResource(R.string.app_name),
                color = primaryColor,
                style = NameGeneratorTheme.typography.header,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(20.dp))
            GeneratorContent(state.screenState, state.name)
            Spacer(modifier = Modifier.height(20.dp))
            Button(
                modifier = Modifier
                    .height(60.dp)
                    .fillMaxWidth(0.8f),
                onClick = {
                    onSendEvent(Generator.Event.ClickGenerateButton)
                }, colors = ButtonDefaults.buttonColors(buttonColorPrimary)
            ) {
                Text(
                    modifier = Modifier,
                    text = stringResource(R.string.Generate),
                    color = buttonTextColorPrimary,
                    style = NameGeneratorTheme.typography.defaultPrimary,
                    textAlign = TextAlign.Center
                )
                Icon(
                    modifier = Modifier.size(24.dp),
                    painter = painterResource(id = R.drawable.generator),
                    contentDescription = null,
                    tint = buttonTextColorPrimary
                )
            }
        }
    }
}

@Composable
fun GeneratorContent(screenState: ScreenState, fullName: String) {
    when (screenState) {
        ScreenState.Error -> {}
        ScreenState.Loading -> {
            CircularProgressIndicator(
                modifier = Modifier.size(40.dp),
                strokeWidth = 4.dp,
                color = onSurfaceColor
            )
        }

        ScreenState.None -> {}
        ScreenState.Success -> {
            Text(
                text = fullName,
                style = NameGeneratorTheme.typography.defaultPrimary,
                color = textColorPrimary
            )
        }
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: """
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
""",
                content: """
    NameGeneratorTheme() {
        val navController: NavHostController = rememberNavController()

        NavHost(navController = navController, startDestination = GENERATOR) {
            composable(GENERATOR) { GeneratorDest(navController) }
        }
    }
"""
            ),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: ANDStringsData(additional: """
        <string name="Generate">Сгенерировать</string>
        """),
            colorsData: .empty
        )
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
            signingConfig signingConfigs.debug
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
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
