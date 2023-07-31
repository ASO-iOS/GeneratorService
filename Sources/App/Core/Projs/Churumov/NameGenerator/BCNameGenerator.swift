//
//  File.swift
//  
//
//  Created by admin on 31.07.2023.
//

import Foundation

struct BCNameGenerator: FileProviderProtocol {
    static var fileName: String = "BCNameGenerator.kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings, applicationName: String) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Chip
import androidx.compose.material.ChipDefaults
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.SnackbarDuration
import androidx.compose.material.SnackbarHost
import androidx.compose.material.SnackbarHostState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.CopyAll
import androidx.compose.material.icons.outlined.CopyAll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import \(packageName).R
import \(packageName).application.\(applicationName)
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import java.io.IOException
import java.io.Serializable
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.random.Random


val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))
val textColorSecondary = Color(0xFF\(uiSettings.textColorSecondary ?? "FFFFFF"))
val buttonColorPrimary = Color(0xFF\(uiSettings.buttonColorPrimary ?? "FFFFFF"))
val buttonTextColorPrimary = Color(0xFF\(uiSettings.buttonTextColorPrimary ?? "FFFFFF"))
val surfaceColor = Color(0xFF\(uiSettings.surfaceColor ?? "FFFFFF"))


typealias OnNavigateClick = () -> Unit

@Composable
fun NamesGenerator() {
    val navController = rememberNavController()
    NavHost(navController = navController, startDestination = Screen.MainScreen.route) {
        composable(route = Screen.MainScreen.route) {
            SetupScreen(navController = navController)
        }
        composable(
            route = Screen.GeneratorScreen.route + "/{limit}/{format}/{gender}",
            arguments = listOf(
                navArgument("limit") {
                    type = NavType.IntType
                    defaultValue = 0
                    nullable = false
                },
                navArgument("format") {
                    type = NavType.StringType
                    defaultValue = InitialsFormat.FIRSTNAME_AND_LASTNAME.toString()
                    nullable = false
                },
                navArgument("gender") {
                    type = NavType.StringType
                    defaultValue = Gender.ANY.toString()
                    nullable = false
                },
            )
        ) { entry ->
            GeneratorScreen(
                limit = entry.arguments?.getInt("limit") ?: 0,

                format = InitialsFormat.valueOf(
                    entry.arguments?.getString("format")
                        ?: InitialsFormat.FIRSTNAME_AND_LASTNAME.toString()
                ),

                gender = Gender.valueOf(
                    entry.arguments?.getString("gender")
                        ?: Gender.ANY.toString()
                ),

                navController = navController
            )
        }
    }
}

sealed class Screen(val route: String) {
    object MainScreen : Screen("main_screen")
    object GeneratorScreen : Screen("generator_screen")

    fun withArgs(vararg args: String): String {
        return buildString {
            append(route)
            args.forEach { arg -> append("/$arg") }
        }
    }
}

sealed class Resource<T>(val data: T? = null, val message: String? = null) {
    class Success<T>(data: T) : Resource<T>(data)
    class Error<T>(message: String, data: T? = null) : Resource<T>(data, message)
    class Loading<T>(data: T? = null) : Resource<T>(data)
}

class InitialsListState(
    val isLoading: Boolean = false,
    val initials: List<Initials> = emptyList(),
    val error: String = ""
) {}

@HiltViewModel
class InitialsViewModel @Inject constructor(
    private val getInitialsUseCase: GetInitialsUseCase
) : ViewModel() {

    private val _initialsState = mutableStateOf(InitialsListState())
    val initialsState: State<InitialsListState> = _initialsState

    fun getInitials(limit: Int, format: InitialsFormat, gender: Gender) {
        getInitialsUseCase(limit, format, gender).onEach { result ->
            when (result) {
                is Resource.Success<*> -> {
                    _initialsState.value = InitialsListState(initials = result.data ?: emptyList())
                }

                is Resource.Loading -> {
                    _initialsState.value = InitialsListState(isLoading = true)
                }

                is Resource.Error -> {
                    _initialsState.value = InitialsListState(
                        error = result.message ?: "An unexpected error occurred"
                    )
                }
            }
        }.launchIn(viewModelScope)
    }
}


