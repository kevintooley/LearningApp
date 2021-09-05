//
//  ResumeView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 9/5/21.
//

import SwiftUI

struct ResumeView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var resumeSelected: Int?
    
    let user = UserService.shared.user
    
    var resumeTitle: String {
        
        let module = model.modules[user.lastModule ?? 0]
        
        if user.lastLesson != 0 {
            
            // Resume lesson
            return "Learn \(module.category): Lesson \(user.lastLesson! + 1)"
        }
        else {
            
            // Resume test
            return "\(module.category) Test: Question \(user.lastQuestion! + 1)"
        }
        
    }
    
    var destination: some View {
        
        return Group {
            
            let module = model.modules[user.lastModule ?? 0]
            
            // Determine if we need to go to contentDetailView or TestView
            if user.lastLesson! > 0 {
                
                // need to go to ContentView
                ContentDetailView()
                    .onAppear(perform: {
                        
                        // Fetch Lessons
                        model.getLessons(module: module) {
                            model.beginModule(module.id)
                            model.beginLesson(user.lastLesson!)
                        }
                        
                    })
            }
            else {
                
                // need to go to test view
                TestView()
                    .onAppear(perform: {
                        model.getQuestions(module: module) {
                            model.beginTest(module.id)
                            model.currentQuestionIndex = user.lastQuestion!
                        }
                        
                    })
            }
        }
        
    }
    
    var body: some View {
        
        let module = model.modules[user.lastModule ?? 0]
        
        NavigationLink(
            destination: destination,
            tag: module.id.hash,
            selection: $resumeSelected,
            label: {
                ZStack {
                
                ButtonView(buttonColor: .white, textColor: .black, buttonText: "", buttonHeight: 66)
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Continue where you left off:")
                            .font(.caption)
                        Text(resumeTitle)
                    }
                    .foregroundColor(.black)
                    Spacer()
                    Image("play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .padding()
                
                
                
            }}
        )
        
        
        
    }
}

//struct ResumeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResumeView()
//    }
//}
