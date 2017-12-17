//
//  Review.swift
//  Reviewbook
//
//  Created by Филипп Дюдин on 16.12.2017.
//  Copyright © 2017 Филипп Дюдин. All rights reserved.
//

import UIKit
import os.log

class Review: NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var dscr: String
    var photo: UIImage?
    var rating: Int
    var prc: Double
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reviews")
    
    struct PropertyKey {
        static let name = "name"
        static let dscr = "dscr"
        static let photo = "photo"
        static let rating = "rating"
        static let prc = "prc"
    }
    //MARK: Initialisation
    init?(name: String, dscr: String, photo: UIImage?, rating: Int, prc: Double) {
        
        // Initialization is failing:
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        if dscr.isEmpty {
            self.dscr = ""
        } else {
            self.dscr = dscr
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        self.prc = prc
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(dscr, forKey: PropertyKey.dscr)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(prc, forKey: PropertyKey.prc)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let dscr = aDecoder.decodeObject(forKey: PropertyKey.dscr) as? String else {
            os_log("Unable to decode DESCRIPTION for a object.", log: OSLog.default, type: .debug)
            return nil
        }
        //let dscr = aDecoder.decodeObject(forKey: PropertyKey.dscr) as! String
        // Because photo is an optional property, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        let prc = aDecoder.decodeFloat(forKey: PropertyKey.prc)
        self.init(name: name, dscr: dscr, photo: photo, rating: rating, prc: Double(prc))
        
    }
}
