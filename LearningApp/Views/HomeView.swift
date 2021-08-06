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
        
        ScrollView {
            
            LazyVStack {
                
                ForEach(model.modules) { module in
                    
                    //Learning Card
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
                        HStack {
                            
                            //Image
                            Image(module.content.image)
                                .resizable()
                                .frame(width: 116, height: 116, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            
                            Spacer()
                            
                            //Text
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Learn \(module.category)")
                                    .bold()
                                Text(module.content.description)
                                    .padding(.bottom, 20)
                                    .font(.caption)
                                HStack {
                                    Image(systemName: "text.book.closed")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text("\(module.content.lessons.count) Lessons")
                                        .font(.caption)
                                    Spacer()
                                    Image(systemName: "clock")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text(module.content.time)
                                        .font(.caption)
                                }
                            }.padding(.leading, 20)
                            
                        }.padding(.horizontal, 20)
                        
                    }
                    
                    //Test Card
                    
                }
                
            }.padding()
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
