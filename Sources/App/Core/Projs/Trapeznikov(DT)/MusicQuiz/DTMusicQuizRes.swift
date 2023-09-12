//
//  File.swift
//  
//
//  Created by admin on 9/12/23.
//
import Foundation

struct DTMusicQuizRes {
    static let dimens = XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <dimen name="corner_radius">8dp</dimen>
    <dimen name="layout_padding">32dp</dimen>
    <dimen name="welcome_size">24sp</dimen>
    <dimen name="hint_size">16sp</dimen>
    <dimen name="button_text_size">16sp</dimen>
    <dimen name="widget_margin">16dp</dimen>
    <dimen name="progress_margin">8dp</dimen>
    <dimen name="stroke_width">2dp</dimen>
    <dimen name="bg_radius">5dp</dimen>
    <dimen name="default_text_size">16sp</dimen>
    <dimen name="progress_indicator_margin">64dp</dimen>
</resources>
""", name: "dimens.xml")
    
    
    static let layActiv = XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<androidx.fragment.app.FragmentContainerView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:id="@+id/nav_host_fragment"
    android:name="androidx.navigation.fragment.NavHostFragment"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    app:defaultNavHost="true"
    app:navGraph="@navigation/nav_graph" />
""", name: "activity_main.xml")
    
    static let layFrag = XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary">

    <androidx.cardview.widget.CardView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:background="@color/backColorPrimary"
        app:cardCornerRadius="@dimen/corner_radius"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent">

        <androidx.constraintlayout.widget.ConstraintLayout
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:background="@color/backColorPrimary"
            android:padding="@dimen/layout_padding">

            <TextView
                android:id="@+id/welcomeText"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="@string/welcome"
                android:textColor="@color/textColorPrimary"
                android:textSize="@dimen/welcome_size"
                android:textStyle="bold"
                app:layout_constraintEnd_toEndOf="parent"
                app:layout_constraintStart_toStartOf="parent"
                app:layout_constraintTop_toTopOf="parent" />

            <TextView
                android:id="@+id/scoreText"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="@dimen/widget_margin"
                android:text="@string/start_when_you_are_ready"
                android:textColor="@color/textColorSecondary"
                android:textSize="@dimen/hint_size"
                app:layout_constraintEnd_toEndOf="@id/welcomeText"
                app:layout_constraintStart_toStartOf="@id/welcomeText"
                app:layout_constraintTop_toBottomOf="@id/welcomeText" />

            <Button
                android:id="@+id/startButton"
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_marginTop="@dimen/widget_margin"
                android:text="@string/start"
                android:backgroundTint="@color/buttonColorPrimary"
                android:textColor="@color/buttonTextColorPrimary"
                app:layout_constraintEnd_toEndOf="@id/scoreText"
                app:layout_constraintStart_toStartOf="@id/scoreText"
                app:layout_constraintTop_toBottomOf="@id/scoreText" />
        </androidx.constraintlayout.widget.ConstraintLayout>
    </androidx.cardview.widget.CardView>

