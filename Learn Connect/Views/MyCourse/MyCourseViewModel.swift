
import Foundation

final class MyCourseViewModel {
    
    var myCourses = [MyCourse]()
    var downloadedCourse = [LocalCourseData]()
    var courseFilterType:CourseFilterType = .all
 
    enum CourseFilterType {
        case all
        case downloads
        
    }
    func getAllMyCourse() {
        let id = UserProfile.shared.user?.id
        
        guard let id = id else { return }
       myCourses = DatabaseManager.shared.getSubscribedCourses(forUserId: id)
           
    }
    
    func getDownloadedCourse() {
        let id = UserProfile.shared.user?.id
        
        guard let id = id else { return }
        let userId = String(id)
         downloadedCourse =  DatabaseManager.shared.fetchDownloadedCourseData(for: userId)
    }
    
    
}
