//
//  ViewController.swift
//  Reviewbook
//
//  Created by Филипп Дюдин on 15.12.2017.
//  Copyright © 2017 Филипп Дюдин. All rights reserved.
//

import UIKit
import os.log
class ReviewViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var review: Review?
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var RatingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func CancelButton(_ sender: Any) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ReviewViewController is not inside a navigation controller.")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        //print("Does it work?")
        view.endEditing(true)
        //Name.resignFirstResponder()
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = Name.text ?? ""
        let photo = Image.image
        let rating = RatingControl.rating
        let description = TextView.text ?? ""
        
        review = Review(name: name, description: description, photo: photo, rating: rating)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Name.delegate = self
        // Set up views if editing an existing review.
        if let review = review {
            navigationItem.title = review.name
            Name.text = review.name
            Image.image = review.photo
            RatingControl.rating = review.rating
            TextView.text = review.description
        }
        updateSaveButtonState()
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        Image.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    private func updateSaveButtonState() {
        let text = Name.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

