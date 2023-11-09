//
//  File.swift
//  
//
//  Created by admin on 03.11.2023.
//

import Foundation

struct KDNews: FileProviderProtocol {
    static var fileName: String = "\(NamesManager.shared.fileName).kt"
    
    static func fileContent(packageName: String, uiSettings: UISettings) -> String {
        return """
package \(packageName).presentation.fragments.main_fragment

import androidx.compose.runtime.SideEffect
import androidx.compose.ui.res.stringResource
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import \(packageName).R
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import com.google.gson.Gson
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.ui.Alignment
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewModelScope
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.sp
import coil.compose.SubcomposeAsyncImage
import android.content.Context
import androidx.lifecycle.ViewModel
import androidx.paging.cachedIn
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Dispatchers
import java.util.Date
import kotlin.coroutines.CoroutineContext
import androidx.paging.PagingData
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.emptyFlow
import java.text.SimpleDateFormat
import java.util.Locale
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.material3.Divider
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuBoxScope
import androidx.compose.material3.MenuDefaults
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.foundation.layout.Box
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DatePickerDefaults
import androidx.compose.material3.DisplayMode
import androidx.compose.material3.rememberDatePickerState
import androidx.compose.runtime.rememberCoroutineScope
import androidx.paging.LoadState
import androidx.paging.compose.collectAsLazyPagingItems
import kotlinx.coroutines.withContext
import androidx.compose.foundation.layout.width
import androidx.compose.material3.TextButton
import androidx.compose.foundation.layout.wrapContentWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.CircularProgressIndicator
import androidx.paging.compose.LazyPagingItems
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.filled.ArrowBackIosNew
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.annotation.Keep
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.room.Room
import dagger.Binds
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton
import com.google.gson.annotations.SerializedName
import retrofit2.http.GET
import retrofit2.http.Query
import androidx.paging.Pager
import androidx.paging.PagingConfig
import androidx.paging.PagingSource
import androidx.paging.PagingState
import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.Database
import androidx.room.RoomDatabase
import android.net.Uri
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import android.util.Log
import androidx.compose.foundation.shape.RoundedCornerShape
import kotlinx.coroutines.delay
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.toFontFamily

val backColorPrimary = Color(0xFF\(uiSettings.backColorPrimary ?? "FFFFFF"))
val primaryColor = Color(0xFF\(uiSettings.primaryColor ?? "FFFFFF"))
val textColorPrimary = Color(0xFF\(uiSettings.textColorPrimary ?? "FFFFFF"))

val headline1 = TextStyle(
    fontSize = 32.sp,
    fontWeight = FontWeight.Normal,
    fontFamily = Font(R.font.gidugu_regular).toFontFamily(),
)

val headline2 = TextStyle(
    fontSize = 26.sp,
    fontWeight = FontWeight.SemiBold,
    fontFamily = Font(R.font.montserrat_semibold).toFontFamily(),
)

val headline3 = TextStyle(
    fontSize = 18.sp,
    fontWeight = FontWeight.SemiBold,
    fontFamily = Font(R.font.montserrat_bold).toFontFamily(),
    lineHeight = 20.sp
)

val headline4 = TextStyle(
    fontSize = 15.sp,
    fontWeight = FontWeight.SemiBold,
    fontFamily = Font(R.font.montserrat_semibold).toFontFamily(),
)

val headline5 = TextStyle(

)

val headline6 = TextStyle(

)

val smallShape = RoundedCornerShape(12.dp)


const val DEBUG = "AppDebug"

fun Any?.logDebug() {
    if (this is Throwable?) {
        Log.e(DEBUG, toString())
    } else {
        Log.i(DEBUG, toString())
    }
}


object DebugMessage {
    const val LOADING = "Loading"
    const val SUCCESS = "Success: "
    const val ERROR = "Error: "
    const val EMPTY = "Empty"
}

const val SLASH = "----------------------------------------------------------------------"

const val EMPTY_STR = ""

const val ONE_THOUSAND: Short = 1000
fun Int.toStringData(): String = Date(toLong() * ONE_THOUSAND).let { date ->
    val strDate = with(date) {
        "$day:$month:$year"
    }
    return@let strDate
}

fun avgSum(height: Int, width: Int): Double = ((height + width).toDouble() / 2)

suspend inline fun <T> Result<T>.loadAndHandleData(
    haveDebug: Boolean = false,
    onSuccess: (T) -> Unit = {},
    onEmpty: () -> Unit = {},
    onError: (Throwable) -> Unit = {},
    onLoading: () -> Unit = {}
) {
    onLoading()
    delay(200)
    if (haveDebug) {
        SLASH.logDebug()
        DebugMessage.LOADING.logDebug()
    }
    resultHandler(
        onSuccess = { result ->
            if (haveDebug) (DebugMessage.SUCCESS + result).logDebug()
            onSuccess(result)
        },
        onEmpty = {
            if (haveDebug) DebugMessage.EMPTY.logDebug()
            onEmpty()
        },
        onError = { error ->
            if (haveDebug) {
                error.stackTraceToString().logDebug()
            }
            onError(error)
        }
    )
}

inline fun <T> Result<T>.resultHandler(
    onSuccess: (T) -> Unit,
    onError: (Throwable) -> Unit,
    onEmpty: () -> Unit
) {
    onSuccess { value ->
        if (value is Collection<*>) {
            if (value.isEmpty()) onEmpty()
        } else if (value is Map<*, *>) {
            if (value.isEmpty()) onEmpty()
        } else if (value is Array<*>) {
            if (value.isEmpty()) onEmpty()
        } else if (value.toString().isEmpty()) {
            onEmpty()
        } else {
            onSuccess(value)
        }
    }
    onFailure { error ->
        onError(error)
    }
}


abstract class BaseViewModel<State>(initState: State) : ViewModel() {

    private val _viewState: MutableStateFlow<State> = MutableStateFlow(initState)
    val viewState = _viewState.asStateFlow()

    protected val stateValue: State
        get() = viewState.value

    protected fun updateState(changeState: State.() -> State) {
        _viewState.value = viewState.value.changeState()
    }


}

val VKRequest.mapToNewsCluster: NewsCluster
    get() {
        return NewsCluster(
            newsList = response.items.mapToListNews(),
            nextCluster = response.nextFrom ?: ""
        )
    }


fun List<Item>.mapToListNews(): List<News> {
    val news: MutableMap<String, News> = mutableMapOf()
    forEach { item: Item ->
        with(item) {
            val insides = attachments.mapToListInsides()
            val inside = insides.firstOrNull { inside -> inside.imageUrl != "" }
            if (inside != null) {
                news[inside.title] = News(
                    id = id, ownerId = ownerId,
                    date = date.toStringData(), countViewers = 0,
                    insides = insides,
                    text = Uri.encode(item.text ?: "")
                )
            }
        }
    }
    return news.values.distinct()

}

fun Link.toInside(): Inside = Inside(
    title = title,
    description = description,
    imageUrl = photo?.sizes?.max()?.url ?: "",
    audioUrl = EMPTY_STR,
    url = url,
    date = photo?.date?.toStringData() ?: ""
)

fun PhotoX.toInside(): Inside = Inside(
    title = "",
    description = text,
    imageUrl = sizes?.max()?.url ?: "",
    audioUrl = "",
    date = date.toStringData()
)

fun Video.toInside(): Inside = Inside(
    title = title ?: "",
    description = description ?: "",
    imageUrl = image?.max()?.url ?: "",
    audioUrl = "",
    date = date.toStringData() ?: ""
)


fun List<Attachment>?.mapToListInsides(): List<Inside> {
    val insides = mutableListOf<Inside>()
    this?.forEach { attachment: Attachment ->
        with(attachment) {
            if (link != null) {
                insides += link.toInside()
            } else if (photo != null) {
                insides += photo.toInside()
            } else if (video != null) {
                insides += video.toInside()
            }
        }
    }
    return insides.distinct()
}

@Database(entities = [Data::class], version = 1)
abstract class AppDatabase : RoomDatabase() {


}

@Entity
class Data(@PrimaryKey val id: Int = 0)


class RoomRepositoryImpl @Inject constructor(db: AppDatabase) : RoomRepository {


}

class NewsPagingSource(
    val backendQuery: suspend (nextPage: String) -> VKRequest
) : PagingSource<String, News>() {

    override suspend fun load(params: LoadParams<String>): LoadResult<String, News> {
        return try {
            val nextPageKey = params.key ?: ""
            val newsCluster = backendQuery(nextPageKey).mapToNewsCluster
            LoadResult.Page(
                data = newsCluster.newsList,
                prevKey = null,
                nextKey = newsCluster.nextCluster
            )
        } catch (ex: Throwable) {
            LoadResult.Error(ex)
        }
    }

    override fun getRefreshKey(state: PagingState<String, News>): String {
        state.anchorPosition?.let { position ->
            return state.pages[position - 1].nextKey ?: state.pages[position + 1].prevKey ?: ""
        }
        return ""
    }


}

class ApiRepositoryImpl @Inject constructor(private val api: API) : ApiRepository {
    override fun getNews(
        latitude: String, longitude: String,
        startTime: Int, endTime: Int,
        count: Int, searchQuery: String,
        extended: Boolean
    ): Flow<PagingData<News>> =
        Pager(
            config = PagingConfig(
                pageSize = count,
                enablePlaceholders = true,
                maxSize = 200
            ),
            initialKey = null,
            pagingSourceFactory = {
                NewsPagingSource(
                    backendQuery = { startFrom ->
                        api.getNews(
                            extended = extended,
                            count = count,
                            endTime = endTime,
                            startTime = startTime,
                            latitude = latitude,
                            longitude = longitude,
                            startFrom = startFrom,
                            searchQuery = searchQuery
                        )
                    }
                )
            }
        ).flow


}

@Keep
data class VKRequest(
    @SerializedName("response")
    val response: Response
)

@Keep
data class Views(
    @SerializedName("count")
    val count: Int
)

@Keep
data class Video(
    @SerializedName("access_key")
    val accessKey: String,
    @SerializedName("can_add")
    val canAdd: Int,
    @SerializedName("can_add_to_faves")
    val canAddToFaves: Int,
    @SerializedName("can_dislike")
    val canDislike: Int,
    @SerializedName("can_like")
    val canLike: Int,
    @SerializedName("can_repost")
    val canRepost: Int,
    @SerializedName("can_subscribe")
    val canSubscribe: Int,
    @SerializedName("comments")
    val comments: Int,
    @SerializedName("date")
    val date: Int,
    @SerializedName("description")
    val description: String,
    @SerializedName("duration")
    val duration: Int,
    @SerializedName("first_frame")
    val firstFrame: List<FirstFrame>,
    @SerializedName("height")
    val height: Int,
    @SerializedName("id")
    val id: Int,
    @SerializedName("image")
    val image: List<Image>?,
    @SerializedName("local_views")
    val localViews: Int,
    @SerializedName("owner_id")
    val ownerId: Int,
    @SerializedName("platform")
    val platform: String,
    @SerializedName("response_type")
    val responseType: String,
    @SerializedName("title")
    val title: String,
    @SerializedName("track_code")
    val trackCode: String,
    @SerializedName("type")
    val type: String,
    @SerializedName("views")
    val views: Int,
    @SerializedName("width")
    val width: Int
)

@Keep
data class Size(
    @SerializedName("height")
    val height: Int,
    @SerializedName("type")
    val type: String,
    @SerializedName("url")
    val url: String,
    @SerializedName("width")
    val width: Int
) : Comparable<Size> {
    override fun compareTo(other: Size): Int {
        val me: Double = avgSum(height, width)
        val alien: Double = avgSum(other.height, other.width)
        return me.compareTo(alien)
    }
}

@Keep
data class Response(
    @SerializedName("count")
    val count: Int,
    @SerializedName("items")
    val items: List<Item>,
    @SerializedName("next_from")
    val nextFrom: String?,
    @SerializedName("total_count")
    val totalCount: Int
)

@Keep
data class Reposts(
    @SerializedName("count")
    val count: Int,
    @SerializedName("user_reposted")
    val userReposted: Int
)

@Keep
data class PostSource(
    @SerializedName("platform")
    val platform: String,
    @SerializedName("type")
    val type: String
)

@Keep
data class PhotoX(
    @SerializedName("access_key")
    val accessKey: String,
    @SerializedName("album_id")
    val albumId: Int,
    @SerializedName("date")
    val date: Int,
    @SerializedName("has_tags")
    val hasTags: Boolean,
    @SerializedName("id")
    val id: Int,
    @SerializedName("owner_id")
    val ownerId: Int,
    @SerializedName("post_id")
    val postId: Int,
    @SerializedName("sizes")
    val sizes: List<Size>?,
    @SerializedName("text")
    val text: String,
    @SerializedName("user_id")
    val userId: Int
)

@Keep
data class Photo(
    @SerializedName("album_id")
    val albumId: Int,
    @SerializedName("date")
    val date: Int,
    @SerializedName("has_tags")
    val hasTags: Boolean,
    @SerializedName("id")
    val id: Int,
    @SerializedName("owner_id")
    val ownerId: Int,
    @SerializedName("sizes")
    val sizes: List<Size>?,
    @SerializedName("text")
    val text: String,
    @SerializedName("user_id")
    val userId: Int
)

@Keep
data class MainArtist(
    @SerializedName("domain")
    val domain: String,
    @SerializedName("id")
    val id: String,
    @SerializedName("name")
    val name: String
)

@Keep
data class Link(
    @SerializedName("caption")
    val caption: String,
    @SerializedName("description")
    val description: String,
    @SerializedName("photo")
    val photo: Photo?,
    @SerializedName("title")
    val title: String,
    @SerializedName("url")
    val url: String
)

@Keep
data class Likes(
    @SerializedName("can_like")
    val canLike: Int,
    @SerializedName("can_publish")
    val canPublish: Int,
    @SerializedName("count")
    val count: Int,
    @SerializedName("repost_disabled")
    val repostDisabled: Boolean,
    @SerializedName("user_likes")
    val userLikes: Int
)

@Keep
data class Item(
    @SerializedName("attachments")
    val attachments: List<Attachment>?,
    @SerializedName("carousel_offset")
    val carouselOffset: Int,
    @SerializedName("comments")
    val comments: Comments,
    @SerializedName("date")
    val date: Int,
    @SerializedName("donut")
    val donut: Donut,
    @SerializedName("from_id")
    val fromId: Int,
    @SerializedName("id")
    val id: Int,
    @SerializedName("likes")
    val likes: Likes,
    @SerializedName("marked_as_ads")
    val markedAsAds: Int,
    @SerializedName("owner_id")
    val ownerId: Int,
    @SerializedName("post_source")
    val postSource: PostSource,
    @SerializedName("post_type")
    val postType: String,
    @SerializedName("reposts")
    val reposts: Reposts,
    @SerializedName("short_text_rate")
    val shortTextRate: Double,
    @SerializedName("signer_id")
    val signerId: Int,
    @SerializedName("text")
    val text: String?,
    @SerializedName("type")
    val type: String,
    @SerializedName("views")
    val views: Views
)

@Keep
data class Image(
    @SerializedName("height")
    val height: Int,
    @SerializedName("url")
    val url: String,
    @SerializedName("width")
    val width: Int,
    @SerializedName("with_padding")
    val withPadding: Int
) : Comparable<Image> {
    override fun compareTo(other: Image): Int {
        val me: Double = avgSum(height, width)
        val alien: Double = avgSum(other.height, other.width)
        return me.compareTo(alien)
    }


}

@Keep
data class FirstFrame(
    @SerializedName("height")
    val height: Int,
    @SerializedName("url")
    val url: String,
    @SerializedName("width")
    val width: Int
)

@Keep
data class FeaturedArtist(
    @SerializedName("domain")
    val domain: String,
    @SerializedName("id")
    val id: String,
    @SerializedName("name")
    val name: String
)

@Keep
data class Donut(
    @SerializedName("is_donut")
    val isDonut: Boolean
)

@Keep
data class Comments(
    @SerializedName("can_post")
    val canPost: Int,
    @SerializedName("count")
    val count: Int,
    @SerializedName("groups_can_post")
    val groupsCanPost: Boolean
)

@Keep
data class Audio(
    @SerializedName("artist")
    val artist: String,
    @SerializedName("date")
    val date: Int,
    @SerializedName("duration")
    val duration: Int,
    @SerializedName("featured_artists")
    val featuredArtists: List<FeaturedArtist>,
    @SerializedName("id")
    val id: Int,
    @SerializedName("is_explicit")
    val isExplicit: Boolean,
    @SerializedName("is_focus_track")
    val isFocusTrack: Boolean,
    @SerializedName("main_artists")
    val mainArtists: List<MainArtist>,
    @SerializedName("owner_id")
    val ownerId: Int,
    @SerializedName("short_videos_allowed")
    val shortVideosAllowed: Boolean,
    @SerializedName("stories_allowed")
    val storiesAllowed: Boolean,
    @SerializedName("stories_cover_allowed")
    val storiesCoverAllowed: Boolean,
    @SerializedName("title")
    val title: String,
    @SerializedName("track_code")
    val trackCode: String,
    @SerializedName("url")
    val url: String
)

@Keep
data class Attachment(
    @SerializedName("audio")
    val audio: Audio?,
    @SerializedName("link")
    val link: Link?,
    @SerializedName("photo")
    val photo: PhotoX?,
    @SerializedName("type")
    val type: String,
    @SerializedName("video")
    val video: Video?
)

const val BASE_URL = "https://api.vk.com/method/"
const val Version = "5.131"
val accessKey: String = "23fd944523fd944523fd94459a20e8c42c223fd23fd944547247437e187abdded4852ab"

object VkEndings {

    const val EMPTY_GET = "."
    const val NEWS_SEARCH_GET = "newsfeed.search"

}

object VkParams {

    const val V = "v"
    const val ACCESS_TOKEN = "access_token"
    const val Q = "q"
    const val START_FROM = "start_from"
    const val LATITUDE = "latitude"
    const val LONGITUDE = "longitude"
    const val COUNT = "count"
    const val START_TIME = "start_time"
    const val END_TIME = "end_time"
    const val EXTENDED: String = "extended"

}

interface API {


    @GET(VkEndings.NEWS_SEARCH_GET)
    suspend fun getNews(
        @Query(VkParams.ACCESS_TOKEN) accessToken: String = accessKey,
        @Query(VkParams.V) v: String = Version,
        @Query(VkParams.Q) searchQuery: String,
        @Query(VkParams.START_FROM) startFrom: String,
        @Query(VkParams.LATITUDE) latitude: String,
        @Query(VkParams.LONGITUDE) longitude: String,
        @Query(VkParams.COUNT) count: Int = 15,
        @Query(VkParams.START_TIME) startTime: Int = 0,
        @Query(VkParams.END_TIME) endTime: Int = 0,
        @Query(VkParams.EXTENDED) extended: Boolean = false
    ): VKRequest

}


@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {

    @Provides
    @Singleton
    fun provideApi(): API = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(API::class.java)

}


@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    abstract fun provideApiRepository(apiRepositoryImpl: ApiRepositoryImpl): ApiRepository

    @Binds
    abstract fun provideRoomRepository(roomRepositoryImpl: RoomRepositoryImpl): RoomRepository

}

const val ROOM_DATABASE = "room-database"

@Module
@InstallIn(SingletonComponent::class)
object RoomModule {

    @Provides
    @Singleton
    fun provideDatabase(@ApplicationContext appContext: Context): AppDatabase {
        return Room.databaseBuilder(appContext, AppDatabase::class.java, ROOM_DATABASE)
            .build()
    }


}

@Keep
data class NewsCluster(
    val newsList: List<News>,
    val nextCluster: String
)


@Keep
data class News(
    val id: Int,
    val ownerId: Int,
    val date: String,
    val insides: List<Inside>,
    val countViewers: Int?,
    val text: String
)

@Keep
data class NewsNoText(
    val id: Int,
    val ownerId: Int,
    val date: String,
    val insides: List<Inside>,
    val countViewers: Int?,
)

fun News.mapToNewsNoText(): NewsNoText = NewsNoText(id, ownerId, date, insides, countViewers)
fun NewsNoText.mapToNews(text: String): News = News(id, ownerId, date, insides, countViewers, text)

@Keep
data class Inside(
    val title: String,
    val description: String,
    val imageUrl: String,
    val audioUrl: String,
    val url: String = "",
    val date: String,
)

interface RoomRepository {
}

interface ApiRepository {

    fun getNews(
        latitude: String = "", longitude: String = "",
        startTime: Int = 0, endTime: Int = 0,
        count: Int = 15, searchQuery: String,
        extended: Boolean = false
    ): Flow<PagingData<News>>

}

sealed interface UIState {

    object Success : UIState
    object Error : UIState
    object Empty : UIState
    object Loading : UIState
    object None : UIState

}

@Composable
fun LoadingIndicator(
    modifier: Modifier = Modifier,
    color: Color,
    size: Dp = 30.dp,
    width: Dp = 3.dp
) {
    Box(modifier = modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        CircularProgressIndicator(
            modifier = Modifier.size(size),
            strokeWidth = width,
            color = color
        )
    }
}

@Composable
fun BackArrowIcon(modifier: Modifier = Modifier, expanded: Boolean = false) {
    Icon(
        modifier = modifier
            .size(10.dp)
            .rotate(if (expanded) 270f else 0f),
        imageVector = Icons.Default.ArrowBackIosNew,
        contentDescription = null,
        tint = textColorPrimary
    )
}

@Composable
fun AppTopBar(
    modifier: Modifier = Modifier,
    content: @Composable RowScope.() -> Unit
) {
    Row(
        modifier = modifier
            .background(color = backColorPrimary)
            .padding(horizontal = 17.dp)
            .padding(top = 17.dp, bottom = 2.dp)
            .fillMaxWidth()
            .height(65.dp)
            .background(color = primaryColor, shape = smallShape)
    ) {
        content()
    }
}

@Composable
fun NewsList(
    modifier: Modifier = Modifier, onItemClick: (News) -> Unit,
    viewModel: MainViewModel, lazyPagingNews: LazyPagingItems<News>
) {

    LazyColumn(
        modifier = modifier.fillMaxSize(),
        contentPadding = PaddingValues(horizontal = 24.dp, vertical = 10.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        items(count = lazyPagingNews.itemCount) { index ->
            NewsCard(
                modifier = Modifier.fillMaxWidth(),
                news = lazyPagingNews[index]!!,
                onClick = { it ->
                    onItemClick(it)
                }
            )
        }
        if (lazyPagingNews.loadState.append == LoadState.Loading) {
            item {
                CircularProgressIndicator(
                    modifier = Modifier
                        .padding(vertical = 10.dp)
                        .fillMaxWidth()
                        .wrapContentWidth(Alignment.CenterHorizontally),
                    color = primaryColor,
                    strokeWidth = 4.dp
                )

            }
        }
    }
}

@Composable
fun NewsCard(modifier: Modifier = Modifier, news: News, onClick: (News) -> Unit) {
    Column(modifier = modifier.clickable {
        onClick(news)
    }) {
        val image = news.insides.first { it.imageUrl.isNotEmpty() }.imageUrl
        val title = news.insides.firstOrNull { it.title.isNotEmpty() }?.title
            ?: news.insides.firstOrNull { it.description.isNotEmpty() }?.description ?: ""
        SubcomposeAsyncImage(
            modifier = Modifier
                .fillMaxWidth()
                .height(200.dp)
                .clip(smallShape),
            model = image,
            contentDescription = null,
            contentScale = ContentScale.Crop,
            loading = {
                LoadingIndicator(color = textColorPrimary)
            }
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 10.dp)
        ) {
            if (title.isNotEmpty()) {
                Text(
                    text = title,
                    textAlign = TextAlign.Start,
                    style = headline3,
                    color = textColorPrimary,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExposedDropdownMenuBoxScope.MainTopButton(
    currentItem: String,
    expanded: Boolean,
    onExpandedChange: (Boolean) -> Unit
) {
    TextButton(
        modifier = Modifier.menuAnchor(),
        onClick = {
            onExpandedChange(!expanded)
        },
        contentPadding = PaddingValues(12.dp)
    ) {
        BackArrowIcon(
            modifier = Modifier,
            expanded = expanded
        )
        Spacer(modifier = Modifier.width(8.dp))
        Text(
            text = currentItem,
            color = textColorPrimary,
            style = headline4,
            textAlign = TextAlign.Start
        )
    }
}

@Composable
fun MainTopButton(
    title: String,
    onClick: () -> Unit
) {
    TextButton(
        modifier = Modifier,
        onClick = {
            onClick()
        },
        contentPadding = PaddingValues(12.dp)
    ) {
        Text(
            text = title,
            color = textColorPrimary,
            style = headline4,
            textAlign = TextAlign.Start
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainTopBar(
    modifier: Modifier = Modifier,
    countryElement: ExpandableElement<Country>,
    currentDate: String,
    onCountryExpanded: (Boolean) -> Unit,
    onCountryDismissRequest: () -> Unit,
    onCountryItemClick: (Int) -> Unit,
    onDateClick: () -> Unit
) {
    AppTopBar(
        modifier = modifier
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth(0.25f)
                .fillMaxHeight(),
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = stringResource(R.string.news),
                color = textColorPrimary,
                style = headline1
            )
        }
        Row(
            modifier = Modifier.fillMaxSize(),
            horizontalArrangement = Arrangement.SpaceEvenly,
            verticalAlignment = Alignment.CenterVertically
        ) {
            ExposedElement(
                currentItem = stringResource(id = countryElement.currentItem.resId),
                menuItems = countryElement.items.map {
                    it.resId
                },
                onExpandedChange = { opposite ->
                    onCountryExpanded(opposite)
                },
                onDismissRequest = {
                    onCountryDismissRequest()
                },
                onItemClick = { id ->
                    onCountryItemClick(id)
                },
                expanded = countryElement.expanded,
            ) { currentItem ->
                MainTopButton(
                    currentItem = currentItem,
                    expanded = countryElement.expanded,
                    onExpandedChange = onCountryExpanded
                )
            }

            MainTopButton(
                title = currentDate,
                onClick = {
                    //onDateClick()
                }
            )
        }
    }
}


val navigationUrl =
    "?={${Destinations.News().news}}?={${Destinations.News().text}}"

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainContent(
    modifier: Modifier = Modifier,
    viewState: MainState,
    viewModel: MainViewModel,
    navController: NavController
) {
    if (viewState.dialogState.expanded) {
        Box(
            modifier = modifier
                .fillMaxSize()
                .padding(top = 20.dp),
            contentAlignment = Alignment.TopCenter
        ) {
            val datePickerState = rememberDatePickerState(
                initialSelectedDateMillis = viewState.dialogState.date.unixMillis,
                initialDisplayMode = DisplayMode.Picker,
            )
            DatePicker(
                modifier = Modifier
                    .background(color = primaryColor),
                state = datePickerState, colors = newsDatePickerColors(),
                showModeToggle = false,
            )
            LaunchedEffect(key1 = datePickerState.selectedDateMillis) {
                viewModel.selectCurrentDate(datePickerState.selectedDateMillis)
            }
        }
    } else {
        Column(
            modifier = modifier.fillMaxSize()
        ) {
            val lazyPagingNews = viewState.pagingDataFlow.collectAsLazyPagingItems()
            when (lazyPagingNews.loadState.refresh) {
                is LoadState.Error -> {
                    viewModel.updateUIState(UIState.Error)
                }

                LoadState.Loading -> {
                    viewModel.updateUIState(UIState.Loading)
                }

                is LoadState.NotLoading -> {
                    if (lazyPagingNews.itemSnapshotList.isEmpty()) {
                        viewModel.updateUIState(UIState.Empty)
                    } else {
                        viewModel.updateUIState(UIState.Success)
                    }
                }
            }
            when (viewState.screenState) {
                UIState.Loading -> {
                    LoadingIndicator(color = primaryColor, size = 50.dp, width = 5.dp)
                }

                UIState.Success -> {
                    Text(
                        text = stringResource(R.string.all_news),
                        color = textColorPrimary,
                        style = headline2,
                        modifier = Modifier.padding(horizontal = 17.dp, vertical = 15.dp)
                    )
                    val coroutineScope = rememberCoroutineScope()
                    NewsList(
                        onItemClick = { news ->
                            coroutineScope.launch {
                                try {
                                    val jsonNews = Gson().toJson(news)
                                    val navigationUrl = Destinations.News().route
                                        .replace(
                                            navigationUrl,
                                            "?=${jsonNews}?=${news.text}"
                                        )

                                    try {
                                        withContext(Dispatchers.Main) {
                                            navController.navigate(navigationUrl)
                                        }
                                    } catch (ex: Exception) {
                                    }
                                } finally {
                                }
                            }
                        },
                        viewModel = viewModel,
                        lazyPagingNews = lazyPagingNews
                    )
                }

                else -> {

                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun newsDatePickerColors() = DatePickerDefaults.colors(
    titleContentColor = textColorPrimary,
    headlineContentColor = textColorPrimary,
    weekdayContentColor = textColorPrimary,
    subheadContentColor = textColorPrimary,
    yearContentColor = textColorPrimary,
    currentYearContentColor = textColorPrimary,
    dayContentColor = textColorPrimary,
    disabledDayContentColor = textColorPrimary,
    todayContentColor = textColorPrimary,
    selectedDayContentColor = textColorPrimary,
    selectedYearContentColor = textColorPrimary,
    dayInSelectionRangeContentColor = textColorPrimary,
    disabledSelectedDayContentColor = textColorPrimary,
    containerColor = primaryColor,
    selectedDayContainerColor = backColorPrimary,
    selectedYearContainerColor = backColorPrimary,
    todayDateBorderColor = textColorPrimary,
    dayInSelectionRangeContainerColor = textColorPrimary,
    disabledSelectedDayContainerColor = textColorPrimary,
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExposedElement(
    currentItem: String,
    expanded: Boolean,
    onExpandedChange: (Boolean) -> Unit,
    menuItems: List<Int>,
    onItemClick: (Int) -> Unit,
    onDismissRequest: () -> Unit,
    element: @Composable ExposedDropdownMenuBoxScope.(currentItem: String) -> Unit
) {
    ExposedDropdownMenuBox(
        modifier = Modifier,
        expanded = expanded,
        onExpandedChange = onExpandedChange
    ) {
        element(currentItem)
        ExposedDropdownMenu(
            modifier = Modifier.background(color = primaryColor),
            expanded = expanded,
            onDismissRequest = onDismissRequest
        ) {
            menuItems.forEachIndexed { index, idItem ->
                Divider(color = backColorPrimary, thickness = 1.dp)
                DropdownMenuItem(
                    modifier = Modifier
                        .background(color = primaryColor),
                    text = {
                        Text(
                            modifier = Modifier,
                            text = stringResource(id = idItem),
                            style = headline4,
                            textAlign = TextAlign.Center,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis
                        )
                    },
                    onClick = {
                        onItemClick(idItem)
                    },
                    colors = MenuDefaults.itemColors(
                        textColor = textColorPrimary,
                        disabledTextColor = textColorPrimary,
                    ),
                    contentPadding = PaddingValues(vertical = 6.dp, horizontal = 10.dp)
                )
                if (index == menuItems.size - 1) {
                    Divider(color = backColorPrimary, thickness = 1.dp)
                }
            }

        }
    }
}

val countries = listOf(
    Country(
        resId = R.string.country_russia,
        "55.7522",
        "37.6156",
        "Новости России"
    ),
    Country(
        resId = R.string.Bel,
        "53.9",
        "27.5667",
        "Новости Беларуси"
    ),
    Country(
        resId = R.string.Kz,
        "43.2371",
        "76.9456",
        "Новости Казахстана"
    )
)

data class Country(
    val resId: Int,
    val latitude: String,
    val longitude: String,
    val request: String
)

data class MainState(
    val screenState: UIState = UIState.None,
    val news: List<News> = emptyList(),
    val countryElement: ExpandableElement<Country> = ExpandableElement(
        expanded = false,
        items = countries,
        currentItem = countries.first()
    ),
    val dialogState: DialogState = DialogState(),
    val pagingDataFlow: Flow<PagingData<News>> = emptyFlow()
)

data class DialogState(
    val expanded: Boolean = false,
    val date: CustomDate = CustomDate()
)

data class CustomDate(
    private val date: Date = Date(),
) {
    fun getStrDate(): String {
        val formatter = SimpleDateFormat("MM/dd/yyyy", Locale.US)
        return formatter.format(date.time)
    }

    val unixMillis = date.time


}

data class ExpandableElement<Item>(
    val currentItem: Item,
    val expanded: Boolean = false,
    val items: List<Item> = emptyList()
)

@HiltViewModel
class MainViewModel @Inject constructor(
    private val apiRepository: ApiRepository
) : BaseViewModel<MainState>(MainState()) {


    fun selectCurrentDate(millis: Long?) = launchViewModel {
        if (millis != null) {
            updateState {
                copy(
                    dialogState = dialogState.copy(
                        date = CustomDate(Date(millis)),
                    )
                )
            }
            stateValue.dialogState.date.unixMillis.logDebug()
        }
    }

    fun clickButtonDate() = launchViewModel(Dispatchers.Main) {
        updateState {
            copy(
                dialogState = dialogState.copy(expanded = !dialogState.expanded)
            )
        }
    }

    fun clickCountryElement(opposite: Boolean) = launchViewModel(Dispatchers.Main) {
        opposite.logDebug()
        updateState {
            copy(countryElement = countryElement.copy(expanded = opposite))
        }
    }

    fun dismissCountryElement() = launchViewModel(Dispatchers.Main) {
        updateState {
            copy(countryElement = countryElement.copy(expanded = false))
        }
    }

    fun clickCountryItem(id: Int) = launchViewModel(Dispatchers.Main) {
        updateState {
            copy(
                countryElement = countryElement.copy(
                    currentItem = countryElement.items.first { it.resId == id },
                    expanded = false
                )
            )
        }
        loadNews()
    }

    fun loadNews() = launchViewModel {
        val country = stateValue.countryElement.currentItem
        val pagingData = apiRepository.getNews(
            latitude = country.latitude,
            longitude = country.longitude,
            searchQuery = country.request
        ).cachedIn(viewModelScope)
        updateState {
            copy(
                pagingDataFlow = pagingData
            )
        }
    }

    fun updateUIState(state: UIState) {
        updateState {
            copy(
                screenState = state
            )
        }
    }

    private fun ViewModel.launchViewModel(
        context: CoroutineContext = Dispatchers.IO,
        coroutineStart: CoroutineStart = CoroutineStart.DEFAULT,
        block: suspend () -> Unit
    ) = viewModelScope.launch(context = context, start = coroutineStart) { block() }

}

@Composable
fun MainScreen(viewModel: MainViewModel, viewState: MainState, navController: NavController) {
    Scaffold(
        topBar = {
            MainTopBar(
                countryElement = viewState.countryElement,
                currentDate = viewState.dialogState.date.getStrDate(),
                onCountryItemClick = { id ->
                    viewModel.clickCountryItem(id)
                },
                onCountryDismissRequest = {
                    viewModel.dismissCountryElement()
                },
                onCountryExpanded = { opposite ->
                    viewModel.clickCountryElement(opposite)
                },
                onDateClick = {
                    viewModel.clickButtonDate()
                }
            )
        },
        containerColor = backColorPrimary
    ) { paddingValues ->
        MainContent(
            viewState = viewState,
            viewModel = viewModel,
            modifier = Modifier.padding(paddingValues),
            navController = navController
        )
    }
}

@Composable
fun MainDest(navController: NavController) {
    val mainViewModel = hiltViewModel<MainViewModel>()
    val viewState = mainViewModel.viewState.collectAsState().value
    MainScreen(viewModel = mainViewModel, viewState = viewState, navController = navController)

    LaunchedEffect(Unit) {
        mainViewModel.loadNews()
    }
}

private fun getCountries(context: Context): List<String> {
    with(context) {
        val russia = getString(R.string.country_russia)
        val bel = getString(R.string.Bel)
        val kz = getString(R.string.Kz)
        return listOf(russia, kz, bel)
    }
}

@Composable
fun NewsContent(modifier: Modifier = Modifier, viewState: NewsState, viewModel: NewsViewModel) {
    Column(
        modifier = modifier
            .verticalScroll(rememberScrollState())
            .padding(14.dp)
    ) {
        viewState.news.insides.forEach { inside ->
            if (inside.imageUrl != "") {
                Spacer(modifier = Modifier.height(6.dp))
                SubcomposeAsyncImage(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(300.dp)
                        .clip(smallShape),
                    model = inside.imageUrl,
                    contentDescription = null,
                    contentScale = ContentScale.Crop,
                    loading = {
                        LoadingIndicator(color = textColorPrimary)
                    }
                )
            }
            if (inside.title != "") {
                Spacer(modifier = Modifier.height(6.dp))
                Text(
                    text = inside.title,
                    textAlign = TextAlign.Start,
                    style = headline3.copy(fontSize = 24.sp),
                    color = textColorPrimary,
                )
            }
            if (inside.description != "") {
                Spacer(modifier = Modifier.height(6.dp))
                Text(
                    text = inside.title,
                    textAlign = TextAlign.Start,
                    style = headline4.copy(fontSize = 20.sp),
                    color = textColorPrimary,
                )
            }
        }
        val text = viewState.news.text
        if (text != "") {
            Spacer(modifier = Modifier.height(6.dp))
            Text(
                text = text,
                textAlign = TextAlign.Start,
                style = headline4.copy(fontSize = 22.sp),
                color = textColorPrimary,
            )
        }
    }
}

@Keep
data class NewsState(
    val news: News = News(
        id = 0,
        ownerId = 0,
        date = "",
        insides = emptyList(),
        countViewers = null,
        text = ""
    )
)

@HiltViewModel
class NewsViewModel @Inject constructor() : BaseViewModel<NewsState>(NewsState()) {

    fun rememberNews(news: News) = viewModelScope.launch {
        updateState {
            copy(
                news = news
            )
        }
    }

}

@Composable
fun NewsScreen(viewModel: NewsViewModel, viewState: NewsState, navController: NavController) {
    Scaffold(
        topBar = {
            AppTopBar {
                Row(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(horizontal = 17.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Icon(
                        imageVector = Icons.Default.ArrowBack,
                        contentDescription = null,
                        tint = textColorPrimary,
                        modifier = Modifier.clickable {
                            navController.popBackStack()
                        }
                    )
                    Text(
                        text = stringResource(R.string.news),
                        color = textColorPrimary,
                        style = headline1,
                    )

                }
            }
        },
        containerColor = backColorPrimary
    ) { paddingValues ->
        NewsContent(
            viewState = viewState,
            viewModel = viewModel,
            modifier = Modifier
                .padding(top = 10.dp)
                .fillMaxSize()
                .padding(paddingValues),
        )
    }
}

@Composable
fun NewsDest(navController: NavController, news: News) {
    val viewModel = hiltViewModel<NewsViewModel>()
    val viewState = viewModel.viewState.collectAsState().value
    NewsScreen(viewModel = viewModel, viewState = viewState, navController = navController)
    LaunchedEffect(key1 = Unit) {
        viewModel.rememberNews(news)
    }
}

sealed class Destinations(val route: String) {

    object Main : Destinations(Routes.MAIN)
    class News(
        val news: String = Routes.NEWS_ARG_CLASS,
        val text: String = Routes.NEWS_ARG_TEXT
    ) : Destinations(Routes.NEWS)
}

object Routes {

    const val NEWS_ARG_CLASS = "news"
    const val NEWS_ARG_TEXT = "text"

    const val MAIN = "main"
    const val NEWS = "news?={$NEWS_ARG_CLASS}?={$NEWS_ARG_TEXT}"

}


@Composable
fun AppNavigation() {
    val systemUiController = rememberSystemUiController()
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = Destinations.Main.route
    ) {
        composable(Destinations.Main.route) {
            MainDest(navController)
        }
        composable(
            Destinations.News().route, arguments = listOf(
                navArgument(Destinations.News().news) { type = NavType.StringType },
                navArgument(Destinations.News().text) { type = NavType.StringType }
            )) { backStackEntry ->
            val gson = Gson()
            val jsonNews =
                try {
                    backStackEntry.arguments?.getString(Destinations.News().news) ?: ""
                } finally {
                }
            val text =
                try {
                    backStackEntry.arguments?.getString(Destinations.News().news) ?: ""
                } finally {
                }
            val news = try {
                gson.fromJson(jsonNews, News::class.java)
            } catch (ex: Exception) {
                News(
                    id = 0, ownerId = 0, date = "01.01.2023", listOf(
                        Inside(
                            stringResource(R.string.no_text),
                            "",
                            "",
                            "",
                            "",
                            "",
                        )
                    ), countViewers = 0, ""
                )
            }
            NewsDest(navController = navController, news = news)
        }
    }

    SideEffect {
        systemUiController.setSystemBarsColor(
            color = backColorPrimary,
            darkIcons = false
        )
    }
}
"""
    }
    
