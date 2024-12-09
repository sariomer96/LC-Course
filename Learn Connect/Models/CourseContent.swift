import Foundation

// MARK: - CourseContent
struct CourseContent: Codable, Equatable {
    let total, totalHits: Int?
    let hits: [Hit]?
}

// MARK: - Hit
struct Hit: Codable, Equatable {
    let id: Int?
    let pageURL: String?
    let type: TypeEnum?
    let tags: String?
    let duration: Int?
    let title: String?
    let videos: Videos?
}

// MARK: - TypeEnum
enum TypeEnum: String, Codable, Equatable {
    case animation
    case film
}

// MARK: - Videos
struct Videos: Codable, Equatable {
    let medium: Medium?
}

// MARK: - Medium
struct Medium: Codable, Equatable {
    let url: String?
    let width, height, size: Int?
    let thumbnail: String?
}
