//
//  FilterPickerConfiguration.swift
//  FilterPickerConfiguration
//
//  Created by 陳邦亢 on 2023/6/29.
//

import Foundation
import UIKit

protocol FilterSearchPickerConfiguration {
    var contentTextColor: UIColor { get set }
    var contentTextFont: UIFont { get set }
    var closeButtonTextColor: UIColor { get set }
    var closeButtonFont: UIFont { get set }
    var closeButtonText: String { get set }
    var titleTextColor: UIColor { get set }
    var titleFont: UIFont { get set }
    var searchBarPlaceholder: String { get set }
    var searchBarBackgroundColor: UIColor { get set }
    var searchBarPlaceholderColor: UIColor { get set }
    var searchBarFont: UIFont { get set }
    var searchBarLeftImage: UIImage { get set }
    var searchBarCornerRadius: CGFloat { get set }
    var separatorColor: UIColor { get set }
}

public struct LightSearchFilterPickerConfiguration: FilterSearchPickerConfiguration {
    var contentTextColor: UIColor = .black
    
    var contentTextFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    var closeButtonTextColor: UIColor = .black
    
    var closeButtonFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    var closeButtonText: String = "Close"
    
    var titleTextColor: UIColor = .black
    
    var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
    
    var searchBarPlaceholder: String = "Search..."
    
    var searchBarBackgroundColor: UIColor = .systemGray5
    
    var searchBarPlaceholderColor: UIColor = .systemGray2
    
    var searchBarFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    var searchBarLeftImage: UIImage = UIImage(systemName: "magnifyingglass")!
    
    var searchBarCornerRadius: CGFloat = 4
    
    var separatorColor: UIColor = .systemGray5
    
}

public struct DarkSearchFilterPickerConfiguration: FilterSearchPickerConfiguration {
    
    var contentTextColor: UIColor
    
    var contentTextFont: UIFont
    
    var closeButtonTextColor: UIColor
    
    var closeButtonFont: UIFont
    
    var closeButtonText: String
    
    var titleTextColor: UIColor
    
    var titleFont: UIFont
    
    var searchBarPlaceholder: String
    
    var searchBarBackgroundColor: UIColor
    
    var searchBarPlaceholderColor: UIColor
    
    var searchBarFont: UIFont
    
    var searchBarLeftImage: UIImage
    
    var searchBarCornerRadius: CGFloat
    
    var separatorColor: UIColor
    
}
