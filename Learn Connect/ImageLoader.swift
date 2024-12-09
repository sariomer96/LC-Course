//
//  ImageLoader.swift
//  Learn Connect
//
//  Created by Omer on 9.12.2024.
//

import Foundation
import UIKit

final class ImageLoader {
     
    static let shared = ImageLoader()
    
    var onImageDownloaded: ((UIImage?) -> Void)?
       
       func fetchImage(from urlString: String) {
           guard let url = URL(string: urlString) else {
               print("Geçersiz URL")
               onImageDownloaded?(nil)
               return
           }
           
           URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
               if let error = error {
                   print("Görüntü yükleme hatası: \(error.localizedDescription)")
                   self?.onImageDownloaded?(nil)
                   return
               }
               
               guard let data = data, let image = UIImage(data: data) else {
                   print("Görüntü verisi hatalı")
                   self?.onImageDownloaded?(nil)
                   return
               }
                
               DispatchQueue.main.async {
                   self?.onImageDownloaded?(image)
               }
           }.resume()
       }
}
