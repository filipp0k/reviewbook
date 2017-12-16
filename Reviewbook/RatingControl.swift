//
//  RatingControl.swift
//  Reviewbook
//
//  Created by Филипп Дюдин on 15.12.2017.
//  Copyright © 2017 Филипп Дюдин. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    //MARK: Properities
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 55.0, height: 55.0)
    @IBInspectable var starCount: Int = 5
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    
    //MARK: Actions and Updates
    @objc func ratingButtonTapped(button: UIButton) {
        let index = ratingButtons.index(of: button)!
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If selected star represents the current rating, reset rating to 0.
            rating = 0
        } else {
            // Else set rating to selected star.
            rating = selectedRating
        }
    }
    
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If  index of a button is less than the rating, that button makes selected.
            button.isSelected = index < rating
        }
    }
    
    
    //MARK: Presenting buttons in view
    private func setupButtons() {
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "FilledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"EmptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"HighlitedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
        let button = UIButton()
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
        // constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
        //Action Handler
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
        // Add the button to the stack
        addArrangedSubview(button)
        ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    

}