</androidx.constraintlayout.widget.ConstraintLayout>
""", name: "fragment_main.xml")
    
    static let layQuiz = XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    android:padding="@dimen/layout_padding"
    android:splitMotionEvents="false">

    <TextView
        android:id="@+id/questionText"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:gravity="center"
        android:textColor="@color/textColorPrimary"
        android:textSize="@dimen/default_text_size"
        app:layout_constraintBottom_toTopOf="@id/progressIndicator"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintVertical_chainStyle="packed"
        tools:text="question" />

    <TextView
        android:id="@+id/progressText"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginBottom="@dimen/progress_margin"
        android:textColor="@color/textColorPrimary"
        app:layout_constraintBottom_toTopOf="@id/progressIndicator"
        app:layout_constraintEnd_toEndOf="@id/progressIndicator"
        app:layout_constraintStart_toStartOf="@id/progressIndicator"
        tools:text="5 / 10" />

    <com.google.android.material.progressindicator.LinearProgressIndicator
        android:id="@+id/progressIndicator"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginTop="@dimen/progress_indicator_margin"
        android:indeterminate="false"
        android:max="10"
        android:progress="0"
        app:indicatorColor="@color/buttonColorPrimary"
        app:layout_constraintBottom_toTopOf="@id/optionOneButton"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/questionText"
        app:trackColor="@color/surfaceColor"
        tools:progress="5" />

    <Button
        android:id="@+id/optionOneButton"
        style="?attr/materialButtonOutlinedStyle"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginTop="@dimen/widget_margin"
        android:backgroundTint="@color/backColorPrimary"
        android:gravity="center"
        android:textColor="@color/buttonColorPrimary"
        android:textSize="@dimen/button_text_size"
        app:layout_constraintBottom_toTopOf="@id/optionTwoButton"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@id/progressIndicator"
        tools:text="option 1" />

    <Button
        android:id="@+id/optionTwoButton"
        style="?attr/materialButtonOutlinedStyle"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginTop="@dimen/widget_margin"
        android:backgroundTint="@color/backColorPrimary"
        android:gravity="center"
        android:textColor="@color/buttonColorPrimary"
        android:textSize="@dimen/button_text_size"
        app:layout_constraintBottom_toTopOf="@id/optionThreeButton"
        app:layout_constraintEnd_toEndOf="@id/optionOneButton"
        app:layout_constraintStart_toStartOf="@id/optionOneButton"
        app:layout_constraintTop_toBottomOf="@id/optionOneButton"
        tools:text="option 2" />

    <Button
        android:id="@+id/optionThreeButton"
        style="?attr/materialButtonOutlinedStyle"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginTop="@dimen/widget_margin"
        android:backgroundTint="@color/backColorPrimary"
        android:gravity="center"
        android:textColor="@color/buttonColorPrimary"
        android:textSize="@dimen/button_text_size"
        app:layout_constraintBottom_toTopOf="@id/optionFourButton"
        app:layout_constraintEnd_toEndOf="@id/optionTwoButton"
        app:layout_constraintStart_toStartOf="@id/optionTwoButton"
        app:layout_constraintTop_toBottomOf="@id/optionTwoButton"
        tools:text="option 3" />

    <Button
        android:id="@+id/optionFourButton"
        style="?attr/materialButtonOutlinedStyle"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_marginTop="@dimen/widget_margin"
        android:backgroundTint="@color/backColorPrimary"
        android:gravity="center"
        android:textColor="@color/buttonColorPrimary"
        android:textSize="@dimen/button_text_size"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="@id/optionThreeButton"
        app:layout_constraintStart_toStartOf="@id/optionThreeButton"
        app:layout_constraintTop_toBottomOf="@id/optionThreeButton"
        tools:text="option 4" />

    <LinearLayout
        android:id="@+id/loadLayout"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:background="@color/backColorPrimary"
        android:gravity="center"
        android:orientation="vertical"
        android:visibility="gone"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent">

        <com.google.android.material.progressindicator.CircularProgressIndicator
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:indeterminate="true"
            app:indicatorColor="@color/buttonColorPrimary"
            app:trackColor="@color/backColorPrimary" />

        <TextView
            android:id="@+id/connectionLostText"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginTop="@dimen/widget_margin"
            android:gravity="center"
            android:text="@string/connection_is_lost"
            android:textColor="@color/textColorPrimary"
            android:textSize="@dimen/welcome_size"
            android:visibility="gone"
            tools:visibility="visible" />
    </LinearLayout>

</androidx.constraintlayout.widget.ConstraintLayout>
""", name: "fragment_quiz.xml")
    
    static let layRes = XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/backColorPrimary"
    android:splitMotionEvents="false">

    <androidx.cardview.widget.CardView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:background="@color/backColorPrimary"
        app:cardCornerRadius="@dimen/corner_radius"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent">

        <androidx.constraintlayout.widget.ConstraintLayout
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:background="@color/backColorPrimary"
            android:padding="@dimen/layout_padding">

            <TextView
                android:id="@+id/scoreIsText"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="@string/your_score_is"
                android:textColor="@color/textColorPrimary"
                android:textSize="@dimen/welcome_size"
                app:layout_constraintEnd_toEndOf="parent"
                app:layout_constraintStart_toStartOf="parent"
                app:layout_constraintTop_toTopOf="parent" />

            <TextView
                android:id="@+id/scoreText"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="@dimen/widget_margin"
                android:textColor="@color/textColorPrimary"
                android:textSize="@dimen/welcome_size"
                app:layout_constraintEnd_toEndOf="@id/scoreIsText"
                app:layout_constraintStart_toStartOf="@id/scoreIsText"
                app:layout_constraintTop_toBottomOf="@id/scoreIsText"
                tools:text="5 / 10" />

            <TextView
                android:id="@+id/oneMoreText"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="@dimen/widget_margin"
                android:text="@string/one_more_quiz"
                android:textColor="@color/textColorPrimary"
                android:textSize="@dimen/welcome_size"
                app:layout_constraintEnd_toEndOf="@id/scoreText"
                app:layout_constraintStart_toStartOf="@id/scoreText"
                app:layout_constraintTop_toBottomOf="@id/scoreText" />

            <Button
                android:id="@+id/noButton"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginTop="@dimen/widget_margin"
                android:backgroundTint="@color/buttonColorPrimary"
                android:text="@string/no"
                android:textColor="@color/buttonTextColorPrimary"
                android:textSize="@dimen/button_text_size"
                app:layout_constraintEnd_toStartOf="@id/yesButton"
                app:layout_constraintStart_toStartOf="parent"
                app:layout_constraintTop_toBottomOf="@id/oneMoreText" />

            <Button
                android:id="@+id/yesButton"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_marginStart="@dimen/widget_margin"
                android:backgroundTint="@color/buttonColorPrimary"
                android:text="@string/yes"
                android:textColor="@color/buttonTextColorPrimary"
                android:textSize="@dimen/button_text_size"
                app:layout_constraintBottom_toBottomOf="@id/noButton"
                app:layout_constraintEnd_toEndOf="parent"
                app:layout_constraintStart_toEndOf="@id/noButton"
                app:layout_constraintTop_toTopOf="@id/noButton" />
        </androidx.constraintlayout.widget.ConstraintLayout>
    </androidx.cardview.widget.CardView>

