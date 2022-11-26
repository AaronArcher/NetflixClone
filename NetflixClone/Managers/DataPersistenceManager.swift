//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 22/11/2022.
//

import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDelete
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadMedia(with model: Media, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MediaItem(context: context)
        item.original_title = model.original_title
        item.original_name = model.original_name
        item.id = Int64(model.id)
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchMedia(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MediaItem>
        request = MediaItem.fetchRequest()
        
        do {
            
            let downloadedMedia = try context.fetch(request)
            completion(.success(downloadedMedia))
            
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteMediate(model: MediaItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDelete))
        }
        
    }
    
}