@Composable
fun GeneratorScreen(
    limit: Int = 0,
    format: InitialsFormat = InitialsFormat.FIRSTNAME_AND_LASTNAME,
    gender: Gender = Gender.ANY,
    navController: NavController,
    viewModel: InitialsViewModel = hiltViewModel()
) {

    val state = viewModel.initialsState.value

    val coroutineScope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }

    val context = LocalContext.current

    Scaffold(
        snackbarHost = { SnackbarHost(snackbarHostState) },
        topBar = {
            TopBar(
                format = format,
                onCopyClick = {
                    val clipboardManager =
                        context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                    val clipData: ClipData = ClipData.newPlainText(
                        context.getString(R.string.label_copy),
                        state.initials.toString()
                    )

                    clipboardManager.setPrimaryClip(clipData)
                    coroutineScope.launch {
                        snackbarHostState.showSnackbar(
                            message = context.resources.getString(R.string.copied_to_clipboard),
                            duration = SnackbarDuration.Short
                        )
                    }
                }
            ) { navController.navigate(Screen.MainScreen.route) }
        },
        content = { innerPadding ->
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(backColorPrimary)
            ) {
                LazyColumn(
                    contentPadding = innerPadding
                ) {
                    if (state.initials.isEmpty()) {
                        viewModel.getInitials(limit, format, gender)
                    }
                    items(state.initials) { item: Initials ->
                        InitialsItem(item) {
                            coroutineScope.launch {
                                snackbarHostState.showSnackbar(
                                    message = context.resources.getString(R.string.copied_to_clipboard),
                                    duration = SnackbarDuration.Short
                                )
                            }
                        }
                    }
                }
                if (state.isLoading) {
                    CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
                }
            }
        }
    )
}

@Composable
@OptIn(ExperimentalMaterial3Api::class)
private fun TopBar(
    format: InitialsFormat,
    onCopyClick: () -> Unit,
    onNavigateClick: OnNavigateClick
) {

    TopAppBar(
        title = {
            Text(
                text = "${stringResource(id = R.string.names_list)} ${format.label}",
                fontSize = 18.sp
            )
        },
        navigationIcon = {
            IconButton(onClick = onNavigateClick) {
                Icon(
                    imageVector = Icons.Filled.ArrowBack,
                    contentDescription = "Back",
                    tint = surfaceColor
                )
            }
        },
        colors = TopAppBarDefaults.topAppBarColors(containerColor = backColorPrimary),
        actions = {
            IconButton(onClick = {
                onCopyClick()
            }) {
                Icon(
                    imageVector = Icons.Outlined.CopyAll, contentDescription = null,
                    tint = surfaceColor
                )
            }
        }
    )
}

@Composable
fun InitialsItem(item: Initials, onCopyClick: () -> Unit) {

    val context = LocalContext.current

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceAround
    ) {
        Row(Modifier.fillMaxWidth(0.8f)) {
            Text(
                text = item.firstname,
                fontSize = 22.sp,
                color = surfaceColor
            )
            Text(
                text = item.lastName,
                modifier = Modifier.padding(horizontal = 4.dp),
                fontSize = 22.sp,
                color = surfaceColor
            )
        }
        IconButton(
            onClick = {
                val clipboardManager =
                    context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                val clipData: ClipData = ClipData.newPlainText("сopy", item.toString())

                clipboardManager.setPrimaryClip(clipData)
                onCopyClick()
            }
        ) {
            Icon(
                imageVector = Icons.Filled.CopyAll,
                contentDescription = "",
                tint = surfaceColor
            )
        }
    }
}


enum class Gender(val label: String) : Serializable {
    MALE(\(applicationName).context?.getString(R.string.gender_male) ?: ""),
    FEMALE(\(applicationName).context?.getString(R.string.gender_female) ?: ""),
    ANY(\(applicationName).context?.getString(R.string.gender_any) ?: "")
}

data class Initials(
    val firstname: String, val lastName: String
) {
    override fun toString(): String {
        return "$firstname $lastName"
    }
}

enum class InitialsFormat(val label: String) {
    ONLY_FIRSTNAME(\(applicationName).context?.getString(R.string.format_only_firstname) ?: ""),
    ONLY_LASTNAME(\(applicationName).context?.getString(R.string.format_only_lastname) ?: ""),
    FIRSTNAME_AND_LASTNAME(
            \(applicationName).context?.getString(R.string.format_fistname_and_lastname) ?: ""
    )
}

