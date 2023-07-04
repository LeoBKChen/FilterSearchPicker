//
//  FilterPickerViewModel.swift
//  FilterPickerViewModel
//
//  Created by 陳邦亢 on 2023/6/29.
//

import Foundation
import Combine

class FilterSearchPickerViewModel {
    
    // MARK: - view controller ui
    var contentsString: [String]
    var title: String
    var placeHolder: String
    
    @Published var config: FilterSearchPickerConfiguration = LightSearchFilterPickerConfiguration()
    @Published var dataSource: [FSPCellViewModel] = []
    @Published var filterString: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var tapOnCell = PassthroughSubject<FSPCellViewModel, Never>()
    
    init(contentsString: [String] = [], title: String = "", placeHolder: String = "Type in..") {
        self.contentsString = contentsString
        
        self.title = title
        self.placeHolder = placeHolder
        self.dataSource = transform(contentsString)
        
        bind()
    }
    
    @objc func filterTextChanged(to text: String) {
        filterString = text
    }
    
    
    //MARK: - result interfaces
    var receiveResultString: ((_ result: String) -> Void)?
    
}

extension FilterSearchPickerViewModel {
    func bind() {
        tapOnCell
            .receive(on: RunLoop.main)
            .sink { [weak self] cellVM in
                guard let self = self,
                      let resultClosure = self.receiveResultString
                else { return }
                
                resultClosure(cellVM.content)
            }
            .store(in: &cancellables)
    }
}

extension FilterSearchPickerViewModel: FSPCellViewModelDelegate {
    func transform(_ contents: [String]) -> [FSPCellViewModel] {
        contents.map {
            FSPCellViewModel(content: $0)
        }
    }
}
