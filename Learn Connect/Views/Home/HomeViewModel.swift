//
//  HomeViewModel.swift
//  Learn Connect
//
//  Created by Omer on 8.12.2024.
//

import Foundation

final class HomeViewModel {
    var user:User?
    
    var allVideoContent:CourseContent?
    var computer:CourseContent?
    var education:CourseContent?
    var music:CourseContent?
    var science:CourseContent?
    var currentContent:CourseContent?
  
    
    func getCourseContentFromJSon() {
       allVideoContent = JSONDataManager.shared.loadJSONData(categoryName: "all")
       computer =  JSONDataManager.shared.loadJSONData(categoryName: "computer")
       education =  JSONDataManager.shared.loadJSONData(categoryName: "education")
       music =  JSONDataManager.shared.loadJSONData(categoryName: "music")
       science =  JSONDataManager.shared.loadJSONData(categoryName: "science")
        
        currentContent = allVideoContent

    }
    
    
    
}