interface InitialsRepository {

    suspend fun getInitials(limit: Int, gender: Gender): List<Initials>

    suspend fun getLastnames(limit: Int, gender: Gender): List<Initials>

    suspend fun getFirstnames(limit: Int, gender: Gender): List<Initials>
}

class GetInitialsUseCase @Inject constructor(
    private val initialsRepository: InitialsRepository
) {
    operator fun invoke(
        limit: Int,
        format: InitialsFormat,
        gender: Gender
    ): Flow<Resource<List<Initials>>> = flow {
        try {
            emit(Resource.Loading<List<Initials>>())
            when (format) {
                InitialsFormat.ONLY_FIRSTNAME -> {
                    val initials = initialsRepository.getFirstnames(limit, gender)
                    emit(Resource.Success<List<Initials>>(initials))
                }

                InitialsFormat.ONLY_LASTNAME -> {
                    val initials = initialsRepository.getLastnames(limit, gender)
                    emit(Resource.Success<List<Initials>>(initials))
                }

                InitialsFormat.FIRSTNAME_AND_LASTNAME -> {
                    val initials = initialsRepository.getInitials(limit, gender)
                    emit(Resource.Success<List<Initials>>(initials))
                }
            }

        } catch (e: IOException) {
            emit(Resource.Error<List<Initials>>("IOException: Please check your Internet connection"))
        }

    }
}

@Singleton
class InitialsRepositoryImpl @Inject constructor(
    private val service: InitialsService
) : InitialsRepository {


    override suspend fun getInitials(limit: Int, gender: Gender): List<Initials> {
        return service.getInitials(limit, gender)
    }

    override suspend fun getLastnames(limit: Int, gender: Gender): List<Initials> {
        return service.getLastnames(limit, gender)
    }

    override suspend fun getFirstnames(limit: Int, gender: Gender): List<Initials> {
        return service.getFirstnames(limit, gender)
    }
}

