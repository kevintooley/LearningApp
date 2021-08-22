//
//  ContentModel.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/5/21.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var loggedIn = false
    
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
        
        
        
    }
    
    // MARK: Authentication Methods
    
    func checkLogin() {
        
        // check if there is a current user to determine if logged in
        loggedIn = Auth.auth().currentUser != nil ? true : false
        
        // check if user meta data has been fetched.  If user was already logged in from previous session, we need to get their data
        if UserService.shared.user.name == "" {
            getUserData()
        }
    }
    
    // MARK: Data Methods
    
    func getUserData() {
        
        // Check that there is a logged in user
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        // Get meta data for that user
        let db = Firestore.firestore()
        let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        ref.getDocument { snapshot, error in
            
            guard error == nil, snapshot != nil else {
                return
            }
            
            // parse the data
            let data = snapshot!.data()
            let user = UserService.shared.user
            user.name = data?["name"] as? String ?? ""
            user.lastModule = data?["lastModule"] as? Int
            user.lastLesson = data?["lastLesson"] as? Int
            user.lastQuestion = data?["lastQuestion"] as? Int
            
        }
    }
    
    func getLessons(module: Module, completion: @escaping () -> Void) {
        
        // specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        // get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var lessons = [Lesson]()
                
                //  Loop through the docs and build array of lessons
                for doc in snapshot!.documents {
                    
                    var l = Lesson()
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    
                    lessons.append(l)
                    
                }
                
                // Loop through published modules array and find the correct module
                for (index, m) in self.modules.enumerated() {
                    
                    if m.id == module.id {
                        
                        // set the lesson
                        self.modules[index].content.lessons = lessons
                        
                        // call the completion closure
                        completion()
                    }
                }
            }
        }
        
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        
        // specify path
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        // get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                var questions = [Question]()
                
                //  Loop through the docs and build array of lessons
                for doc in snapshot!.documents {
                    
                    var q = Question()
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["content"] as? String ?? ""
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    q.answers = doc["answers"] as? [String] ?? [String]()
                    
                    questions.append(q)
                    
                }
                
                // Loop through published modules array and find the correct module
                for (index, m) in self.modules.enumerated() {
                    
                    if m.id == module.id {
                        
                        // set the lesson
                        self.modules[index].test.questions = questions
                        
                        // call the completion closure
                        completion()
                    }
                }
            }
        }
        
    }
    
    func getModules() {
        
        // parse local styles for html
        getLocalStyles()
        
        let collection = db.collection("modules")
        
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Create an array for the modules
                var modules = [Module]()
                
                for doc in snapshot!.documents {
                    
                    // create a new module instance
                    var m = Module()
                    
                    // parse out the values into module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    // parse the lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    // parse the test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    
                    // add to array
                    modules.append(m)
                    
                }
                
                // Assign our module to the published property
                DispatchQueue.main.async {
                    
                    self.modules = modules
                }
                
            }
            
        }
        
    }
    
    func getLocalStyles() {
        
        /*  Commenting out in order to use Firebase DB
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
        */
        
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
                
                DispatchQueue.main.async {
                    
                    // append modules in to self.modules
                    self.modules += modules
                    
                }
                
            }
            catch {
                print(error)
            }
        }
        
        dataTask.resume()
        
    }
    
    // MARK: Module Navigation Methods
    
    func beginModule(_ moduleId:String) {
        
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
        
        guard currentModule != nil else {
            return false
        }
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
    
    func beginTest(_ moduleId:String) {
        
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
