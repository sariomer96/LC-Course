import SQLite3
import UIKit
import Foundation

 
final class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    var errorCallback:VoidCallback?
    var successCallback:VoidCallback?
    private init() {
        openDatabase()
        createTables()
    }

    private func openDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("LearnConnectDB.sqlite")
 
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else
        {
            print("connected")
        }
        
        print(fileURL)
    }
      

    private func createTables() {
        let createUsersTable = """
        CREATE TABLE IF NOT EXISTS User (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            name TEXT,
            surname TEXT
        );
        """
       

        let createCoursesTable = """
        CREATE TABLE IF NOT EXISTS Course (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            video_id INTEGER,
            user_id INTEGER,
            image_url TEXT,
            video_url TEXT,
            title TEXT,
            is_liked INTEGER NULL,
            is_sub INTEGER NULL
           
            
        );
        """

        let downloadsTable = """
        CREATE TABLE IF NOT EXISTS Downloads (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT,
            videoId TEXT,
            title TEXT,
            image BLOB
            
        );
        """
        let createUserCoursesTable = """
        CREATE TABLE IF NOT EXISTS UserCourse (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            course_id INTEGER,
            FOREIGN KEY(user_id) REFERENCES User(id),
            FOREIGN KEY(course_id) REFERENCES Course(id)
        );
        """

        let createVideosTable = """
        CREATE TABLE IF NOT EXISTS Video (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            course_id INTEGER,
            title TEXT,
            url TEXT,
            FOREIGN KEY(course_id) REFERENCES Course(id)
        );
        """
        
        executeQuery(createUsersTable)
        executeQuery(createCoursesTable)
        executeQuery(createUserCoursesTable)
        executeQuery(createVideosTable)
        executeQuery(downloadsTable)
    }

    private func executeQuery(_ query: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Query executed successfully: \(query)")
            } else {
                print("Error executing query: \(query)")
            }
        } else {
            print("Error preparing query: \(query)")
        }
        sqlite3_finalize(statement)
    }
    func upsertCourse(userId: Int, videoId: Int, imageUrl: String, videoUrl: String, title: String, isLiked: Int?, isSub: Int?) {
        let selectQuery = "SELECT * FROM Course WHERE user_id = ? AND video_id = ?;"
        let insertQuery = """
        INSERT INTO Course (user_id, video_id, image_url, video_url, title, is_liked, is_sub)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """
        let updateQuery = """
        UPDATE Course
        SET image_url = ?,
            video_url = ?,
            title = ?,
            is_liked = COALESCE(?, is_liked),
            is_sub = COALESCE(?, is_sub)
        WHERE user_id = ? AND video_id = ?;
        """
        var statement: OpaquePointer?

        // 1. Kayıt kontrolü
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId))
            sqlite3_bind_int(statement, 2, Int32(videoId))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                // 2. Eğer kayıt varsa güncelle
                sqlite3_finalize(statement)
                if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_text(statement, 1, (imageUrl as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 2, (videoUrl as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 3, (title as NSString).utf8String, -1, nil)
                    
                    if let isLiked = isLiked {
                        sqlite3_bind_int(statement, 4, Int32(isLiked))
                    } else {
                        sqlite3_bind_null(statement, 4)
                    }
                    
                    if let isSub = isSub {
                        sqlite3_bind_int(statement, 5, Int32(isSub))
                    } else {
                        sqlite3_bind_null(statement, 5)
                    }
                    
                    sqlite3_bind_int(statement, 6, Int32(userId))
                    sqlite3_bind_int(statement, 7, Int32(videoId))
                    
                    if sqlite3_step(statement) == SQLITE_DONE {
                        print("Kurs durumu başarıyla güncellendi.")
                        successCallback?("Başarıyla eklendi.")
                    } else {
                        print("Güncelleme hatası.")
                    }
                }
            } else {
              
                sqlite3_finalize(statement)
                if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
                    sqlite3_bind_int(statement, 1, Int32(userId))
                    sqlite3_bind_int(statement, 2, Int32(videoId))
                    sqlite3_bind_text(statement, 3, (imageUrl as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 4, (videoUrl as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 5, (title as NSString).utf8String, -1, nil)
                    
                    if let isLiked = isLiked {
                        sqlite3_bind_int(statement, 6, Int32(isLiked))
                    } else {
                        sqlite3_bind_null(statement, 6)
                    }
                    
                    if let isSub = isSub {
                        sqlite3_bind_int(statement, 7, Int32(isSub))
                    } else {
                        sqlite3_bind_null(statement, 7)
                    }

                    if sqlite3_step(statement) == SQLITE_DONE {
                        print("Yeni kurs başarıyla kaydedildi.")
                        successCallback?("Başarıyla eklendi.")
                    } else {
                        print("Kurs ekleme hatası.")
                    }
                }
            }
        } else {
            print("Sorgu hazırlanırken hata oluştu.")
        }

        sqlite3_finalize(statement)
    }


 
    func getWishListCourses(forUserId userId: Int) -> [MyCourse] {
        let query = "SELECT video_id, image_url, video_url, title, is_liked, is_sub FROM Course WHERE user_id = ? AND is_liked = 1;"
        var statement: OpaquePointer?
        var courses: [MyCourse] = []

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId)) // userId'yi bind et

            while sqlite3_step(statement) == SQLITE_ROW {
                let videoId = Int(sqlite3_column_int(statement, 0))
                let imageUrl = String(cString: sqlite3_column_text(statement, 1))
                let videoUrl = String(cString: sqlite3_column_text(statement, 2))
                let title = String(cString: sqlite3_column_text(statement, 3))
                let isLiked = Int(sqlite3_column_int(statement, 4))
                let isSub = Int(sqlite3_column_int(statement, 5))

               
                let course = MyCourse(userId: userId, videoId: videoId, imageUrl: imageUrl, videoUrl: videoUrl, title: title, isLiked: isLiked, isSub: isSub)
                courses.append(course)
            }
        } else {
            print("Sorgu hazırlama hatası.")
        }

        sqlite3_finalize(statement)
        return courses
    }
    func getSubscribedCourses(forUserId userId: Int) -> [MyCourse] {
        let query = "SELECT video_id, image_url, video_url, title, is_liked, is_sub FROM Course WHERE user_id = ? AND is_sub = 1;"
        var statement: OpaquePointer?
        var courses: [MyCourse] = []

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(userId)) // userId'yi bind et

            while sqlite3_step(statement) == SQLITE_ROW {
                let videoId = Int(sqlite3_column_int(statement, 0))
                let imageUrl = String(cString: sqlite3_column_text(statement, 1))
                let videoUrl = String(cString: sqlite3_column_text(statement, 2))
                let title = String(cString: sqlite3_column_text(statement, 3))
                let isLiked = Int(sqlite3_column_int(statement, 4))
                let isSub = Int(sqlite3_column_int(statement, 5))

               
                let course = MyCourse(userId: userId, videoId: videoId, imageUrl: imageUrl, videoUrl: videoUrl, title: title, isLiked: isLiked, isSub: isSub)
                courses.append(course)
            }
        } else {
            print("Sorgu hazırlama hatası.")
        }

        sqlite3_finalize(statement)
        return courses
    }
    
    func insertToDownloadsTable(userId:String,videoId:String, title:String, image: UIImage) {
        let query = "INSERT INTO Downloads (userId, videoId, title, image) VALUES (?, ?, ?, ?);"
        var statement: OpaquePointer?
                print( "burada")
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            
                   // Görüntüyü NSData'ya çevir
                   let imageData = image.jpegData(compressionQuality: 1.0)! as NSData
                   sqlite3_bind_text(statement, 1, (userId as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 2, (videoId as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(statement, 3, (title as NSString).utf8String, -1, nil)
                   sqlite3_bind_blob(statement, 4, imageData.bytes, Int32(imageData.length), nil)

                   if sqlite3_step(statement) == SQLITE_DONE {
                       print("Görüntü başarıyla kaydedildi.")
                   } else {
                       print("Görüntü ekleme hatası.")
                       errorCallback?("Tablo eklenirken bir hata olustu")
                   }
               }
        
        // Belleği serbest bırakma
        sqlite3_finalize(statement)
    }
    
    func fetchAllDownloads() -> [(userId: String, videoId: String, title: String, image: UIImage)] {
        let query = "SELECT userId, videoId, title, image FROM Downloads;"
        var statement: OpaquePointer?
        var downloads: [(userId: String, videoId: String, title: String, image: UIImage)] = []

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                // userId sütununu oku
                let userId = String(cString: sqlite3_column_text(statement, 0))
                // videoId sütununu oku
                let videoId = String(cString: sqlite3_column_text(statement, 1))
                // title sütununu oku
                let title = String(cString: sqlite3_column_text(statement, 2))
                // image sütununu oku
                if let imageData = sqlite3_column_blob(statement, 3) {
                    let imageSize = sqlite3_column_bytes(statement, 3)
                    let data = Data(bytes: imageData, count: Int(imageSize))
                    if let image = UIImage(data: data) {
                        // Her bir satırı tuple olarak ekle
                        downloads.append((userId: userId, videoId: videoId, title: title, image: image))
                    }
                }
            }
        } else {
            print("Sorgu hazırlanamadı.")
            errorCallback?("Sorgu hazırlanamadı.")
        }

        // Belleği serbest bırakma
        sqlite3_finalize(statement)
        return downloads
    }

    func insertUser(email: String, password: String, name: String, surname: String, isSuccess: (Bool) -> ()) {
         
        let query = "INSERT INTO User (email, password, name, surname) VALUES (?, ?, ?, ?);"
        var statement: OpaquePointer?

        // Hazırlama işlemi
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing insert statement: \(errorMessage)")
            isSuccess(false)
            return
        }
        sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
        sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
        sqlite3_bind_text(statement, 3, (name as NSString).utf8String, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
        sqlite3_bind_text(statement, 4, (surname as NSString).utf8String, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))


        // SQL ifadesini yürütme
        if sqlite3_step(statement) == SQLITE_DONE {
            print("User inserted successfully.")
            isSuccess(true)
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error inserting user: \(errorMessage)")
            errorCallback?("Tablo eklenirken bir hata olustu")
            isSuccess(false)
        }

        // Belleği serbest bırakma
        sqlite3_finalize(statement)
    }

    func fetchUserByEmail(email: String) -> User? {
        let query = "SELECT id, email, password, name, surname FROM User WHERE email = ?;"
        var statement: OpaquePointer?

        // Kullanıcı bilgilerini tutacak değişken
        var user: User?

        // SQL sorgusunu hazırlama
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            // Sorguya e-posta parametresini bağlama
            sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, nil)

            // Sorguyu yürütme ve sonuçları işleme
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let email = String(cString: sqlite3_column_text(statement, 1))
                let password = String(cString: sqlite3_column_text(statement, 2))
                let name = String(cString: sqlite3_column_text(statement, 3))
                let surname = String(cString: sqlite3_column_text(statement, 4))

                // User modeli oluştur
                user = User(id: id, email: email, password: password, name: name, surname: surname)
            } else {
                print("No user found with the provided email.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing fetch statement: \(errorMessage)")
         
        }

        // Sorguyu temizle
        sqlite3_finalize(statement)

        return user
    }

    deinit {
        if db != nil {
            sqlite3_close(db)
        }
    }

    func loginUser(email: String, password: String, isSuccess: @escaping (Bool) -> ()) {
        let query = "SELECT * FROM User WHERE email = ? AND password = ?;"
        var statement: OpaquePointer?

        // Hazırlama işlemi
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing login statement: \(errorMessage)")
            isSuccess(false)
            return
        }

        // Parametreleri bağlama
        sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
        sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))

        // Sorguyu çalıştırma
        if sqlite3_step(statement) == SQLITE_ROW {
            // Kullanıcı bulundu
            print("Login successful!")
            isSuccess(true)
        } else {
            // Kullanıcı bulunamadı veya şifre yanlış
            print("Invalid email or password.")
            isSuccess(false)
        }

        // Belleği serbest bırakma
        sqlite3_finalize(statement)
    }

    
    func fetchAllUsers() -> [(id: Int, email: String, name: String, surname: String)] {
        let query = "SELECT id, email, name, surname FROM User;"
        var statement: OpaquePointer?
        var users: [(id: Int, email: String, name: String, surname: String)] = []

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let email = String(cString: sqlite3_column_text(statement, 1))
                let name = String(cString: sqlite3_column_text(statement, 2))
                let surname = String(cString: sqlite3_column_text(statement, 3))

                users.append((id: id, email: email, name: name, surname: surname))
            }
        } else {
            print("Error preparing fetch statement.")
        }
        sqlite3_finalize(statement)
        return users
    }
}