    static func dependencies(_ mainData: MainData) -> ANDData {
        return ANDData(
            mainFragmentData: ANDMainFragment(
                imports: "",
                content: """
    AppNavigation()
"""
            ),
            mainActivityData: .empty,
            themesData: .def,
            stringsData: ANDStringsData(additional: """
            <string name="news">News</string>
            <string name="all_news">All news</string>
            <string name="main_text">Main text:</string>
            <string name="no_text">This news does not have a detailed description</string>
            <string name="country_russia">Russia</string>
            <string name="Bel">Belarus</string>
            <string name="Kz">Kazakhstan</string>
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

plugins{
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'kotlin-kapt'
    id 'dagger.hilt.android.plugin'
}

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
    //Base
    implementation Dependencies.core_ktx
    implementation Dependencies.appcompat
    implementation Dependencies.material

    implementation 'com.google.code.gson:gson:2.10.1'
    
    //Compose
    implementation Dependencies.compose_ui
    //implementation Dependencies.compose_material
    implementation Dependencies.compose_preview
    implementation Dependencies.compose_material3
    implementation Dependencies.compose_activity
    implementation Dependencies.compose_ui_tooling
    implementation Dependencies.compose_navigation
    implementation Dependencies.compose_foundation
    implementation Dependencies.compose_runtime
    implementation Dependencies.compose_runtime_livedata
    implementation Dependencies.compose_mat_icons_core
    implementation Dependencies.compose_mat_icons_core_extended
    implementation Dependencies.compose_system_ui_controller

    implementation("io.coil-kt:coil-compose:2.4.0")
    implementation Dependencies.paging
    implementation Dependencies.pagingCompose


    //Other
    implementation Dependencies.coroutines
    implementation Dependencies.fragment_ktx
    implementation Dependencies.lifecycle_viewmodel
    implementation Dependencies.lifecycle_runtime

    //DI
    implementation Dependencies.dagger_hilt
    kapt Dependencies.dagger_hilt_compiler
    kapt Dependencies.hilt_viewmodel_compiler
    implementation Dependencies.compose_hilt_nav

    //Internet
    implementation Dependencies.retrofit
    implementation Dependencies.converter_gson

    //Room
    kapt Dependencies.room_compiler
    implementation Dependencies.room_runtime
    implementation Dependencies.room_ktx

    
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
    const val pagingCompose = "androidx.paging:paging-compose:3.2.0"
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
