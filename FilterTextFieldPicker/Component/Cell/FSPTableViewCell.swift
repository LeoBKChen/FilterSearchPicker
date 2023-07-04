//
//  FPTableViewCell.swift
//  FilterTextFieldPicker
//
//  Created by 陳邦亢 on 2023/7/3.
//

import Foundation
import UIKit

class FSPTableViewCell: UITableViewCell {
    static let identifier = "FSPTableViewCell"
    var viewModel: FSPCellViewModel?
    
    
    @IBOutlet weak var contentLabel: UILabel! { didSet {
        contentLabel.font = UIFont.systemFont(ofSize: 18)
    }}
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let viewModel = viewModel else { return }
        configure(with: viewModel)
    }
    
    func configure(with viewModel: FSPCellViewModel) {
        self.viewModel = viewModel
        
        contentLabel.text = viewModel.content
    }
}


