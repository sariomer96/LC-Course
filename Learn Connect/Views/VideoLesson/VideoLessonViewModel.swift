//
//  VideoLessonViewModel.swift
//  Learn Connect
//
//  Created by Omer on 10.12.2024.
//

import Foundation

final class VideoLessonViewModel {
     var myCourse:MyCourse?
    var isDownloaded = false
    func setMyCourse(myCourse: MyCourse) {
        self.myCourse = myCourse
    }
}
