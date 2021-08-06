//
//  ButtonView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/6/21.
//

import SwiftUI

struct ButtonView: View {
    
    @EnvironmentObject var model: ContentModel
    //var index: Int
    
    var buttonColor: Color
    var textColor: Color
    var buttonText: String
    
    var body: some View {
        
        //let nextLessonTitle = model.currentModule!.content
        
        ZStack {
            
            Rectangle()
                .foregroundColor(buttonColor)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 48)
            
            Text(buttonText)
                .foregroundColor(textColor)
                .bold()
            
        }
        
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(buttonColor: .blue, textColor: .white, buttonText: "This is a Button")
    }
}
