//
//  TestResultsView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/7/21.
//

import SwiftUI

struct TestResultsView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var numberCorrect:Int
    
    var body: some View {
        
        VStack {
            Text(closingPhrase)
                .font(.largeTitle)
                .padding()
            Text("You got \(numberCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions")
                .padding(.bottom, 50)
            
            Button(action: {
                model.finalize = false
                model.currentTestSelected = nil
            }, label: {
                ButtonView(buttonColor: .green, textColor: .white, buttonText: "Go to Home Screen")
                    .padding()
            })
        }
        
    }
    
    var closingPhrase: String {
        
        if numberCorrect < 5 {
            return "Keep Trying!"
        }
        else if numberCorrect < 8 {
            return "Good effort!"
        }
        else {
            return "Awesome!"
        }
        
    }
}

struct TestResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TestResultsView(numberCorrect: 9)
            .environmentObject(ContentModel())
    }
}
