//
//  FilterSearchPicker.swift
//  FilterSearchPicker
//
//  Created by 陳邦亢 on 2023/7/4.
//

import Foundation
import UIKit
import Combine

class FilterSearchPicker {
    
    //MARK: - properties for outer setting
    var contentStrings: [String]?
    var searchTitle: String?
    var searchPlaceHolder: String?
    var receiveResultString: ((_ result: String) -> Void)?
    
    func show(on view: UIViewController) {
        guard let contents = contentStrings
        else { return }
        
        let vm = FilterSearchPickerViewModel(contentsString: contents)
        
        if let searchTitle = searchTitle {
            vm.title = searchTitle
        }
        
        if let searchPlaceHolder = searchPlaceHolder {
            vm.placeHolder = searchPlaceHolder
        }
        
        if let receiveResultString = receiveResultString {
            vm.receiveResultString = receiveResultString
        }
        
        let pickerVC = FilterSearchPickerViewController(viewModel: vm)
        view.present(pickerVC, animated: true)
    }
}
