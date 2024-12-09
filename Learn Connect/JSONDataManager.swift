//
//  JSONDataManager.swift
//  Learn Connect
//
//  Created by Omer on 8.12.2024.
//

import Foundation
 
final class JSONDataManager {
   
    static let shared = JSONDataManager()
    
    func loadJSONData(categoryName:String) -> CourseContent?{
        guard let path = Bundle.main.path(forResource: categoryName, ofType: "json", inDirectory: "Jsons") else {
            print("JSON dosyası bulunamadı.")
           return nil
        }

        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let courseContent = try decoder.decode(CourseContent.self, from: data)
       
              return courseContent
            print("Başarıyla okundu: \(courseContent)")
        } catch {
            print("JSON okuma/parsing hatası: \(error)")
        }
        
        return nil
    }

}
