//
//  FPCellViewModel.swift
//  FilterTextFieldPicker
//
//  Created by 陳邦亢 on 2023/7/3.
//

import Foundation
import Combine

protocol FSPCellViewModelDelegate {
    func transform(_ contents: [String]) -> [FSPCellViewModel]
}

struct FSPCellViewModel {
    let cellID = UUID() // Hashable
    var content: String = ""
}

extension FSPCellViewModel: Hashable {
    static func == (lhs: FSPCellViewModel, rhs: FSPCellViewModel) -> Bool {
        return lhs.cellID == rhs.cellID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(cellID)
    }
}
