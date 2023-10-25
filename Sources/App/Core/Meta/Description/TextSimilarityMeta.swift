//
//  File.swift
//  
//
//  Created by admin on 9/1/23.
//

import Foundation

struct TextSimilarityMeta: MetaProviderProtocol {
    
    
    static func getFullDesc(appName: String) -> String {
        let fullDesc1 = "\(appName) is a mobile application designed to compare text documents based on their similarities. With this application, users can quickly and efficiently determine the degree of similarity between two or more texts. Once the comparison is complete, \(appName) provides the user with results showing the degree of similarity between text documents. The results can be presented as a numerical value indicating the percentage of similarity, or as a graphical representation showing a visual comparison between documents."

        let fullDesc2 = "One of the key features of \(appName) is the ability to compare texts based on semantic analysis algorithms. The application uses advanced Natural Language Processing (NLP) technologies to automatically analyse text content and identify its semantic structure. This allows the application to determine the degree of similarity between texts based on their semantic content, not just on superficial matches of words or phrases. \(appName) also offers the user the ability to save the comparison results for later use or analysis. The user can create reports containing information about the comparison, including the original texts of the documents, comparison results and other useful information."

        let fullDesc3 = "To use \(appName), the user needs to upload text documents to be compared. The application supports various file formats including DOC, TXT, PDF and others. Once the documents are uploaded, the user can choose the comparison method that best suits their needs. One of the features of \(appName) is its simple and intuitive interface. Users can easily upload and compare text documents, select comparison methods, and view the results. The application also offers various settings and options that allow users to customise the comparison process according to their needs."

        let fullDesc4 = "\(appName) offers several methods for comparing texts. One of them is the cosine measure comparison method. This method uses a vector representation of the text to determine the similarity between documents. Another method is the Jaccard comparison method. It is based on calculating the Jaccard coefficient, which determines the similarity between two sets of items. \(appName) can be a useful tool for different categories of users. For example, students and researchers can use the app to authenticate their papers and detect possible plagiarism. Business users can use \(appName) to compare contracts, reports or other documents and detect similarities or differences between them. In addition, the application can be useful for journalists, editors, and any user working with large amounts of textual information."

        let fullDesc5 = "Once the comparison is complete, \(appName) provides the user with results showing the degree of similarity between text documents. The results can be presented as a numerical value indicating the percentage of similarity, or as a graphical representation showing a visual comparison between documents. \(appName) is a powerful tool for comparing text documents that provides a quick and accurate assessment of their similarities. The application offers a wide range of comparison methods, a user-friendly interface and the ability to save results for future use. With this, users can effectively analyse and compare texts, which helps them make informed decisions and ensures high accuracy and reliability in their work."

        let fullDesc6 = "\(appName) also offers the user the ability to save comparison results for later use or analysis. The user can create reports containing information about the comparison, including original texts of documents, comparison results and other useful information. \(appName) is an innovative mobile application that provides unique opportunities to analyse and compare texts in Russian. With this application you can easily and quickly determine the degree of similarity between two or more texts, which can be an invaluable tool in various fields, from education and scientific research to content marketing and more."

        let fullDesc7 = "One of the features of \(appName) is its simple and intuitive interface. Users can easily upload and compare text documents, select comparison methods, and view results. The application also offers various settings and options that allow users to customise the comparison process according to their needs. One of the main features of \(appName) is its ease of use. The intuitive interface allows even inexperienced users to quickly learn the app's functionality and get the information they need in just a few clicks. This makes the application accessible to a wide range of users, regardless of their level of technical literacy."

        let fullDesc8 = "\(appName) can be a useful tool for different categories of users. For example, students and researchers can use the application to check the authenticity of their work and detect possible plagiarism. Business users can use \(appName) to compare contracts, reports or other documents and find similarities or differences between them. In addition, the application can be useful for journalists, editors and any users who work with large amounts of textual information. However, the main attractive feature of \(appName) is its ability to analyse texts based on their semantic content. The application uses advanced natural language processing algorithms to determine the degree of similarity between texts, taking into account their meaning and context. This approach guarantees more accurate comparison results than simply matching characters or words."

        let fullDesc9 = "\(appName) is a powerful tool for comparing text documents that provides fast and accurate assessment of their similarities. The application offers a wide range of comparison methods, a user-friendly interface and the ability to save results for later use. With this, users can effectively analyse and compare texts, which helps them make informed decisions and ensures high accuracy and reliability in their work. \(appName) also provides the ability to analyse texts based on their structure. The app breaks texts into sentences and then analyses their syntactic structure, identifying common elements and differences between them. This allows you to identify not only common themes and ideas in texts, but also differences in their organisation and structure."

        let fullDesc10 = "\(appName) is a mobile application that provides unique opportunities for analysing and comparing texts in Russian. With its help you can easily and quickly determine the degree of similarity between two or more texts, which can be useful in many areas, including education, research, content marketing and more. \(appName) offers the ability to analyse texts based on their lexical content. The app identifies the most common words and phrases in texts, as well as their distribution and frequency of use. This helps to identify common themes and key ideas in texts, as well as identify differences in their lexical composition."
        
        let fullDesc11 = "One of the key features of \(appName) is its ease of use. The intuitive interface allows even inexperienced users to easily navigate through the functions of the application and get the necessary information in just a few clicks. This makes the application accessible to a wide range of users, regardless of their level of technical literacy. \(appName) has a wide range of applications. It can be used for educational purposes to check the originality of students' texts or to compare learning materials. In scientific research, the application can be useful for analysing similarities and differences in text data. In content marketing, \(appName) helps to determine the uniqueness of content and its compliance with specified requirements."

        let fullDesc12 = "One of the main features of \(appName) is the ability to compare texts based on their semantic content. The application uses advanced natural language processing algorithms to determine the degree of similarity between texts, taking into account their meaning and context. This provides more accurate comparison results than simple character or word comparisons. \(appName) is a powerful tool for analysing and comparing texts in Russian. It provides users with unique capabilities to determine the degree of similarity between texts based on their semantic, structural and lexical content. With its simple interface and wide range of applications, \(appName) will become a reliable assistant in many areas where text analysis and comparison is required."

        let fullDesc13 = "\(appName) also provides the ability to analyse texts based on their structure. The application breaks texts into sentences and then analyses their syntactic structure, identifying common elements and differences between them. This allows you to identify not only common themes and ideas in texts, but also differences in their organisation and structure. \(appName) is an innovative mobile application that provides unique opportunities for analysing and comparing texts in Russian. With the help of this application you can quickly and easily determine the degree of similarity between two or more texts, which can be an invaluable tool in various fields, from education and research to content marketing and much more."

        let fullDesc14 = "\(appName) offers the ability to analyse texts based on their lexical content. The app identifies the most frequent words and phrases in texts, as well as their distribution and frequency of use. This helps to identify common themes and key ideas in texts, as well as identify differences in their lexical composition. One of the main features of \(appName) is its ease of use. The intuitive interface allows even inexperienced users to quickly learn the functionality of the application and get the necessary information in just a few clicks. This makes the application available to a wide range of users, regardless of their level of technical literacy."

        let fullDesc15 = "\(appName) has a wide range of applications. It can be used for educational purposes to check the originality of students' texts or to compare teaching materials. In scientific research, the application can be useful for analysing similarities and differences in textual data. In content marketing, \(appName) helps to determine the uniqueness of content and its compliance with specified requirements. However, the main attractive feature of \(appName) is its ability to analyse texts based on their semantic content. The application uses advanced natural language processing algorithms to determine the degree of similarity between texts, taking into account their meaning and context. This approach guarantees more accurate comparison results than simply matching characters or words!"

        let fullDesc16 = "\(appName) is a powerful tool for analysing and comparing texts in Russian. It provides the user with unique possibilities to determine the degree of similarity between texts based on their semantic, structural and lexical content. With its simple interface and wide range of applications, \(appName) will be a reliable assistant in many areas where you need to analyse and compare texts. \(appName) also provides the ability to analyse texts based on their structure. The application breaks texts into sentences and then analyses their syntactic structure, identifying common elements and differences between them. This allows you to identify not only common themes and ideas in texts, but also differences in their organisation and structure."

        let fullDesc17 = "\(appName) is an innovative mobile application designed to compare text documents based on their similarities. With this app, users can quickly and easily determine the degree of similarity between two or more texts. \(appName) offers the ability to analyse texts based on their lexical content. The app identifies the most frequently occurring words and phrases in texts, as well as their distribution and frequency of use. This helps to identify common themes and key ideas in texts, as well as identify differences in their lexical composition."

        let fullDesc18 = "One of the main features of \(appName) is the ability to compare texts based on semantic analysis algorithms. The application uses advanced Natural Language Processing (NLP) technologies to automatically analyse text content and identify its semantic structure. This allows the application to determine the degree of similarity between texts based on their semantic content, not just on superficial matches of words or phrases. \(appName) has a wide range of applications. It can be used for educational purposes to check the originality of students' texts or to compare teaching materials. In scientific research, the application can be useful for analysing similarities and differences in text data. In content marketing, \(appName) helps to determine the uniqueness of content and its compliance with specified requirements."

        let fullDesc19 = "To use \(appName), the user needs to upload text documents to be compared. The application supports various file formats including DOC, TXT, PDF and others. Once the documents are uploaded, the user can choose the comparison method that best suits their needs. \(appName) is a powerful tool for analysing and comparing texts in Russian. It provides users with unique capabilities to determine the degree of similarity between texts based on their semantic, structural and lexical content. With its simple interface and wide range of applications, \(appName) will become a reliable assistant in many areas where text analysis and comparison is required."

        let fullDesc20 = "\(appName) offers several methods of text comparison. One of them is the cosine measure comparison method. This method uses a vector representation of the text to determine similarities between documents. Another method is the Jaccard comparison method. It is based on calculating the Jaccard coefficient, which determines the similarity between two sets of items. \(appName) is an innovative mobile app that is designed to compare text documents and determine the degree of similarity between them. With this app, users can quickly and easily assess how similar two or more texts are."
        
        let fullDesc21 = "\(appName) - this is a convenient application for comparing two texts and determining the degree of their similarity in percentages. Just type or paste two texts, and the application will quickly analyze, showing how similar the texts are to each other. The limit of 5000 characters allows you to work with small texts, which makes the application ideal for checking short phrases, messages or letters. Modern comparison algorithms provide accurate and reliable results, presented as a percentage of similarity. This application can be useful for various scenarios, such as checking the uniqueness of content, determining plagiarism, or comparing variants of text data. \(appName) is your reliable assistant for quick and easy comparison of texts and getting a visual assessment of their similarity."
        
        let fullDesc = [fullDesc1, fullDesc2, fullDesc3, fullDesc4, fullDesc5, fullDesc6, fullDesc7, fullDesc8, fullDesc9, fullDesc10, fullDesc11, fullDesc12, fullDesc13, fullDesc14, fullDesc15, fullDesc16, fullDesc17, fullDesc18, fullDesc19, fullDesc20, fullDesc21]
        
        return fullDesc.randomElement() ?? fullDesc21
    }
    
