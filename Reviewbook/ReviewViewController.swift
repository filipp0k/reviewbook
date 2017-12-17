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
    @IBOutlet weak var InputCurrency: UITextField!
    @IBOutlet weak var OutputCurrency: UILabel!
    
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
        let dscr = TextView.text ?? ""
        var prc = 0.00
        if let x = InputCurrency.text {
            prc = Double(x)!
        }
//        if let inputprc = InputCurrency.text {
//            prc = Double(inputprc)!
//        }
        //let prc = Double(InputCurrency.text)
        
        review = Review(name: name, dscr: dscr, photo: photo, rating: rating, prc: prc)
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
            TextView.text = review.dscr
            InputCurrency.text = String(review.prc)
        }
        updateSaveButtonState()
        
        requestCurrentCurrencyRate()
        requestCurrenciesRates(baseCurrency: "RUB") { (data, error) in }
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
        
        requestCurrentCurrencyRate()
    }
    
    
    
     let baseCurrency = "RUB"
     let toCurrency = "USD"
     
     func requestCurrenciesRates(baseCurrency: String, parseHandler: @escaping (Data?, Error?) -> Void){
        let url = URL(string: "https://api.fixer.io/latest?base=" + baseCurrency)!
        let dataTask = URLSession.shared.dataTask(with: url){
            (dataRecieved, response, error) in
            parseHandler(dataRecieved, error)
        }
        dataTask.resume();
     }
     func parseCurrencyRatesResponse(data: Data?, toCurrency: String) -> String {
        var value : String = ""
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>
            if let parsedJSON = json
            {
                print("\(parsedJSON)")
                if let rates = parsedJSON["rates"] as? Dictionary<String, Double>
                {
                    print(rates)
                    if let rate = rates[toCurrency] { value = "\(rate)" }
                    else { value = "No rate for currency \"\(toCurrency)\" found" }
                } else { value = "No \"rates\" found" }
            }
            else { value = "No JSON value parsed" }
        } catch { value = error.localizedDescription }
        return value
     }
     
     func retieveCurrencyRate(baseCurrency: String, toCurrency: String, completion: @escaping (String) -> Void) {
        self.requestCurrenciesRates(baseCurrency: baseCurrency) {
            [weak self] (data, error) in
            var string = "No currency retrieved!"
            if let currentError = error {
                string = currentError.localizedDescription
            } else {
                if let strongSelf = self {
                    string = strongSelf.parseCurrencyRatesResponse(data: data, toCurrency: toCurrency)
                }
            }
            completion(string)
        }
     }
    func requestCurrentCurrencyRate() {
        self.retieveCurrencyRate(baseCurrency: self.baseCurrency, toCurrency: self.toCurrency) {
            [weak self] (value) in
            DispatchQueue.main.async {
                if let strongSelf = self {
                    if (strongSelf.InputCurrency.text?.isEmpty)! {
                        strongSelf.OutputCurrency.text = "Here will be $"
                    } else {
                        if let inputmoney = Double(strongSelf.InputCurrency.text!) {
                            let c:String = String(format:"%.2f", inputmoney*Double(value)!)
                            strongSelf.OutputCurrency.text = "Price in: " + c + "$"
                        }
                    }
                }
            }
        }
        
    }
     /*
     override func viewDidLoad() {
     super.viewDidLoad()
     self.label.text = "Здесь будет курс"
     self.activityIndicator.hidesWhenStopped = true
     self.requestCurrentCurrencyRate()
     self.pickerFrom.dataSource = self
     self.pickerTo.dataSource = self
     self.pickerFrom.delegate = self
     self.pickerTo.delegate = self
     }
     }
     
     func requestCurrentCurrencyRate() {
     self.activityIndicator.startAnimating()
     //Чтобы пикеры не скакали можно оставлять текст на месте, просто меняя прозрачность:
     self.label.alpha = 0
     let baseCurrencyIndex = self.pickerFrom.selectedRow(inComponent: 0)
     let toCurrencyIndex = self.pickerTo.selectedRow(inComponent: 0)
     let baseCurrency = self.currencies[baseCurrencyIndex]
     //C помощью строки ниже я убрал баг, когда при удалении валюты она все равно выбиралась для парсера
     let toCurrency = self.currenciesExceptBase()[toCurrencyIndex]
     
     //print("baseCurrencyIndex \(baseCurrencyIndex) toCurrencyIndex \(toCurrencyIndex) \n baseCurrency \(baseCurrency) toCurrency \(toCurrency)")
     
     self.retieveCurrencyRate(baseCurrency: baseCurrency, toCurrency: toCurrency) {
     [weak self] (value) in
     DispatchQueue.main.async {
     if let strongSelf = self {
     strongSelf.label.alpha = 1
     strongSelf.label.text = value
     strongSelf.activityIndicator.stopAnimating()
     }
     }
     }
     
     }
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     self.requestCurrentCurrencyRate()
     if pickerView == pickerFrom {
     self.pickerTo.reloadAllComponents()
     }
     }
     func currenciesExceptBase() -> [String] {
     var currenciesExceptBase = currencies
     currenciesExceptBase.remove(at: pickerFrom.selectedRow(inComponent: 0))
     
     return currenciesExceptBase
     }
 */
    
}

