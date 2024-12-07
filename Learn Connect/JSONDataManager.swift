//
//  JSONDataManager.swift
//  Learn Connect
//
//  Created by Omer on 8.12.2024.
//

import Foundation

final class JSONDataManager {
   
    static let shared = JSONDataManager()
    
    func loadJSONData() {
        guard let path = Bundle.main.path(forResource: "education", ofType: "json") else {
            print("JSON dosyası bulunamadı.")
            return
        }

        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let courseContent = try decoder.decode(CourseContent.self, from: data)
            
            print("Başarıyla okundu: \(courseContent)")
        } catch {
            print("JSON okuma/parsing hatası: \(error)")
        }
    }

}