    static func getShortDesc(appName: String) -> String {
        let shortDesc1 = "\(appName) - the best text comparison app!"

        let shortDesc2 = "With \(appName) it's easy to find similarities in texts!"

        let shortDesc3 = "Analyse texts with \(appName) and get accurate results!"

        let shortDesc4 = "\(appName) is your reliable assistant in analysing similar texts!"

        let shortDesc5 = "Find semantic matches with \(appName) and expand your knowledge!"

        let shortDesc6 = "\(appName) - check the degree of similarity of texts in one touch!"

        let shortDesc7 = "\(appName) - a powerful tool for analysing similar texts!"

        let shortDesc8 = "Compare texts with ease with \(appName)!"

        let shortDesc9 = "\(appName) is your guide in the world of text analysis!"

        let shortDesc10 = "Calculating the degree of similarity of texts has never been so easy as with \(appName)!"

        let shortDesc11 = "\(appName) is your reliable partner in text analysis!"

        let shortDesc12 = "Analyse text equivalence with \(appName) and get accurate results!"

        let shortDesc13 = "\(appName) - assess the degree of similarity of texts in a few clicks!"

        let shortDesc14 = "Compare texts with \(appName) and get useful conclusions!"

        let shortDesc15 = "\(appName) - the best tool for analysing similar texts!"

        let shortDesc16 = "\(appName) - your reliable assistant in assessing the parallelism of texts!"

        let shortDesc17 = "With \(appName) you can easily find similarities in texts and expand your knowledge!"

        let shortDesc18 = "\(appName) - the best text comparison app on the market!"

        let shortDesc19 = "\(appName) - check the equivalence of texts in a few seconds!"

        let shortDesc20 = "Analyse semantic matches with \(appName) and get accurate results!"

        let shortDesc21 =  "\(appName): Text comparison."
        
        let shortDesc = [shortDesc1, shortDesc2, shortDesc3, shortDesc4, shortDesc5, shortDesc6, shortDesc7, shortDesc8, shortDesc9, shortDesc10, shortDesc11, shortDesc12, shortDesc13, shortDesc14, shortDesc15, shortDesc16, shortDesc17, shortDesc18, shortDesc19, shortDesc20, shortDesc21]
        return shortDesc.randomElement() ?? shortDesc21
    }
}