@Composable
fun SetupScreen(navController: NavController) {

    var limit by remember { mutableStateOf(0) }

    var gender by remember { mutableStateOf(Gender.ANY) }

    var initialsFormat by remember { mutableStateOf(InitialsFormat.FIRSTNAME_AND_LASTNAME) }

    val coroutineScope = rememberCoroutineScope()
    val scaffoldState = remember { SnackbarHostState() }

    val context = LocalContext.current

    Scaffold(modifier = Modifier, snackbarHost = { SnackbarHost(scaffoldState) }) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(backColorPrimary)
                .padding(
                    top = it
                        .calculateTopPadding()
                        .plus(8.dp)
                ),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = stringResource(id = R.string.generator_of_first_and_lastnames),
                fontSize = 24.sp,
                fontWeight = FontWeight.W700,
                color = textColorSecondary,
                modifier = Modifier.padding(8.dp)
            )

            Text(
                text = stringResource(id = R.string.with_freq),
                fontSize = 16.sp,
                fontWeight = FontWeight.W500,
                color = textColorSecondary,
                modifier = Modifier.padding(vertical = 16.dp, horizontal = 8.dp)
            )

            FormatExposedDropdownMenu { initialsFormat = it.value }

            GenderExposedDropdownMenu { gender = it.value }

            LabelText(stringResourceId = R.string.count)

            OutlinedTextField(
                value = if (limit == 0) "" else limit.toString(),
                modifier = Modifier
                    .padding(horizontal = 12.dp)
                    .fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                label = {
                    Text(
                        text = stringResource(id = R.string.input_count),
                        color = surfaceColor
                    )
                },
                onValueChange = {
                    try {
                        limit = it.toInt()
                    } catch (e: NumberFormatException) {
                        limit = 0
                    }
                })

            Button(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 16.dp, horizontal = 12.dp)
                    .height(64.dp), shape = RoundedCornerShape(16.dp),
                colors = ButtonDefaults.buttonColors(containerColor = buttonColorPrimary),
                onClick = {
                    if (limit <= 0) {
                        coroutineScope.launch {
                            scaffoldState.showSnackbar(
                                message = context.resources.getString(R.string.snackbar_message_input_count),
                                duration = SnackbarDuration.Short
                            )
                        }
                    } else {
                        navController.navigate(
                            Screen.GeneratorScreen.withArgs(
                                limit.toString(), initialsFormat.toString(), gender.toString()
                            )
                        )
                    }
                }
            ) {
                Text(
                    text = stringResource(id = R.string.generate),
                    fontSize = 20.sp,
                    color = buttonTextColorPrimary
                )
            }
            UsageChipsLayout(navController = navController)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun GenderExposedDropdownMenu(onClick: (MutableState<Gender>) -> Unit) {

    var genderIsExpanded by remember {
        mutableStateOf(false)
    }

    val gender = remember { mutableStateOf(Gender.ANY) }

    LabelText(stringResourceId = R.string.format)

    ExposedDropdownMenuBox(expanded = genderIsExpanded,
        modifier = Modifier.padding(horizontal = 12.dp),
        onExpandedChange = { genderIsExpanded = it }) {
        TextField(
            value = gender.value.label,
            onValueChange = {},
            readOnly = true,
            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = genderIsExpanded) },
            colors = ExposedDropdownMenuDefaults.textFieldColors(
                focusedIndicatorColor = Color.Transparent,
                unfocusedIndicatorColor = Color.Transparent,
                focusedTextColor = surfaceColor,
                unfocusedTextColor = surfaceColor,
                focusedLabelColor = surfaceColor
            ),
            shape = RoundedCornerShape(16.dp),
            modifier = Modifier
                .menuAnchor()
                .fillMaxWidth()
        )
        DropdownMenu(
            expanded = genderIsExpanded,
            modifier = Modifier,
            onDismissRequest = { genderIsExpanded = false }) {
            DropdownMenuItem(text = { Text(text = Gender.ANY.label, color = surfaceColor) },
                onClick = {
                    genderIsExpanded = false
                    gender.value = Gender.ANY
                    onClick(gender)
                }
            )
            DropdownMenuItem(text = { Text(text = Gender.MALE.label, color = surfaceColor) },
                onClick = {
                    genderIsExpanded = false
                    gender.value = Gender.MALE
                    onClick(gender)
                }
            )
            DropdownMenuItem(text = { Text(text = Gender.FEMALE.label, color = surfaceColor) },
                onClick = {
                    genderIsExpanded = false
                    gender.value = Gender.FEMALE
                    onClick(gender)
                }
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FormatExposedDropdownMenu(onClick: (MutableState<InitialsFormat>) -> Unit) {

    var formatIsExpanded by remember {
        mutableStateOf(false)
    }

    val initialsFormat = remember {
        mutableStateOf(InitialsFormat.FIRSTNAME_AND_LASTNAME)
    }

    LabelText(stringResourceId = R.string.gender)

    ExposedDropdownMenuBox(expanded = formatIsExpanded,
        modifier = Modifier.padding(vertical = 4.dp, horizontal = 12.dp),
        onExpandedChange = { formatIsExpanded = it }) {

        TextField(
            value = initialsFormat.value.label,
            onValueChange = {},
            readOnly = true,
            trailingIcon = {
                ExposedDropdownMenuDefaults.TrailingIcon(expanded = formatIsExpanded)
            },
            colors = ExposedDropdownMenuDefaults.textFieldColors(
                focusedIndicatorColor = Color.Transparent,
                unfocusedIndicatorColor = Color.Transparent,
                focusedTextColor = surfaceColor,
                unfocusedTextColor = surfaceColor,
                focusedLabelColor = surfaceColor
            ),
            shape = RoundedCornerShape(16.dp),
            modifier = Modifier
                .menuAnchor()
                .fillMaxWidth()
        )

        DropdownMenu(expanded = formatIsExpanded, onDismissRequest = { formatIsExpanded = false }) {
            DropdownMenuItem(text = {
                Text(
                    text = InitialsFormat.FIRSTNAME_AND_LASTNAME.label,
                    color = surfaceColor
                )
            },
                onClick = {
                    formatIsExpanded = false
                    initialsFormat.value = InitialsFormat.FIRSTNAME_AND_LASTNAME
                    onClick(initialsFormat)
                })
            DropdownMenuItem(text = {
                Text(
                    text = InitialsFormat.ONLY_LASTNAME.label,
                    color = surfaceColor
                )
            }, onClick = {
                formatIsExpanded = false
                initialsFormat.value = InitialsFormat.ONLY_LASTNAME
                onClick(initialsFormat)
            })
            DropdownMenuItem(text = {
                Text(
                    text = InitialsFormat.ONLY_FIRSTNAME.label,
                    color = surfaceColor
                )
            },
                onClick = {
                    formatIsExpanded = false
                    initialsFormat.value = InitialsFormat.ONLY_FIRSTNAME
                    onClick(initialsFormat)
                })
        }
    }

}

@OptIn(ExperimentalLayoutApi::class)
@Composable
fun UsageChipsLayout(navController: NavController) {
    LabelText(stringResourceId = R.string.variants_of_usage)
    FlowRow(
        modifier = Modifier.padding(8.dp)
    ) {
        QuickSetChip(title = stringResource(id = R.string.hundred_random_initials)) {
            navController.navigate(
                Screen.GeneratorScreen.withArgs(
                    "100", InitialsFormat.FIRSTNAME_AND_LASTNAME.toString(), Gender.ANY.toString()
                )
            )
        }
        QuickSetChip(title = stringResource(id = R.string.fifty_popular_women_names)) {
            navController.navigate(
                Screen.GeneratorScreen.withArgs(
                    "50", InitialsFormat.ONLY_FIRSTNAME.toString(), Gender.FEMALE.toString()
                )
            )
        }
        QuickSetChip(title = stringResource(id = R.string.thirty_popular_men_lastnames)) {
            navController.navigate(
                Screen.GeneratorScreen.withArgs(
                    "30", InitialsFormat.ONLY_LASTNAME.toString(), Gender.MALE.toString()
                )
            )
        }
    }
}

@OptIn(ExperimentalMaterialApi::class)
@Composable
fun QuickSetChip(title: String, onNavigateClick: OnNavigateClick) {
    Chip(
        shape = RoundedCornerShape(16.dp), colors = ChipDefaults.outlinedChipColors(
            backgroundColor = buttonColorPrimary
        ), onClick = onNavigateClick
    ) {
        Text(text = title, color = buttonTextColorPrimary)
    }
}

@Composable
fun LabelText(stringResourceId: Int) {
    Text(
        text = stringResource(id = stringResourceId),
        color = textColorSecondary,
        modifier = Modifier.padding(horizontal = 8.dp)
    )
}

@Module
@InstallIn(SingletonComponent::class)
object AppModule {
    @Provides
    @Singleton
    fun provideInitialsService(): InitialsService = InitialsService()

    @Provides
    @Singleton
    fun provideInitialsRepository(initialsService: InitialsService): InitialsRepository {
        return InitialsRepositoryImpl(initialsService)
    }
}

@Singleton
class InitialsService {

    fun getInitials(limit: Int, gender: Gender): List<Initials> {
        val initials = mutableListOf<Initials>()

        when (gender) {
            Gender.ANY -> {
                generateInitialsForAnyGender(limit, initials)
            }

            Gender.FEMALE -> {
                generateInitialsForFemale(limit, initials)
            }

            Gender.MALE -> {
                generateInitialsForMale(limit, initials)
            }
        }
        return initials
    }

    fun getLastnames(limit: Int, gender: Gender): List<Initials> {

        val initials = mutableListOf<Initials>()
        var allowedMaximum = limit
        if (limit >= LASTNAMES_FEMALE.size) allowedMaximum = LASTNAMES_FEMALE.size
        when (gender) {
            Gender.ANY -> {
                for (i in 0 until allowedMaximum) {
                    if (Random.nextInt(2) == 0) {
                        initials.add(Initials(firstname = "", lastName = LASTNAMES_MALE[i]))
                    } else {
                        initials.add(Initials(firstname = "", lastName = LASTNAMES_FEMALE[i]))
                    }
                }
            }

            Gender.MALE -> {
                for (i in 0 until allowedMaximum) {
                    initials.add(Initials(firstname = "", lastName = LASTNAMES_MALE[i]))
                }
            }

            Gender.FEMALE -> {
                for (i in 0 until allowedMaximum) {
                    initials.add(Initials(firstname = "", lastName = LASTNAMES_FEMALE[i]))
                }
            }
        }
        return initials
    }

    fun getFirstnames(limit: Int, gender: Gender): List<Initials> {
        val initials = mutableListOf<Initials>()
        var allowedMaximum = limit
        when (gender) {
            Gender.ANY -> {
                generateFirstNamesForAnyGender(allowedMaximum, initials)
            }

            Gender.MALE -> {
                if (limit >= FIRSTNAMES_MALE.size) allowedMaximum = FIRSTNAMES_MALE.size - 1
                for (i in 0 until allowedMaximum) {
                    initials.add(Initials(firstname = FIRSTNAMES_MALE[i], lastName = ""))
                }
            }

            Gender.FEMALE -> {
                if (limit >= FIRSTNAMES_FEMALE.size) allowedMaximum = FIRSTNAMES_FEMALE.size - 1
                for (i in 0 until allowedMaximum) {
                    initials.add(Initials(firstname = FIRSTNAMES_FEMALE[i], lastName = ""))
                }
            }
        }
        return initials
    }

    private fun generateFirstNamesForAnyGender(
        allowedMaximum: Int,
        initials: MutableList<Initials>
    ) {
        val initialsSet = mutableSetOf<Initials>()
        repeat(allowedMaximum) {
            if (Random.nextInt(2) == 0) {
                initialsSet.add(
                    Initials(
                        firstname = FIRSTNAMES_MALE[Random.nextInt(
                            FIRSTNAMES_MALE.size
                        )], lastName = ""
                    )
                )
            } else {
                initialsSet.add(
                    Initials(
                        firstname = FIRSTNAMES_FEMALE[Random.nextInt(
                            FIRSTNAMES_FEMALE.size
                        )],
                        lastName = ""
                    )
                )
            }
        }
        initials.addAll(initialsSet)
    }

    private fun generateInitialsForMale(
        limit: Int,
        initials: MutableList<Initials>
    ) {
        for (i in 0 until limit) {
            initials.add(
                Initials(
                    firstname = FIRSTNAMES_MALE[Random.nextInt(FIRSTNAMES_MALE.size)],
                    lastName = LASTNAMES_MALE[Random.nextInt(LASTNAMES_MALE.size)]
                )
            )
        }
    }

    private fun generateInitialsForFemale(
        limit: Int,
        initials: MutableList<Initials>
    ) {
        for (i in 0 until limit) {
            initials.add(
                Initials(
                    firstname = FIRSTNAMES_FEMALE[Random.nextInt(FIRSTNAMES_FEMALE.size)],
                    lastName = LASTNAMES_FEMALE[Random.nextInt(LASTNAMES_FEMALE.size)]
                )
            )
        }
    }

    private fun generateInitialsForAnyGender(
        limit: Int,
        initials: MutableList<Initials>
    ) {
        for (i in 0 until limit) {
            if (Random.nextInt(2) == 0) {
                initials.add(
                    Initials(
                        firstname = FIRSTNAMES_FEMALE[Random.nextInt(FIRSTNAMES_FEMALE.size)],
                        lastName = LASTNAMES_FEMALE[Random.nextInt(LASTNAMES_FEMALE.size)]
                    )
                )
            } else {
                initials.add(
                    Initials(
                        firstname = FIRSTNAMES_MALE[Random.nextInt(FIRSTNAMES_MALE.size)],
                        lastName = LASTNAMES_MALE[Random.nextInt(LASTNAMES_MALE.size)]
                    )
                )
            }
        }
    }

    companion object {
        private val FIRSTNAMES_MALE = listOf(
            "Александр",
            "Максим",
            "Артём",
            "Даниил",
            "Иван",
            "Михаил",
            "Кирилл",
            "Дмитрий",
            "Никита",
            "Андрей",
            "Сергей",
            "Антон",
            "Егор",
            "Илья",
            "Владимир",
            "Глеб",
            "Павел",
            "Роман",
            "Владислав",
            "Ярослав",
            "Тимофей",
            "Степан",
            "Виктор",
            "Василий",
            "Олег",
            "Арсений",
            "Николай",
            "Евгений",
            "Богдан",
            "Григорий",
            "Лев",
            "Артур",
            "Матвей",
            "Руслан",
            "Денис",
            "Давид",
            "Данил",
            "Юрий",
            "Юлий",
            "Константин",
            "Семен",
            "Валентин",
            "Фёдор",
            "Родион",
            "Вячеслав",
            "Петр",
            "Игорь",
            "Марк",
            "Георгий",
            "Захар",
            "Роберт",
            "Алексей",
            "Виталий"
        )
        private val LASTNAMES_MALE = listOf<String>(
            "Иванов",
            "Васильев",
            "Петров",
            "Смирнов",
            "Михайлов",
            "Фёдоров",
            "Соколов",
            "Яковлев",
            "Попов",
            "Андреев",
            "Алексеев",
            "Александров",
            "Лебедев",
            "Григорьев",
            "Степанов",
            "Семёнов",
            "Павлов",
            "Богданов",
            "Николаев",
            "Дмитриев",
            "Егоров",
            "Волков",
            "Кузнецов",
            "Никитин",
            "Соловьёв",
            "Тимофеев",
            "Орлов",
            "Афанасьев",
            "Филиппов",
            "Сергеев",
            "Захаров",
            "Матвеев",
            "Виноградов",
            "Кузьмин",
            "Максимов",
            "Козлов",
            "Ильин",
            "Герасимов",
            "Марков",
            "Новиков",
            "Морозов",
            "Романов",
            "Осипов",
            "Макаров",
            "Зайцев",
            "Беляев",
            "Гаврилов",
            "Антонов",
            "Ефимов",
            "Леонтьев",
            "Давыдов",
            "Гусев",
            "Данилов",
            "Киселёв",
            "Сорокин",
            "Тихомиров",
            "Крылов",
            "Никифоров",
            "Кондратьев",
            "Кудрявцев",
            "Борисов",
            "Жуков",
            "Воробьёв",
            "Щербаков",
            "Поляков",
            "Савельев",
            "Шмидт",
            "Трофимов",
            "Чистяков",
            "Баранов",
            "Сидоров",
            "Соболев",
            "Карпов",
            "Белов",
            "Миллер",
            "Титов",
            "Львов",
            "Фролов",
            "Игнатьев",
            "Комаров",
            "Прокофьев",
            "Быков",
            "Абрамов",
            "Голубев",
            "Пономарёв",
            "Покровский",
            "Мартынов",
            "Кириллов",
            "Шульц",
            "Миронов",
            "Фомин",
            "Власов",
            "Троицкий",
            "Федотов",
            "Назаров",
            "Ушаков",
            "Денисов",
            "Константинов",
            "Воронин",
            "Наумов"
        )
        private val FIRSTNAMES_FEMALE = listOf(
            "Анна",
            "Мария",
            "Дарья",
            "Анастасия",
            "Елизавета",
            "София",
            "Виктория",
            "Александра",
            "Алиса",
            "Полина",
            "Екатерина",
            "Валерия",
            "Ксения",
            "Арина",
            "Варвара",
            "Алина",
            "Милана",
            "Кристина",
            "Ольга",
            "Василиса",
            "Евгения",
            "Юлия",
            "Любовь",
            "Елена",
            "Ангелина",
            "Наталья",
            "Марина",
            "Алёна",
            "Диана",
            "Татьяна",
            "Ирина",
            "Ника",
            "Маргарита",
            "Светлана",
            "Ева",
            "Софья",
            "Вероника",
            "Виолетта",
            "Мирослава",
            "Анжелика",
            "Злата",
            "Элина",
            "Лилия",
            "Регина",
            "Лидия",
            "Альбина",
            "Влада",
            "Снежана",
            "Маргарита",
            "Рената",
        )
        private val LASTNAMES_FEMALE = listOf<String>(
            "Иванова",
            "Васильева",
            "Петрова",
            "Смирнова",
            "Михайлова",
            "Фёдорова",
            "Соколова",
            "Яковлева",
            "Попова",
            "Андреева",
            "Алексеева",
            "Александрова",
            "Лебедева",
            "Григорьева",
            "Степанова",
            "Семёнова",
            "Павлова",
            "Богданова",
            "Николаева",
            "Дмитриева",
            "Егорова",
            "Волкова",
            "Кузнецова",
            "Никитина",
            "Соловьёва",
            "Тимофеева",
            "Орлова",
            "Афанасьева",
            "Филиппова",
            "Сергеева",
            "Захарова",
            "Матвеева",
            "Виноградова",
            "Кузьмина",
            "Максимова",
            "Козлов",
            "Ильина",
            "Герасимова",
            "Маркова",
            "Новикова",
            "Морозова",
            "Романова",
            "Осипова",
            "Макарова",
            "Зайцева",
            "Беляева",
            "Гаврилова",
            "Антонова",
            "Ефимова",
            "Леонтьева",
            "Давыдова",
            "Гусева",
            "Данилова",
            "Киселёва",
            "Сорокина",
            "Тихомирова",
            "Крылова",
            "Никифорова",
            "Кондратьева",
            "Кудрявцева",
            "Борисова",
            "Жукова",
            "Воробьёва",
            "Щербакова",
            "Полякова",
            "Савельева",
            "Шмидт",
            "Трофимова",
            "Чистякова",
            "Баранова",
            "Сидорова",
            "Соболева",
            "Карпова",
            "Белова",
            "Миллер",
            "Титова",
            "Львова",
            "Фролова",
            "Игнатьева",
            "Комарова",
            "Прокофьева",
            "Быкова",
            "Абрамова",
            "Голубева",
            "Пономарёва",
            "Покровская",
            "Мартынова",
            "Кириллова",
            "Шульц",
            "Миронова",
            "Фомина",
            "Власова",
            "Троицкая",
            "Федотова",
            "Назарова",
            "Ушакова",
            "Денисова",
            "Константинова",
            "Воронина",
            "Наумова"
        )
    }
}
"""
    }
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return ""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(mainFragmentData: ANDMainFragment(imports: "", content: """
NamesGenerator()
"""), mainActivityData: ANDMainActivity(imports: "", extraFunc: "", content: ""), themesData: ANDThemesData(isDefault: true, content: ""), stringsData: ANDStringsData(additional: """
                    <string name="copied_to_clipboard">Скопировано в буфер обмена</string>
                    <string name="generator_of_first_and_lastnames">Генератор фамилий и имен</string>
                    <string name="with_freq">с учетом реальной частоты их использования в современном мире</string>
                    <string name="count">Количество:</string>
                    <string name="input_count">Введите количество генераций</string>
                    <string name="snackbar_message_input_count">Заполните количество генераций</string>
                    <string name="generate">Сгенерировать</string>
                    <string name="variants_of_usage">Варианты исполользования</string>
                    <string name="hundred_random_initials">100 любый фамилий и имен</string>
                    <string name="fifty_popular_women_names">50 самых популярных женских имен</string>
                    <string name="thirty_popular_men_lastnames">30 самых популярных мужских фамилий</string>
                    <string name="names_list">Список формата:</string>
                    <string name="gender">Пол:</string>
                    <string name="format">Формат:</string>
                    <string name="gender_male">Мужской</string>
                    <string name="gender_female">Женский</string>
                    <string name="gender_any">Любой</string>
                    <string name="format_only_firstname">Только имя</string>
                    <string name="format_only_lastname">Только фамилия</string>
                    <string name="format_fistname_and_lastname">Фамилия и имя</string>
                    <string name="label_copy">copy</string>
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
            signingConfig signingConfigs.debug
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
    const val glide = "4.14.2"
    const val swipe = "0.19.0"
    const val glide_skydoves = "1.3.9"
    const val retrofit = "2.9.0"
    const val okhttp = "4.10.0"
    const val room = "2.5.0"
    const val coil = "2.2.2"
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
    
//    static func gradle(_ packageName: String) -> GradleFilesData {
//        let projectGradle = """
//"""
//        let projectGradleName = "build.gradle"
//        let moduleGradle = """
//"""
//        let moduleGradleName = "build.gradle"
//
//        let dependencies = """
//"""
//        let dependenciesName = "Dependencies.kt"
//
//        return GradleFilesData(
//            projectBuildGradle: GradleFileInfoData(
//                content: projectGradle,
//                name: projectGradleName
//            ),
//            moduleBuildGradle: GradleFileInfoData(
//                content: moduleGradle,
//                name: moduleGradleName
//            ),
//            dependencies: GradleFileInfoData(
//                content: dependencies,
//                name: dependenciesName
//            ))
//    }
    
    
}
