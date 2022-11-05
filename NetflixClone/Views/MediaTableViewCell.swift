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
            mediaPosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            mediaPosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            mediaPosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let mediaLabelConstraints = [
            mediaLabel.leadingAnchor.constraint(equalTo: mediaPosterImageView.trailingAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(mediaPosterConstraints)
        
    }
    
    public func configure(with media: MediaViewModel) {
        Task {
            self.mediaPosterImageView.image = await ImageCache.shared.downloadImage(urlString: media.posterURL)
        }
        mediaLabel.text = media.mediaName
    }
    
}
