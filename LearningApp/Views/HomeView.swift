//
//  ContentView.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/5/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                    
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                            
                            VStack(spacing: 20) {
                                
                                // MARK: Content NavigationLink
                                NavigationLink(
                                    destination: ContentView()
                                        .onAppear(perform: {
                                            model.getLessons(module: module) {
                                                model.beginModule(module.id)
                                            }
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentContentSelected,
                                    label: {
                                        //Learning Card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) lessons", time: module.content.time)
                                    })
                                
                                
                                // MARK: Test NavigationLink
                                NavigationLink(
                                    destination: TestView()
                                        .onAppear(perform: {
                                            model.getQuestions(module: module) {
                                                model.beginTest(module.id)
                                            }
                                            
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentTestSelected,
                                    label: {
                                        //Test Card
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) questions", time: module.test.time)
                                    })
                                
                                // Workaround for known IOS issue:
                                // https://developer.apple.com/forums/thread/677333
                                // Add EmptyView navigation link
                                NavigationLink(
                                    destination: EmptyView()) {
                                    EmptyView()
                                }

                                
                            
                            }
                                
                        }
                        
                    }
                    .padding()
                    .accentColor(.black)
                    
                }
                
            }
            .navigationTitle("Get Started")
            .onChange(of: model.currentContentSelected) { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            }
            .onChange(of: model.currentTestSelected) { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
