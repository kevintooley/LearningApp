//
//  ContentModel.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/5/21.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of Modules
    @Published var modules = [Module]()
    
    // Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current Question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current Lesson Explanation
    @Published var codeText = NSAttributedString()
    
    // Current selected content and test: this is like the demo to roll back to the home screen.  i.e. $selectedIndex binding
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    @Published var finalize = false
    
    var styleData: Data?
    
    init() {
        
        // parse local json data
        getLocalData()
        
        // Download remote json file and parse
        getRemoteData()
        
    }
    
    // MARK: Data Methods
    
    func getLocalData() {
        
        //get url to json
        let url = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            
            //setup data object
            let data = try Data(contentsOf: url!)
            
            //setup decoder
            let decoder = JSONDecoder()
            
            do {
                
                //decode data object
                let modules = try decoder.decode([Module].self, from: data)
                
                //assign parsed modules to modules property
                self.modules = modules
                
            }
            catch {
                print(error)
            }
            
            
        }
        catch {
            print(error)
        }
        
        // parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            //setup data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
            
        }
        catch {
            print("Couldn't read style data")
        }
        
    }
    
    func getRemoteData() {
        
        let urlString = "https://kevintooley.github.io/learning_pages/data2.json"
        
        let remoteUrl = URL(string: urlString)
        
        guard remoteUrl != nil else {
            // Couldn't find url
            return
        }
        
        // create a URL request object
        let request = URLRequest(url: remoteUrl!)
        
        // Get the url session and kick off task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // check if there is an error
            guard error == nil else {
                // There was an error
                return
            }
            
            do {
                // create json decoders
                let decoder = JSONDecoder()
            
                // decode
                let modules = try decoder.decode([Module].self, from: data!)
                
                // append modules in to self.modules
                self.modules += modules
            }
            catch {
                print(error)
            }
        }
        
        dataTask.resume()
        
    }
    
    // MARK: Module Navigation Methods
    
    func beginModule(_ moduleId:Int) {
        
        // Find the index for the current module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleId {
                
                // Found the correct index
                currentModuleIndex = index
                break
                
            }
            
        }
        
        //Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
        //Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        // Set the current lessons and explanation
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool {
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
        
    }
    
    func nextLession() {
        
        // Advance the current lesson index
        currentLessonIndex += 1
        
        // check that it's within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // set the current lesson
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
            
        }
        else {
            
            // reset current lesson
            currentLessonIndex = 0
            currentLesson = nil
            
        }
        
    }
    
    func beginTest(_ moduleId:Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question
        currentQuestionIndex = 0
        
        // if the module has questions for the test, set the currentQuestion to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        
    }
    
    func nextQuestion() {
        
        // Advance the current lesson index
        currentQuestionIndex += 1
        
        // check that it's within range
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            // set the current lesson
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
            
        }
        else {
            
            // reset current lesson
            currentQuestionIndex = 0
            currentQuestion = nil
            
            //Added to try to fix IOS 14.5 bug
            finalize = true
            
        }
        
    }
    
    // MARK: Code Styling
    
    private func addStyling(_ htmlStrong: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // add the styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        // add the html data
        data.append(Data(htmlStrong.utf8))
        
        // convert to attributed string
        // technique 1
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
            
        }
        
        // technique 2
        /*
         do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            resultString = attributedString
            
        }
        catch {
            print(error)
        }
         */
        
        return resultString
        
    }
    
}
