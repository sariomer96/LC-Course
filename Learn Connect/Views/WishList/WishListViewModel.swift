//
//  WishListViewModel.swift
//  Learn Connect
//
//  Created by Omer on 9.12.2024.
//

import Foundation

final class WishListViewModel {
    var myCourses = [MyCourse]()
    var wishListViewId = "toCourseDetail"
    func getAllMyCourse() {
        let id = UserProfile.shared.user?.id
        
        guard let id = id else { return }
       myCourses = DatabaseManager.shared.getWishListCourses(forUserId: id)
         
    }
    
    
}
