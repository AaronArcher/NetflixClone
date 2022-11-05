//
//  MediaTableViewCell.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 05/11/2022.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    static let identifier = "MediaTableViewCell"
    
    private let mediaPosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mediaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playMediaButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mediaPosterImageView)
        contentView.addSubview(mediaLabel)
        contentView.addSubview(playMediaButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        let mediaPosterConstraints = [
            mediaPosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mediaPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mediaPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mediaPosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let mediaLabelConstraints = [
            mediaLabel.leadingAnchor.constraint(equalTo: mediaPosterImageView.trailingAnchor, constant: 20),
            mediaLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playMediaButtonConstraints = [
            playMediaButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playMediaButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(mediaPosterConstraints)
        NSLayoutConstraint.activate(mediaLabelConstraints)
        NSLayoutConstraint.activate(playMediaButtonConstraints)
    }
    
    public func configure(with media: MediaViewModel) {
        Task {
            self.mediaPosterImageView.image = await ImageCache.shared.downloadImage(urlString: "https://image.tmdb.org/t/p/w500/\(media.posterURL)")
        }

        mediaLabel.text = media.mediaName
    }
    
}
