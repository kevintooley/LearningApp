//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/6/21.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    // sample.mp4 is 1920 x 1080
    let videoRatio: CGFloat = 1080 / 1920
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        GeometryReader { geo in
            VStack {
            
                // only show video if we get valid url
                if url != nil {
                    VideoPlayer(player: AVPlayer(url: url!))
                        .frame(height: geo.size.width * videoRatio)
                }
                
                // Description
                CodeTextView()
                
                // Next lesson button only if there is a next lesson
                
                if model.hasNextLesson() {
                    Button(action: {
                        //advance the lesson
                        model.nextLession()
                    }, label: {
        //                Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                        ButtonView(buttonColor: .green, textColor: .white, buttonText: "Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                    })
                }
                else {
                    Button(action: {
                        model.currentContentSelected = nil
                    }, label: {
                        ButtonView(buttonColor: .green, textColor: .white, buttonText: "Complete Lesson")
                    })
                }
            }
            .padding()
            .navigationBarTitle(lesson?.title ?? "")
        }
        
    }
}

//struct ContentDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentDetailView()
//    }
//}
