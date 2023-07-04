//
//  ViewController.swift
//  FilterTextFieldPicker
//
//  Created by 陳邦亢 on 2023/6/29.
//

import UIKit
import CountryPicker

class ViewController: UIViewController, CountryPickerDelegate {

    @IBOutlet weak var CountryTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        CountryTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    func countryPicker(didSelect country: CountryPicker.Country) {
        CountryTextField.text = country.isoCode.getFlag() + " " + country.localizedName
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view.endEditing(true)

        let ds = CountryManager.shared.getCountries().map {
            $0.localizedName
        }
        
        let picker = FilterSearchPicker()
        
        picker.contentStrings = ds
        picker.receiveResultString = { result in
            self.CountryTextField.text = result
        }
        picker.searchPlaceHolder = "Search...."
        picker.searchTitle = "Country"
        
        picker.show(on: self)
        return false
    }
}
