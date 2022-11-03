//
//  ImageCache.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 03/11/2022.
//

import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {
        
    }
    
    
    func downloadImage(urlString: String) async -> UIImage? {
        
        let cacheKey = NSString(string: urlString)
        if let cachedImage = cache.object(forKey: cacheKey) { return cachedImage }
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
            
        } catch {
            return nil
        }
    }
    
}
