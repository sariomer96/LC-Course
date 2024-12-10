//
//  VideoPlayListViewModel.swift
//  Learn Connect
//
//  Created by Omer on 10.12.2024.
//

import Foundation

protocol VideoPlayListDelegate: AnyObject {
    func didSelectVideo(at index: Int)
}


final class VideoPlayListViewModel {
    var myCourse: MyCourse?
    
    func setMyCourse(myCourse: MyCourse) {
        self.myCourse = myCourse
    }
}
