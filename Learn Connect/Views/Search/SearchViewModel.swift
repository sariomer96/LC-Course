//
//  SearchViewModel.swift
//  Learn Connect
//
//  Created by Omer on 10.12.2024.
//

import Foundation

final class SearchViewModel {
    
    var courseContent: CourseContent?
    var filteredHits: [Hit] = []   
   
    
    func getAllCourse() {
        courseContent = JSONDataManager.shared.loadJSONData(categoryName: "all")
         }
    
    
    func searchFilter( query: String) -> [Hit] {
      
        let lowercasedQuery = query.lowercased()
        
        guard let courseContent = courseContent else { return []}
        let filteredHits = courseContent.hits?.filter { hit in
            let tagsMatch = hit.tags?.lowercased().contains(lowercasedQuery) ?? false
            let titleMatch = hit.title?.lowercased().contains(lowercasedQuery) ?? false
            return tagsMatch || titleMatch
        }
        
        return filteredHits ?? []
    }
    
}
