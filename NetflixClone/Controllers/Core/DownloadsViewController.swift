//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 31/10/2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var media = [MediaItem]()

    private let downloadedTable: UITableView = {
        let table = UITableView()
        table.register(MediaTableViewCell.self, forCellReuseIdentifier: MediaTableViewCell.identifier)
        return table
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Downloaded"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadedTable)
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        fetchDownloadedMedia()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchDownloadedMedia()
        }
    }
    
    private func fetchDownloadedMedia() {
        DataPersistenceManager.shared.fetchMedia { [weak self] result in
            switch result {
            case .success(let downloadedMedia):
               
                DispatchQueue.main.async {
                    self?.media = downloadedMedia
                    self?.downloadedTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return media.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier, for: indexPath) as? MediaTableViewCell else {
            return UITableViewCell()
        }
        
        let media = media[indexPath.row]
        cell.configure(with: MediaViewModel(mediaName: media.original_title ?? media.original_name ?? "Unknown", posterURL: media.poster_path ?? ""))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteMediate(model: media[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from database")
                    self?.media.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMedia = media[indexPath.row]
        guard let mediaName = selectedMedia.original_title ?? selectedMedia.original_name else { return }
        
        APICaller.shared.getMovie(with: mediaName) { [weak self] result in
            switch result {
            case .success(let movie):
                
                DispatchQueue.main.async {
                    let vc = MediaPreviewViewController()
                    vc.configure(with: MediaPreviewViewModel(mediaTitle: mediaName, youtubeVideo: movie, mediaOverview: selectedMedia.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