</androidx.constraintlayout.widget.ConstraintLayout>
""", name: "fragment_result.xml")
    
    static let nav = XMLLayoutData(content: """
<?xml version="1.0" encoding="utf-8"?>
<navigation xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/nav_graph"
    app:startDestination="@id/mainFragment">

    <fragment
        android:id="@+id/mainFragment"
        android:name="com.dantrapdev.musicquiz.presentation.fragments.main_fragment.MainFragment"
        android:label="MainFragment"
        tools:layout="@layout/fragment_main">
        <action
            android:id="@+id/action_mainFragment_to_quizFragment"
            app:destination="@id/quizFragment"
            app:popUpTo="@id/nav_graph"
            app:popUpToInclusive="true" />
    </fragment>
    <fragment
        android:id="@+id/quizFragment"
        android:name="com.dantrapdev.musicquiz.presentation.fragments.main_fragment.QuizFragment"
        android:label="QuizFragment"
        tools:layout="@layout/fragment_quiz">
        <action
            android:id="@+id/action_quizFragment_to_resultFragment"
            app:destination="@id/resultFragment"
            app:popUpTo="@id/nav_graph"
            app:popUpToInclusive="true" />
    </fragment>
    <fragment
        android:id="@+id/resultFragment"
        android:name="com.dantrapdev.musicquiz.presentation.fragments.main_fragment.ResultFragment"
        android:label="ResultFragment"
        tools:layout="@layout/fragment_result">
        <action
            android:id="@+id/action_resultFragment_to_quizFragment"
            app:destination="@id/quizFragment"
            app:popUpTo="@id/nav_graph"
            app:popUpToInclusive="true" />
    </fragment>
</navigation>
""", name: "nav_graph.xml")
    
}
