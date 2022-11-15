//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 13/11/2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: MediaPreviewViewModel)
}

class SearchResultsViewController: UIViewController {

    var media = [Media]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchResultsCollectionView)
        view.backgroundColor = .systemBackground
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else { return UICollectionViewCell() }
        
        let chosenMedia = media[indexPath.row]
        cell.configure(with: chosenMedia.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedMovie = media[indexPath.row]
        let movieName = selectedMovie.original_title ?? ""
        
        APICaller.shared.getMovie(with: movieName) { [weak self] result in
            switch result {
            case .success(let movie):
                
                self?.delegate?.searchResultsViewControllerDidTapItem(MediaPreviewViewModel(mediaTitle: selectedMovie.original_title ?? "", youtubeVideo: movie, mediaOverview: selectedMovie.overview ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
}
