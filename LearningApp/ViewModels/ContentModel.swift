//
//  ContentModel.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/5/21.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    var styleData: Data?
    
    init() {
        
        getLocalData()
        
    }
    
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
    
}
