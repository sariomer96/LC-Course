//
//  HomeViewModel.swift
//  Learn Connect
//
//  Created by Omer on 8.12.2024.
//

import Foundation
import UserNotifications

final class HomeViewModel {
    var user:User?
    
    var allVideoContent:CourseContent?
    var computer:CourseContent?
    var education:CourseContent?
    var music:CourseContent?
    var science:CourseContent?
    var currentContent:CourseContent?
    var courseCollectionViewCellId = "CourseCollectionViewCell"
    var courseDetailId = "toCourseDetailVC"
    
    func getCourseContentFromJSon() {
       allVideoContent = JSONDataManager.shared.loadJSONData(categoryName: "all")
       computer =  JSONDataManager.shared.loadJSONData(categoryName: "computer")
       education =  JSONDataManager.shared.loadJSONData(categoryName: "education")
       music =  JSONDataManager.shared.loadJSONData(categoryName: "music")
       science =  JSONDataManager.shared.loadJSONData(categoryName: "science")
        
       currentContent = allVideoContent

    }
    
    func scheduleLocalNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Permission denied: \(error.localizedDescription)")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Yeni eğitimler başlıyor :)"
        content.body = "Yüzlerce eğitim içeriği seni bekliyor."
        content.sound = .default
         
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        
      
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
        
 
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim planlanamadı: \(error.localizedDescription)")
            } else {
                print("Bildirim planlandı!")
            }
        }
    }
    
}

