//
//  Review.swift
//  Reviewbook
//
//  Created by Филипп Дюдин on 16.12.2017.
//  Copyright © 2017 Филипп Дюдин. All rights reserved.
//

import UIKit

class Review {
    
    
    init?(name: String, description: String, photo: UIImage?, rating: Int) {
        
        // Initialization is failing:
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.description = description
        self.photo = photo
        self.rating = rating
        
    }
    
    //MARK: Properties
    var name: String
    var description: String
    var photo: UIImage?
    var rating: Int
    
    
}
