//
//  TestView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/7/21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    // track the answer given by the user
    @State var selectedAnswerIndex:Int?
    
    @State var submitted = false
    @State var numCorrect = 0
    
    @State var showResults = false
    
    var body: some View {
        
        // compound if check is a workaround to possible IOS bug.
        // Without this, the Test will constantly loop back to question
        // number 1 without showing the results page.  
        if (model.currentQuestion != nil) && (model.finalize == false) {
            
            VStack(alignment: .leading) {
                //Title
                
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                //Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                /*
                ButtonView(buttonColor: .gray, textColor: .black, buttonText: "This is the sample problem (TODO: HTML)", buttonHeight: 90)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                */
                
                ScrollView {
                    
                    VStack {
                        
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            Button(action: {
                                
                                selectedAnswerIndex = index
                                
                            }, label: {
                                
                                ZStack {
                                    
                                    if !submitted {
                                        Rectangle()
                                            .foregroundColor(index == selectedAnswerIndex ? .gray : .white)
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .frame(height: 48)
                                    }
                                    else {
                                        
                                        if (selectedAnswerIndex == index) && (selectedAnswerIndex == model.currentQuestion!.correctIndex) || (index == model.currentQuestion!.correctIndex) {
                                            Rectangle()
                                                .foregroundColor(.green)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                                .frame(height: 48)
                                        }
                                        else if selectedAnswerIndex == index && selectedAnswerIndex != model.currentQuestion!.correctIndex {
                                            Rectangle()
                                                .foregroundColor(.red)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                                .frame(height: 48)
                                        }
                                        else {
                                            Rectangle()
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                                .frame(height: 48)
                                        }
                                    }
                                    

                                    Text(model.currentQuestion!.answers[index])
                                        .accentColor(.black)
                                    
                                }
                                .padding(.horizontal, 20)
                                
                            })
                            .disabled(submitted)
                            
                        }
                        
                    }
                    .padding(.top, 20)
                    
                }
                
                // Submit Button
                Button(action: {
                    
                    // if answer has already been submitted
                    if submitted == true{
                        
                        // Check if it was the last question
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                            
                            // check next quetion and save progress
                            model.nextQuestion()
                            
                            showResults = true
                        }
                        else {
                            
                            // Answer has alread been submitted, more to next and save
                            model.nextQuestion()
                            
                            // Reset properties
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                    }
                    
                    // if answer has not been submitted yet, submit the answer
                    else {
                        
                        // toggle submitted flag
                        submitted = true
                        
                        // check if the answer is correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                    
                }, label: {
                    ButtonView(buttonColor: .green,
                               textColor: .white,
                               buttonText: computedButtonText)
                        .padding()
                })
                .disabled(selectedAnswerIndex == nil)
                
                
            }.navigationBarTitle("\(model.currentModule?.category ?? "") Test")

        }
        else {

            // Workaround for odd behavior in ios 14.5
            if model.finalize {
                
                TestResultsView(numberCorrect: numCorrect)

            }
            else {
                ProgressView()
            }

        }
    }
    
    var computedButtonText: String {
        
        // Chck if answer has been submitted
        if submitted {
            
            if model.currentModule == nil {
                return "Finish"
            }
            else if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                // this is the last questions
                return "Finish"
            }
            else {
                return "Next"
            }
        }
        else {
            return "Submit"
        }
        
    }
}

//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
