//
//  MediaCollectionViewCell.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 03/11/2022.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MediaCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with posterPath: String) {
        Task {
            self.posterImageView.image = await ImageCache.shared.downloadImage(urlString: "https://image.tmdb.org/t/p/w500/\(posterPath)")
        }
        print(posterPath)
    }
    
}
