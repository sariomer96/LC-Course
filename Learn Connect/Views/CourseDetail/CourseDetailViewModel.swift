//
//  CourseDetailViewModel.swift
//  Learn Connect
//
//  Created by Omer on 9.12.2024.
//

import Foundation

final class CourseDetailViewModel {
     
    var course: Hit?
     
    func subscribeAndWishListCourse(isLiked:Int?,isSub:Int?) {
         
    guard let user = UserProfile.shared.user , let course = course else { return }
    DatabaseManager.shared.upsertCourse(userId: user.id ?? 0, videoId: course.id ?? 0, imageUrl: course.videos?.medium?.thumbnail ?? "", videoUrl: course.videos?.medium?.url ?? "", title: course.title ?? "", isLiked: isLiked, isSub: isSub)
     } 
}
