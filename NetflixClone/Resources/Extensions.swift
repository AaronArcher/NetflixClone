//
//  Extensions.swift
//  NetflixClone
//
//  Created by Aaron Johncock on 03/11/2022.
//

import Foundation

extension String {
    func capitaliseFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
