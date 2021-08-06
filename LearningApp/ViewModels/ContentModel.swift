//
//  ContentModel.swift
//  LearningApp
//
//  Created by Kevin Tooley on 8/5/21.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of Modules
    @Published var modules = [Module]()
    
    // Current Module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    var styleData: Data?
    
    init() {
        
        getLocalData()
        
    }
    
    // MARK: Data Methods
    
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
    
    // MARK: Module Navigation Methods
    
    func beginModule(_ moduleId:Int) {
        
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
    
    
}
