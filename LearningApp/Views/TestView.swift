//
//  TestView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/7/21.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        
        VStack {
            //Title
            HStack {
                Text("Swift Test")
                    .font(.largeTitle)
                    .padding(.leading, 20)
                Spacer()
                Text("Question 1 of 10")
                    .padding(.trailing, 20)
            }.padding(.bottom, 40)
            
            //Question
            Text("What is the answer to this question?")
                .padding()
            
            ButtonView(buttonColor: .gray, textColor: .black, buttonText: "This is the sample problem (TODO: HTML)", buttonHeight: 90)
                .padding(.horizontal)
                .padding(.bottom, 40)
            
            //Multiple Choice Answer Boxes (ButtonView boxes)

            ButtonView(buttonColor: .white, textColor: .black, buttonText: "Answer 1")
                .padding(.horizontal)
                .padding(.bottom, 10)

            ButtonView(buttonColor: .white, textColor: .black, buttonText: "Answer 2")
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            ButtonView(buttonColor: .white, textColor: .black, buttonText: "Answer 3")
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            Spacer()
            
            ButtonView(buttonColor: .green, textColor: .white, buttonText: "Submit")
                .padding()
            
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
