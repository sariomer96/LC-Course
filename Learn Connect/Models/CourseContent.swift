 import Foundation
 
struct CourseContent: Codable {
    let total, totalHits: Int?
    let hits: [Hit]?
}
 
struct Hit: Codable  {
    let id: Int?
    let pageURL: String?
    let type: TypeEnum?
    let tags: String?    
    let duration: Int?
    let title: String?
    let videos: Videos?
}

enum TypeEnum : String, Codable {
    case animation
    case film
}

// MARK: - Videos
struct Videos: Codable  {
    let medium: Medium?
}

// MARK: - Medium
struct Medium : Codable {
    let url: String?
    let width, height, size: Int?
    let thumbnail: String?
}

 
